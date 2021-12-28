part of "notification_bloc.dart";

abstract class NotificationEvent {}

class FetchNotification extends NotificationEvent {
  FetchNotification();
}
