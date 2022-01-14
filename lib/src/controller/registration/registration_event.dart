part of 'registration_bloc.dart';

abstract class RegistrationEvent {
  const RegistrationEvent();
}

class RegistrationSubmitted extends RegistrationEvent {
  const RegistrationSubmitted(this.username, this.password, this.email);

  final String username;
  final String password;
  final String email;
}
