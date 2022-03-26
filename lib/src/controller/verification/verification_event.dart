part of 'verification_bloc.dart';

abstract class VerificationEvent {
  const VerificationEvent();
}

class VerificationSubmitted extends VerificationEvent {
  const VerificationSubmitted(this.code);

  final String code;
}

class VerificationResendButtonPushed extends VerificationEvent {
  const VerificationResendButtonPushed();
}

class VerificationResendButtonRestart extends VerificationEvent {
  const VerificationResendButtonRestart();
}
