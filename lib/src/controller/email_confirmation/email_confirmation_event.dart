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

class TimerStarted extends EmailConfirmationEvent {
  const TimerStarted({required this.duration});
  final int duration;
}

class TimerPaused extends EmailConfirmationEvent {
  const TimerPaused();
}

class TimerResumed extends EmailConfirmationEvent {
  const TimerResumed();
}

class TimerReset extends EmailConfirmationEvent {
  const TimerReset();
}

class TimerTicked extends EmailConfirmationEvent {
  const TimerTicked({required this.duration});
  final int duration;
}
