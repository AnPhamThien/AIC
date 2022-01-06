part of 'login_bloc.dart';


class LoginState {
  const LoginState({
    this.formStatus = const InitialFormStatus(),
    this.user,
  });

  final FormSubmissionStatus formStatus;
  final User? user;

  LoginState copyWith({FormSubmissionStatus? formStatus, User? user}) {
    return LoginState(
        formStatus: formStatus ?? this.formStatus, user: user ?? this.user);
  }
}
