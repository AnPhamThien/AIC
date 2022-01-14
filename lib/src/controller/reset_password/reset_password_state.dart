part of 'reset_password_bloc.dart';

class ResetPasswordState {
  ResetPasswordState({
    this.formStatus = const InitialStatus(),
  });

  final ResetPasswordStatus formStatus;

  ResetPasswordState copyWith({
    ResetPasswordStatus? formStatus,
  }) {
    return ResetPasswordState(formStatus: formStatus ?? this.formStatus);
  }
}

abstract class ResetPasswordStatus {
  const ResetPasswordStatus();
}

class InitialStatus extends ResetPasswordStatus {
  const InitialStatus();
}

class FormSubmissionSuccess extends ResetPasswordStatus {}

class ErrorStatus extends ResetPasswordStatus {
  final Exception exception;
  ErrorStatus(this.exception);
}
