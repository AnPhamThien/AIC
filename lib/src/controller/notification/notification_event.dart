part of "notification_bloc.dart";

abstract class NotificationEvent {
  const NotificationEvent();
}

class FetchNotification extends NotificationEvent {}

class FetchMoreNotification extends NotificationEvent {}
