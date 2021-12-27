part of 'auth_bloc.dart';

class AuthState extends Equatable {
  const AuthState({this.authStatus = const InitialAuthenticationStatus()});

  final AuthenticationStatus authStatus;

  AuthState copyWith({AuthenticationStatus? authStatus}) {
    return AuthState(
      authStatus: authStatus ?? this.authStatus,
    );
  }

  @override
  List<Object?> get props => [authStatus];
}
