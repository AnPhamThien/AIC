part of 'login_bloc.dart';

class LoginState {
  const LoginState({
    this.formStatus = const InitialStatus(),
    this.user,
  });

  final LoginStatus formStatus;
  final User? user;

  LoginState copyWith({LoginStatus? formStatus, User? user}) {
    return LoginState(
        formStatus: formStatus ?? this.formStatus, user: user ?? this.user);
  }
}

abstract class LoginStatus {
  const LoginStatus();
}

class InitialStatus extends LoginStatus {
  const InitialStatus();
}

class FormSubmissionSuccess extends LoginStatus {}

class FormSubmitting extends LoginStatus {}

class ErrorStatus extends LoginStatus {
  final Exception exception;
  ErrorStatus(this.exception);
}
