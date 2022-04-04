import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/constant/error_message.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/controller/auth/authentication_status.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/model/user/user.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:imagecaptioning/src/repositories/auth/auth_repository.dart';
import 'package:imagecaptioning/src/repositories/conversation/conversation_repostitory.dart';

import 'package:imagecaptioning/src/repositories/data_repository.dart';
import 'package:imagecaptioning/src/signalr/signalr_helper.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GlobalKey<NavigatorState> navigatorKey;
  final SignalRHelper _signalRHelper;
  final AuthRepository _authRepository;
  final ConversationRepository _conversationRepository;

  AuthBloc(this.navigatorKey)
      : _signalRHelper = SignalRHelper(navigatorKey),
        _authRepository = AuthRepository(),
        _conversationRepository = ConversationRepository(),
        super(const AuthState()) {
    on<NavigateToPageEvent>(_onNavigate);
    on<AuthenticateEvent>(_onAuthenticate);
    on<LogoutEvent>(_onLogout);
    on<ForceLogoutEvent>(_onForceLogout);
    on<ReconnectSignalREvent>(_onReconnectSignalR);
    on<CheckMessageAndNoti>(_onCheckMessageAndNoti);
  }

  void _onNavigate(NavigateToPageEvent event, Emitter emit) {
    bool authen = false;
    if (AppRouter.noAuthNeededScreens.contains(event.route)) {
      authen = true;
    } else if (state.status is AuthenticationAuthenticated) {
      authen = true;
    }
    if (authen) {
      navigatorKey.currentState!.pushNamed(event.route, arguments: event.args);
    }
  }

  void _onAuthenticate(AuthenticateEvent event, Emitter emit) async {
    try {
    DataRepository.setJwtInHeader();
    final user = event.user;
    bool newMessage = await checkMessage();
    emit(state.copyWith(
      status: AuthenticationAuthenticated(),
      user: user,
      newMessage: newMessage
    ));
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

      getIt<AppPref>().setToken("");
      getIt<AppPref>().setRefreshToken("");
      getIt<AppPref>().setUsername("");
      getIt<AppPref>().setUserID("");
      DataRepository.setJwtInHeader();
    } catch (e) {
      log(e.toString());
    }
  }

  void _onForceLogout(ForceLogoutEvent event, Emitter emit) async {
    try {
      await _signalRHelper.unregisterAll();
      emit(state.copyWith(status: AuthenticationUnauthenticated()));
      

      getIt<AppPref>().setToken("");
      getIt<AppPref>().setRefreshToken("");
      getIt<AppPref>().setUsername("");
      getIt<AppPref>().setUserID("");
      DataRepository.setJwtInHeader();
    } catch (e) {
      log(e.toString());
    } finally {
      navigatorKey.currentState!.pushNamed(AppRouter.loginScreen);
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
    emit(state.copyWith(
      newMessage: newMessage
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
}
