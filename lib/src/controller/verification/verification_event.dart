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

class TimerStarted extends VerificationEvent {
  const TimerStarted({required this.duration});
  final int duration;
}

class TimerPaused extends VerificationEvent {
  const TimerPaused();
}

class TimerResumed extends VerificationEvent {
  const TimerResumed();
}

class TimerReset extends VerificationEvent {
  const TimerReset();
}

class TimerTicked extends VerificationEvent {
  const TimerTicked({required this.duration});
  final int duration;
}
