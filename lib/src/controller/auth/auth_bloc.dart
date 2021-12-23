import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/controller/auth/authentication_status.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';

import 'package:imagecaptioning/src/repositories/data_repository.dart';
import 'package:imagecaptioning/src/signalr/signalr_helper.dart';
import 'package:signalr_core/signalr_core.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GlobalKey<NavigatorState> navigatorKey;
  final SignalRHelper _signalRHelper;

  AuthBloc(this.navigatorKey)
      : _signalRHelper = SignalRHelper(),
        super(const AuthState()) {
    on<NavigateToPageEvent>(_onNavigate);
    on<AuthenticateEvent>(_onAuthenticate);
    on<LogoutEvent>(_onLogout);
    on<ReconnectSignalREvent>(_onReconnectSignalR);
  }

  void _onNavigate(NavigateToPageEvent event, Emitter emit) {
    bool authen = false;
    if (AppRouter.noAuthNeededScreens.contains(event.route)) {
      authen = true;
    } else if (state.authStatus is AuthenticationAuthenticated) {
      authen = true;
    }
    if (authen) {
      navigatorKey.currentState!.pushNamed(event.route, arguments: event.args);
    }
  }

  void _onAuthenticate(AuthenticateEvent event, Emitter emit) async {
    DataRepository.setJwtInHeader();
    await _signalRHelper.initiateConnection();
    emit(state.copyWith(
        authStatus: AuthenticationAuthenticated(),
        hubConnection: _signalRHelper.hubConnection));
    navigatorKey.currentState!.pushNamed(AppRouter.rootScreen);
  }

  void _onLogout(LogoutEvent event, Emitter emit) {
    emit(state.copyWith(authStatus: AuthenticationUnauthenticated()));
    getIt<AppPref>().setToken("");
    getIt<AppPref>().setRefreshToken("");
    DataRepository.setJwtInHeader();
    _signalRHelper.closeConnection();
    navigatorKey.currentState!.pushNamed(AppRouter.loginScreen);
  }

  void _onReconnectSignalR(ReconnectSignalREvent event, Emitter emit) async {
    await _signalRHelper.initiateConnection();
    emit(state.copyWith(hubConnection: _signalRHelper.hubConnection));
  }
}
