part of 'reset_password_bloc.dart';

abstract class ResetPasswordEvent {
  const ResetPasswordEvent();
}

class ResetPasswordSubmitted extends ResetPasswordEvent {
  const ResetPasswordSubmitted(this.password);

  final String password;
}
