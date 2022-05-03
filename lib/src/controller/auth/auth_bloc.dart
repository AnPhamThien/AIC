import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/constant/error_message.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/controller/auth/authentication_status.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:imagecaptioning/src/repositories/auth/auth_repository.dart';
import 'package:imagecaptioning/src/repositories/conversation/conversation_repostitory.dart';

import 'package:imagecaptioning/src/repositories/data_repository.dart';
import 'package:imagecaptioning/src/repositories/notification/notification_repository.dart';
import 'package:imagecaptioning/src/signalr/signalr_helper.dart';
import 'package:imagecaptioning/src/utils/func.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GlobalKey<NavigatorState> navigatorKey;
  final SignalRHelper _signalRHelper;
  final AuthRepository _authRepository;
  final ConversationRepository _conversationRepository;
  final NotificationRepository _notificationRepository;
  final timeout = const Duration(seconds: 10);
  bool timeoutNeeded = false;


  AuthBloc(this.navigatorKey)
      : _signalRHelper = SignalRHelper(navigatorKey),
        _authRepository = AuthRepository(),
        _conversationRepository = ConversationRepository(),
         _notificationRepository = NotificationRepository(),
        super(const AuthState()) {
    on<NavigateToPageEvent>(_onNavigate);
    on<AuthenticateEvent>(_onAuthenticate);
    on<LogoutEvent>(_onLogout);
    on<ForceLogoutEvent>(_onForceLogout);
    on<ReconnectSignalREvent>(_onReconnectSignalR);
    on<CheckMessageAndNoti>(_onCheckMessageAndNoti);
    on<ChangeReadNotiStatus>(_onChangeReadNotiStatus);
    on<CheckToken>(_onCheckToken);
    on<SendMessageEvent>(_onSendMessageEvent);
  }

  void _onNavigate(NavigateToPageEvent event, Emitter emit) {
    bool authen = false;
    if (AppRouter.noAuthNeededScreens.contains(event.route)) {
      authen = true;
    } else if (state.status is AuthenticationAuthenticated) {
      authen = true;
    }
    log(authen.toString());
    if (authen) {
      navigatorKey.currentState!.pushNamed(event.route, arguments: event.args);
    }
  }

  void _onAuthenticate(AuthenticateEvent event, Emitter emit) async {
    try {
    DataRepository.setJwtInHeader();
    emit(state.copyWith(status: AuthenticationAuthenticated()));
    add(CheckMessageAndNoti());
    await _signalRHelper.initiateConnection();
    timeoutNeeded = true;
    startTimeout();

    navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRouter.rootScreen, ModalRoute.withName(AppRouter.rootScreen));
    } 
    catch (e) {
      emit(state.copyWith(message: MessageCode.genericError));
      log("Authenticate failed");
      log(e.toString());
    }
  }

  void _onLogout(LogoutEvent event, Emitter emit) async {
    try {
      timeoutNeeded = false;
      emit(state.copyWith(status: AuthenticationUnauthenticated()));
      //TODO: add logout screen

      //await _signalRHelper.closeConnection();
      await _signalRHelper.unregisterAll();

      await _authRepository.deleteRefreshToken();

    } catch (e) {
      log(e.toString());
    } finally {
      getIt<AppPref>().setToken("");
      getIt<AppPref>().setRefreshToken("");
      getIt<AppPref>().setUsername("");
      getIt<AppPref>().setUserID("");
      DataRepository.setJwtInHeader();
    }
  }

  void _onForceLogout(ForceLogoutEvent event, Emitter emit) async {
    String message = event.message;
    try {
      timeoutNeeded = false;
      emit(state.copyWith(status: AuthenticationUnauthenticated()));
      await _signalRHelper.unregisterAll();
    } catch (e) {
      log(e.toString());
    } finally {
      emit(state.copyWith(message: message));
      getIt<AppPref>().setToken("");
      getIt<AppPref>().setRefreshToken("");
      getIt<AppPref>().setUsername("");
      getIt<AppPref>().setUserID("");
      DataRepository.setJwtInHeader();
      navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRouter.loginScreen, ModalRoute.withName(AppRouter.loginScreen));
      navigatorKey.currentState!.push(
              PageRouteBuilder(
                barrierDismissible: true,
                opaque: true,
                pageBuilder: (_, anim1, anim2) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actionsAlignment: MainAxisAlignment.center,
        title: const Text('Warning !',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 25,
                color: Colors.black87,
                letterSpacing: 1.25,
                fontWeight: FontWeight.bold)),
        content: Text(message,
            textAlign: TextAlign.left,
            style: const TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w600)),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(navigatorKey.currentState!.context),
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
        ],
      )
              ),
            );
      //await _signalRHelper.closeConnection();
    }
  }

  
  Future<void> tryRefreshToken() async {
    String token = getIt<AppPref>().getToken;
        String refreshToken = getIt<AppPref>().getRefreshToken;
        final response = await _authRepository.refreshJwtToken(
            token: token, refreshToken: refreshToken);

        if (response == null) {
          throw Exception("");
        }
        
        String? data = response.data;
        int? status = response.statusCode;
        String messageCode = response.messageCode ?? '';
          if (status == StatusCode.successStatus && data != null) {
          getIt<AppPref>().setToken(data);
          DataRepository.setJwtInHeader();
        }
        if (status == StatusCode.successStatus || messageCode == MessageCode.tokenIsNotExpired) {
          await _signalRHelper.initiateConnection();
          timeoutNeeded = true;
          startTimeout();
        } else {
          throw Exception(messageCode);
        }
  }

  void _onReconnectSignalR(ReconnectSignalREvent event, Emitter emit) async {
    try {
      timeoutNeeded = false;
      if (state.status is AuthenticationAuthenticated) {
        await tryRefreshToken();
      }
    } catch (_) {
      log("Reconnect Failed: " + _.toString());
      add(ForceLogoutEvent(message: getErrorMessage(_.toString())));
    }
  }

  void _onCheckMessageAndNoti(CheckMessageAndNoti event, Emitter emit) async {
    try {
    bool newMessage = await checkMessage();
    bool newNoti = await checkNoti();
    emit(state.copyWith(
      newMessage: newMessage,
      newNoti: newNoti
    ));
    } 
    catch (e) {
      log("Check Message and Noti");
      log(e.toString());
    }
  }

  Future<bool> checkMessage() async {
    try {
      final conversationData = await _conversationRepository.getConversations();
    if (conversationData != null) {
      if (conversationData.data != null) {
        final lastConv = conversationData.data?.first;
        if ((lastConv?.isSeen == 0) && (lastConv?.sendUserId != getIt<AppPref>().getUserID)) {
          return true;
        }
      }
    }
    return false;
    } catch (e) {
      log("Check Message");
      log(e.toString());
      return false;
    }
  }

  Future<bool> checkNoti() async {
    try {
      final notificationData = await _notificationRepository.getNotification(limit: 1);
    if (notificationData != null) {
      if (notificationData.data != null) {
        final lastNoti = notificationData.data?.first;
        if (lastNoti?.isRead == false) {
          return true;
        }
      }
    }
    return false;
    } catch (e) {
      log("Check Noti");
      log(e.toString());
      return false;
    }
  }

  void _onChangeReadNotiStatus(ChangeReadNotiStatus event, Emitter emit) async {
    try {
    bool newStatus = event.isRead;
    if (!newStatus) {
      final resMessage = await _notificationRepository.updateIsRead();
      if (resMessage == null) {
        throw Exception();
      }

      String message = resMessage.messageCode ?? '';

      if (message.isNotEmpty) {
        throw Exception(message);
      }
    }
    emit(state.copyWith(
      newNoti: newStatus
    ));
    } 
    catch (e) {
      log("Change Noti");
      log(e.toString());
    }
  }

  void _onCheckToken(CheckToken event, Emitter emit) async {
    try {
      String token = getIt<AppPref>().getToken;
      String refreshToken = getIt<AppPref>().getRefreshToken;
      String username = getIt<AppPref>().getUsername;
      String userId = getIt<AppPref>().getUserID;
      if (token.isNotEmpty && refreshToken.isNotEmpty && username.isNotEmpty && userId.isNotEmpty) {
        await tryRefreshToken();
        //add(AuthenticateEvent());

        DataRepository.setJwtInHeader();
        emit(state.copyWith(status: AuthenticationAuthenticated()));
        add(CheckMessageAndNoti());
        navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRouter.rootScreen, ModalRoute.withName(AppRouter.rootScreen));
      } else {
        throw Exception("No token found");
      }
    } 
    catch (e) {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRouter.loginScreen, ModalRoute.withName(AppRouter.loginScreen));
      log("Check token");
      log(e.toString());
    }
  }

  void _onSendMessageEvent(SendMessageEvent event, Emitter emit) async {
    try {
        if (!_signalRHelper.checkIsAlive()) {
        await tryRefreshToken();
        }
        List<dynamic>? args = event.args;
        await _signalRHelper.sendMessage(args);
    } catch (_) {
      log("Reconnect Failed on send message: " + _.toString());
      add(ForceLogoutEvent(message: getErrorMessage(_.toString())));
    }
  }

  Timer startTimeout() {
  var duration = timeout;
  return Timer(duration, handleTimeout);
}

void handleTimeout() {
  log("Signalr check alive " + DateTime.now().toString());
  if (!_signalRHelper.checkIsAlive()) {
    add(ReconnectSignalREvent());
  }

  if (timeoutNeeded) {
    startTimeout();
  }
}
}
