part of 'verification_bloc.dart';

class VerificationState {
  const VerificationState({
    this.formStatus = const InitialFormStatus(),
  });

  final FormSubmissionStatus formStatus;

  VerificationState copyWith({
    FormSubmissionStatus? formStatus,
  }) {
    return VerificationState(formStatus: formStatus ?? this.formStatus);
  }
}
