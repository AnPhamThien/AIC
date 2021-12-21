abstract class FormSubmissionStatus {
  const FormSubmissionStatus();
}

class InitialFormStatus extends FormSubmissionStatus {
  const InitialFormStatus();
}

class FinishInitializing extends FormSubmissionStatus {}

class FormSubmitting extends FormSubmissionStatus {}

class FormValidating extends FormSubmissionStatus {}

class FormValidationSuccess extends FormSubmissionStatus {}

class FormValidationFailed extends FormSubmissionStatus {}

class FormSubmissionSuccess extends FormSubmissionStatus {}

class FormSubmissionFailed extends FormSubmissionStatus {
  final Exception exception;

  FormSubmissionFailed(this.exception);
}

class FormCodeResendSuccess extends FormSubmissionStatus {}
