part of 'conversation_bloc.dart';

class NotificationState {
  final List<NotificationItem>? notificationList;
  final FormSubmissionStatus formStatus;

  NotificationState({
    this.notificationList,
    this.formStatus = const InitialFormStatus(),
  });

  NotificationState copyWith({
    List<NotificationItem>? notificationList,
    FormSubmissionStatus? formStatus,
  }) {
    return NotificationState(
        notificationList: notificationList ?? this.notificationList,
        formStatus: formStatus ?? this.formStatus);
  }
}
