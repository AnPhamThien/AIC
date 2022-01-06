part of 'auth_bloc.dart';

class AuthState {
  const AuthState({
    this.authStatus = const InitialAuthenticationStatus(),
    this.user,
  });

  final AuthenticationStatus authStatus;
  final User? user;

  AuthState copyWith({
    AuthenticationStatus? authStatus,
    User? user,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      user: user ?? this.user,
    );
  }
}
