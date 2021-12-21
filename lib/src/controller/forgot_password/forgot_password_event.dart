part of 'forgot_password_bloc.dart';

abstract class ForgotPasswordEvent {
  const ForgotPasswordEvent();
}

class ForgotPasswordSubmitted extends ForgotPasswordEvent {
  const ForgotPasswordSubmitted(this.email);

  final String email;
}
