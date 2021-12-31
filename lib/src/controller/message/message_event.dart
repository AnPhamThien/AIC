part of 'message_bloc.dart';

abstract class MessageEvent {}

class FetchMessage extends MessageEvent {
  String conversationId;
  String? avatar;
  String? username;
  String? userRealName;
  FetchMessage(
      this.conversationId, this.avatar, this.username, this.userRealName);
}

class FetchMoreMessage extends MessageEvent {
  FetchMoreMessage();
}
