part of 'auth_bloc.dart';

class AuthState {
  const AuthState({
    this.authStatus = const InitialAuthenticationStatus(),
    this.reconnected = false,
    this.user,
  });

  final AuthenticationStatus authStatus;
  final bool reconnected;
  final User? user;

  AuthState copyWith({
    AuthenticationStatus? authStatus,
    bool? reconnected,
    User? user,
  }) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
      reconnected: reconnected ?? this.reconnected,
      user: user ?? this.user,
    );
  }
}
