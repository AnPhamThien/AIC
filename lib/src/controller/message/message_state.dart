part of 'message_bloc.dart';

class MessageState {
  final List<Message>? messageList;
  final MessageStatus status;
  final String? conversationId;
  final String? avatar;
  final String? userId;
  final String? username;
  final String? userRealName;
  final bool hasReachedMax;

  MessageState(
      {this.messageList,
      this.status = const InitialStatus(),
      this.conversationId,
      this.avatar,
      this.userId,
      this.username,
      this.userRealName,
      this.hasReachedMax = false});

  MessageState copyWith(
      {List<Message>? messageList,
      MessageStatus? status,
      String? conversationId,
      String? avatar,
      String? userId,
      String? username,
      String? userRealName,
      bool? hasReachedMax}) {
    return MessageState(
        messageList: messageList ?? this.messageList,
        status: status ?? this.status,
        conversationId: conversationId ?? this.conversationId,
        avatar: avatar ?? this.avatar,
        userId: userId ?? this.userId,
        username: username ?? this.username,
        userRealName: userRealName ?? this.userRealName,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }
}

abstract class MessageStatus {
  const MessageStatus();
}

class InitialStatus extends MessageStatus {
  const InitialStatus();
}

class FinishInitializing extends MessageStatus {}

class ReachedMaxedStatus extends MessageStatus {}

class ErrorStatus extends MessageStatus {
  final String exception;
  ErrorStatus(this.exception);
}
