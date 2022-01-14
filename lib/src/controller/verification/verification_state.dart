part of 'verification_bloc.dart';

class VerificationState {
  const VerificationState(
      {this.formStatus = const InitialStatus(), this.absorbing = false});

  final VerificationStatus formStatus;
  final bool absorbing;

  VerificationState copyWith(
      {VerificationStatus? formStatus, bool? absorbing}) {
    return VerificationState(
        formStatus: formStatus ?? this.formStatus,
        absorbing: absorbing ?? this.absorbing);
  }
}

abstract class VerificationStatus {
  const VerificationStatus();
}

class InitialStatus extends VerificationStatus {
  const InitialStatus();
}

class FormSubmissionSuccess extends VerificationStatus {}

class ResendCodeSuccess extends VerificationStatus {}

class ErrorStatus extends VerificationStatus {
  final Exception exception;
  ErrorStatus(this.exception);
}
