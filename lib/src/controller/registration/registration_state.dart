part of 'registration_bloc.dart';

class RegistrationState {
  RegistrationState({
    this.formStatus = const InitialStatus(),
  });

  final RegistrationStatus formStatus;

  RegistrationState copyWith({
    RegistrationStatus? formStatus,
  }) {
    return RegistrationState(formStatus: formStatus ?? this.formStatus);
  }
}

abstract class RegistrationStatus {
  const RegistrationStatus();
}

class InitialStatus extends RegistrationStatus {
  const InitialStatus();
}

class FormSubmissionSuccess extends RegistrationStatus {}

class ErrorStatus extends RegistrationStatus {
  final Exception exception;
  ErrorStatus(this.exception);
}
