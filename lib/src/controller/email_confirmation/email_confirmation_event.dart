part of 'email_confirmation_bloc.dart';

abstract class EmailConfirmationEvent {
  const EmailConfirmationEvent();
}

class EmailConfirmationSubmitted extends EmailConfirmationEvent {
  const EmailConfirmationSubmitted(this.code);

  final String code;
}

class EmailConfirmationResendButtonPushed extends EmailConfirmationEvent {
  const EmailConfirmationResendButtonPushed();
}

class EmailConfirmationResendButtonRestart extends EmailConfirmationEvent {
  const EmailConfirmationResendButtonRestart();
}