part of 'auth_bloc.dart';

abstract class AuthEvent {
  const AuthEvent();
}

class NavigateToPageEvent extends AuthEvent {
  String route;
  Map<String, dynamic>? args;
  void Function()? function;
  NavigateToPageEvent({required this.route, this.args, this.function});
}

class AuthenticateEvent extends AuthEvent {}

class LogoutEvent extends AuthEvent {}

class ForceLogoutEvent extends AuthEvent {}

class ConnectSignalREvent extends AuthEvent {}

class ReconnectSignalREvent extends AuthEvent {}

class FinishReconnectEvent extends AuthEvent {}

class CheckMessageAndNoti extends AuthEvent {}

class ChangeReadNotiStatus extends AuthEvent {
  bool isRead;
  ChangeReadNotiStatus(this.isRead);
}

class CheckToken extends AuthEvent {}
