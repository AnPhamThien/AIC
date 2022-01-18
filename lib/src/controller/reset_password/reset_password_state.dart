part of 'reset_password_bloc.dart';

class ResetPasswordState {
  ResetPasswordState(
      {this.formStatus = const InitialStatus(), required this.userId});

  final ResetPasswordStatus formStatus;
  String userId;

  ResetPasswordState copyWith(
      {ResetPasswordStatus? formStatus, String? userId}) {
    return ResetPasswordState(
        formStatus: formStatus ?? this.formStatus,
        userId: userId ?? this.userId);
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
