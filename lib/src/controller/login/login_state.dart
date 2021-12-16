part of 'login_bloc.dart';

class LoginState {
  const LoginState({
    this.formStatus = const InitialFormStatus(),
  });

  final FormSubmissionStatus formStatus;

  LoginState copyWith({
    FormSubmissionStatus? formStatus,
  }) {
    return LoginState(
      formStatus: formStatus ?? this.formStatus,
    );
  }
}
