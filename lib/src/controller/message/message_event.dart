part of 'message_bloc.dart';

abstract class MessageEvent {}

class FetchMessage extends MessageEvent {
  String conversationId;
  String? avatar;
  String? username;
  FetchMessage(this.conversationId, this.avatar, this.username);
}

class FetchMoreMessage extends MessageEvent {
  FetchMoreMessage();
}
