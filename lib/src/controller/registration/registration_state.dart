part of 'registration_bloc.dart';

class RegistrationState {
  RegistrationState({
    this.formStatus = const InitialFormStatus(),
  });

  final FormSubmissionStatus formStatus;

  RegistrationState copyWith({
    FormSubmissionStatus? formStatus,
  }) {
    return RegistrationState(formStatus: formStatus ?? this.formStatus);
  }
}
