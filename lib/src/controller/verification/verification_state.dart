part of 'verification_bloc.dart';

class VerificationState {
  const VerificationState(
      {this.formStatus = const InitialStatus(), this.absorbing = false, required this.userId});

  final VerificationStatus formStatus;
  final bool absorbing;
  final String userId;

  VerificationState copyWith(
      {VerificationStatus? formStatus, bool? absorbing, String? userId}) {
    return VerificationState(
        formStatus: formStatus ?? this.formStatus,
        absorbing: absorbing ?? this.absorbing,
        userId: userId ?? this.userId);
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
