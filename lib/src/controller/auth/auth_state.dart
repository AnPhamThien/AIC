part of 'auth_bloc.dart';

class AuthState {
  const AuthState({
    this.status = const InitialAuthenticationStatus(),
    this.newNoti = false,
    this.newMessage = false,
    this.message
  });

  final AuthenticationStatus status;
  final bool newNoti;
  final bool newMessage;
  final String? message;

  AuthState copyWith({
    AuthenticationStatus? status,
    bool? newNoti,
    bool? newMessage,
    String? message
  }) {
    return AuthState(
      status: status ?? this.status,
      newNoti: newNoti ?? this.newNoti,
      newMessage: newMessage ?? this.newMessage,
      message: message ?? this.message
    );
  }
}
