part of "notification_bloc.dart";

class NotificationState {
  final List<NotificationItem>? notificationList;
  final NotificationStatus status;
  final bool hasReachedMax;

  NotificationState(
      {this.notificationList,
      this.status = const InitialStatus(),
      this.hasReachedMax = false});

  NotificationState copyWith(
      {List<NotificationItem>? notificationList,
      NotificationStatus? status,
      bool? hasReachedMax}) {
    return NotificationState(
        notificationList: notificationList ?? this.notificationList,
        status: status ?? this.status,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }
}

abstract class NotificationStatus {
  const NotificationStatus();
}

class InitialStatus extends NotificationStatus {
  const InitialStatus();
}

class FinishInitializing extends NotificationStatus {}

class ReachedMaxedStatus extends NotificationStatus {}

class ErrorStatus extends NotificationStatus {
  final String exception;
  ErrorStatus(this.exception);
}
