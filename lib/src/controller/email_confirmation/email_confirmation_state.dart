part of 'email_confirmation_bloc.dart';

class EmailConfirmationState {
  const EmailConfirmationState(
      {this.formStatus = const InitialStatus(),
      required this.userId,
      this.absorbing = false});

  final EmailConfirmationStatus formStatus;
  final String userId;
  final bool absorbing;

  EmailConfirmationState copyWith(
      {EmailConfirmationStatus? formStatus, String? userId, bool? absorbing}) {
    return EmailConfirmationState(
        formStatus: formStatus ?? this.formStatus,
        userId: userId ?? this.userId,
        absorbing: absorbing ?? this.absorbing);
  }
}

abstract class EmailConfirmationStatus {
  const EmailConfirmationStatus();
}

class InitialStatus extends EmailConfirmationStatus {
  const InitialStatus();
}

class FormSubmissionSuccess extends EmailConfirmationStatus {}

class ResendCodeSuccess extends EmailConfirmationStatus {}

class ErrorStatus extends EmailConfirmationStatus {
  final Exception exception;
  ErrorStatus(this.exception);
}
