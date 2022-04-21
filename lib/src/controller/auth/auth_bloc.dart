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

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GlobalKey<NavigatorState> navigatorKey;
  final SignalRHelper _signalRHelper;
  final AuthRepository _authRepository;
  final ConversationRepository _conversationRepository;
<<<<<<< HEAD
=======
  final NotificationRepository _notificationRepository;
>>>>>>> origin/NhanNT

  AuthBloc(this.navigatorKey)
      : _signalRHelper = SignalRHelper(navigatorKey),
        _authRepository = AuthRepository(),
        _conversationRepository = ConversationRepository(),
<<<<<<< HEAD
=======
         _notificationRepository = NotificationRepository(),
>>>>>>> origin/NhanNT
        super(const AuthState()) {
    on<NavigateToPageEvent>(_onNavigate);
    on<AuthenticateEvent>(_onAuthenticate);
    on<LogoutEvent>(_onLogout);
    on<ForceLogoutEvent>(_onForceLogout);
    on<ReconnectSignalREvent>(_onReconnectSignalR);
    on<CheckMessageAndNoti>(_onCheckMessageAndNoti);
    on<ChangeReadNotiStatus>(_onChangeReadNotiStatus);
<<<<<<< HEAD
=======
    on<CheckToken>(_onCheckToken);
>>>>>>> origin/NhanNT
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
<<<<<<< HEAD
    final user = event.user;
    bool newMessage = await checkMessage();
    emit(state.copyWith(
      status: AuthenticationAuthenticated(),
      user: user,
      newMessage: newMessage
    ));
=======
    emit(state.copyWith(status: AuthenticationAuthenticated()));
    add(CheckMessageAndNoti());
>>>>>>> origin/NhanNT
    await _signalRHelper.initiateConnection();

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
    try {
      await _signalRHelper.unregisterAll();
      emit(state.copyWith(status: AuthenticationUnauthenticated()));
<<<<<<< HEAD
      

=======
    } catch (e) {
      log(e.toString());
    } finally {
      navigatorKey.currentState!.pushNamedAndRemoveUntil(AppRouter.loginScreen, ModalRoute.withName(AppRouter.loginScreen));
>>>>>>> origin/NhanNT
      getIt<AppPref>().setToken("");
      getIt<AppPref>().setRefreshToken("");
      getIt<AppPref>().setUsername("");
      getIt<AppPref>().setUserID("");
      DataRepository.setJwtInHeader();
      //await _signalRHelper.closeConnection();
    }
  }

  void _onReconnectSignalR(ReconnectSignalREvent event, Emitter emit) async {
    try {
      if (state.status is AuthenticationAuthenticated) {
        String token = getIt<AppPref>().getToken;
        String refreshToken = getIt<AppPref>().getRefreshToken;
        final response = await _authRepository.refreshJwtToken(
            token: token, refreshToken: refreshToken);

        if (response == null) {
          throw Exception("");
        }
        String? data = response.data;
        int? status = response.statusCode;

        if (status == StatusCode.successStatus && data != null) {
          getIt<AppPref>().setToken(data);
          DataRepository.setJwtInHeader();
          await _signalRHelper.initiateConnection();
        } else {
          throw Exception("");
        }
      }
    } catch (_) {
      log("Reconnect Failed: " + _.toString());
      add(ForceLogoutEvent());
    }
  }

  void _onCheckMessageAndNoti(CheckMessageAndNoti event, Emitter emit) async {
    try {
    bool newMessage = await checkMessage();
<<<<<<< HEAD
    emit(state.copyWith(
      newMessage: newMessage
=======
    bool newNoti = await checkNoti();
    emit(state.copyWith(
      newMessage: newMessage,
      newNoti: newNoti
>>>>>>> origin/NhanNT
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

<<<<<<< HEAD
  void _onChangeReadNotiStatus(ChangeReadNotiStatus event, Emitter emit) async {
    try {
    bool newStatus = event.isRead;
=======
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
>>>>>>> origin/NhanNT
    emit(state.copyWith(
      newNoti: newStatus
    ));
    } 
    catch (e) {
      log("Change Noti");
      log(e.toString());
    }
  }
<<<<<<< HEAD
=======

  void _onCheckToken(CheckToken event, Emitter emit) async {
    try {
      String token = getIt<AppPref>().getToken;
      String refreshToken = getIt<AppPref>().getRefreshToken;
      String username = getIt<AppPref>().getUsername;
      String userId = getIt<AppPref>().getUserID;
      if (token.isNotEmpty && refreshToken.isNotEmpty && username.isNotEmpty && userId.isNotEmpty) {
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
          add(AuthenticateEvent());
        } else if(messageCode == MessageCode.tokenIsNotExpired) {
          add(AuthenticateEvent());
        } else {
          throw Exception("RefreshToken expires");
        }    
      } else {
        throw Exception("No token found");
      }
    } 
    catch (e) {
      log("Check token");
      log(e.toString());
    }
  }
>>>>>>> origin/NhanNT
}
