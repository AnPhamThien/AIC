part of 'auth_bloc.dart';

class AuthState {
  const AuthState(
      {this.authStatus = const InitialAuthenticationStatus(),
      this.hubConnection});

  final AuthenticationStatus authStatus;
  final HubConnection? hubConnection;

  AuthState copyWith(
      {AuthenticationStatus? authStatus, HubConnection? hubConnection}) {
    return AuthState(
        authStatus: authStatus ?? this.authStatus,
        hubConnection: hubConnection ?? this.hubConnection);
  }
}
