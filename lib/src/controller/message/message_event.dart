part of 'message_bloc.dart';

abstract class MessageEvent {
  const MessageEvent();
}

class FetchMessage extends MessageEvent {
  String? conversationId;
  String? avatar;
  String? username;
  String? userRealName;
  String otherUserId;
  FetchMessage(this.conversationId, this.avatar, this.username,
      this.userRealName, this.otherUserId);
}

class FetchMoreMessage extends MessageEvent {}

class ReceiveNewMessage extends MessageEvent {
  Message? message;
  ReceiveNewMessage(this.message);
}
