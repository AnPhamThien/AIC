part of 'login_bloc.dart';

abstract class LoginEvent {
  const LoginEvent();
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted(this.username, this.password);

  final String username;
  final String password;
}
