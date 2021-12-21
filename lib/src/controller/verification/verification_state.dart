part of 'verification_bloc.dart';

class VerificationState {
  const VerificationState(
      {this.formStatus = const InitialFormStatus(), this.absorbing = false});

  final FormSubmissionStatus formStatus;
  final bool absorbing;

  VerificationState copyWith(
      {FormSubmissionStatus? formStatus, bool? absorbing}) {
    return VerificationState(
        formStatus: formStatus ?? this.formStatus,
        absorbing: absorbing ?? this.absorbing);
  }
}
