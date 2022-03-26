part of 'forgot_password_bloc.dart';

class ForgotPasswordState {
  const ForgotPasswordState({
    this.formStatus = const InitialStatus(),
    this.userId,
    this.email
  });

  final ForgotPasswordStatus formStatus;
  final String? userId;
  final String? email;

  ForgotPasswordState copyWith(
      {ForgotPasswordStatus? formStatus, String? userId, String? email}) {
    return ForgotPasswordState(
        formStatus: formStatus ?? this.formStatus,
        userId: userId ?? this.userId,
        email: email ?? this.email);
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
