part of 'auth_bloc.dart';

class AuthState {
  const AuthState({
    this.status = const InitialAuthenticationStatus(),
<<<<<<< HEAD
    this.user,
=======
>>>>>>> origin/NhanNT
    this.newNoti = false,
    this.newMessage = false,
    this.message
  });

  final AuthenticationStatus status;
<<<<<<< HEAD
  final User? user;
=======
>>>>>>> origin/NhanNT
  final bool newNoti;
  final bool newMessage;
  final String? message;

  AuthState copyWith({
    AuthenticationStatus? status,
<<<<<<< HEAD
    User? user,
=======
>>>>>>> origin/NhanNT
    bool? newNoti,
    bool? newMessage,
    String? message
  }) {
    return AuthState(
      status: status ?? this.status,
<<<<<<< HEAD
      user: user ?? this.user,
=======
>>>>>>> origin/NhanNT
      newNoti: newNoti ?? this.newNoti,
      newMessage: newMessage ?? this.newMessage,
      message: message ?? this.message
    );
  }
}
