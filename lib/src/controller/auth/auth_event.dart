part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class NavigateToPageEvent extends AuthEvent {
  String route;
  Map<String, dynamic>? args;
  NavigateToPageEvent({required this.route, this.args});
}

class AuthenticateEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

class ConnectSignalREvent extends AuthEvent {}

class ReconnectSignalREvent extends AuthEvent {}
