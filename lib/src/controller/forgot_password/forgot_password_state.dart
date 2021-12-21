part of 'forgot_password_bloc.dart';

class ForgotPasswordState {
  const ForgotPasswordState({
    this.formStatus = const InitialFormStatus(),
  });

  final FormSubmissionStatus formStatus;

  ForgotPasswordState copyWith({
    FormSubmissionStatus? formStatus,
  }) {
    return ForgotPasswordState(
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
