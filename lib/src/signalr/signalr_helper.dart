import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/controller/auth/auth_bloc.dart';
import 'package:imagecaptioning/src/controller/conversation/conversation_bloc.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/controller/message/message_bloc.dart';
import 'package:imagecaptioning/src/controller/notification/notification_bloc.dart';
import 'package:imagecaptioning/src/model/conversation/conversation.dart';
import 'package:imagecaptioning/src/model/conversation/message.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:signalr_core/signalr_core.dart';
import 'package:http/http.dart';

class SignalRHelper {
  SignalRHelper(this.navigatorKey);
  static HubConnection? hubConnection;
  final GlobalKey<NavigatorState> navigatorKey;
  static BuildContext? messageContext;
  static BuildContext? conversationContext;
  static BuildContext? notificationContext;

  Future<void> initiateConnection() async {
    try {
      hubConnection = HubConnectionBuilder()
          .withUrl(
              signalrUrl,
              HttpConnectionOptions(
                client: _HttpClient(),
                transport: HttpTransportType.longPolling,
                skipNegotiation: false,
                accessTokenFactory: () async => getIt<AppPref>().getToken,
                logging: (level, message) => log(message),
              ))
          .withAutomaticReconnect()
          .build();

      if (hubConnection?.state != HubConnectionState.connected &&
          hubConnection?.state != HubConnectionState.connecting) {
        //hubConnection?.keepAliveIntervalInMilliseconds = 24 * 60 * 60 * 1000;
        hubConnection?.serverTimeoutInMilliseconds = 24 * 60 * 60 * 1000;
        await hubConnection?.start();
        hubConnection!.onclose(_handleOnClose);
        hubConnection!.on('forcelogout', _handleForceLogout);
        hubConnection!.on('specificnotification', _handleSpecificNotification);
        hubConnection!.on('getMessage', _handleGetMessage);
      }
    } catch (_) {
      log("Fail to initiate connection");
      log(_.toString());
    }
  }

  Future<void> closeConnection() async {
    try {
      if (hubConnection?.state != HubConnectionState.disconnected) {
        await hubConnection?.stop();
      }
    } on Exception catch (_) {
      log("Fail to close connection");
      log(_.toString());
    }
  }

  void _handleOnClose(Exception? e) {
    try {
      navigatorKey.currentContext!
          .read<AuthBloc>()
          .add(ReconnectSignalREvent());
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  void _handleForceLogout(List<dynamic>? parameters) {
    try {
      log("Thang cho hoang anh dam ep tao logout luc " +
          DateTime.now().toString());
      navigatorKey.currentContext!.read<AuthBloc>().add(ForceLogoutEvent());
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  void _handleSpecificNotification(List<dynamic>? parameters) {
    try {
      if (notificationContext != null) {
        notificationContext!.read<NotificationBloc>().add(FetchNotification());
      }
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  Future<void> _handleGetMessage(List<dynamic>? parameters) async {
    try {
      log(parameters.toString());
      if (parameters != null &&
          (conversationContext != null || messageContext != null)) {
        final data = parameters.first;

        if (conversationContext?.read<ConversationBloc?>() != null) {
          final conversation = Conversation.fromJson(data?['conversation']);
          if (conversation.userRealName != null) {
            conversation.userRealName =
                utf8.decode(conversation.userRealName!.runes.toList());
          }

          if (conversation.messageContent != null) {
            conversation.messageContent =
                utf8.decode(conversation.messageContent!.runes.toList());
          }

          conversationContext!
              .read<ConversationBloc>()
              .add(ReceiveNewConversation(conversation));
        }

        if (messageContext?.read<MessageBloc?>() != null) {
          final message = (data?['message'] != null)
              ? Message.fromJson(data?['message'])
              : Message.fromJson(data);
          if (message.content != null) {
            message.content = utf8.decode(message.content!.runes.toList());
          }

          messageContext!.read<MessageBloc>().add(ReceiveNewMessage(message));
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }
}

class _HttpClient extends BaseClient {
  final _httpClient = Client();

  @override
  Future<StreamedResponse> send(BaseRequest request) async {
    try {
      return _httpClient.send(request);
    } catch (_) {
      log("Request failed");
    }
    throw Exception("Request failed");
  }
}
