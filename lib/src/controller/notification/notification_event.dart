part of "notification_bloc.dart";

abstract class NotificationEvent {}

class NotificationInitializing extends NotificationEvent {
  NotificationInitializing();
}
