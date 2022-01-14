part of 'forgot_password_bloc.dart';

class ForgotPasswordState {
  const ForgotPasswordState({
    this.formStatus = const InitialStatus(),
    this.userId,
  });

  final ForgotPasswordStatus formStatus;
  final String? userId;

  ForgotPasswordState copyWith(
      {ForgotPasswordStatus? formStatus, String? userId}) {
    return ForgotPasswordState(
        formStatus: formStatus ?? this.formStatus,
        userId: userId ?? this.userId);
  }
}

abstract class ForgotPasswordStatus {
  const ForgotPasswordStatus();
}

class InitialStatus extends ForgotPasswordStatus {
  const InitialStatus();
}

class FormSubmissionSuccess extends ForgotPasswordStatus {}

class ResendCodeSuccess extends ForgotPasswordStatus {}

class ErrorStatus extends ForgotPasswordStatus {
  final Exception exception;
  ErrorStatus(this.exception);
}
