part of 'message_bloc.dart';

class MessageState {
  final List<Message>? messageList;
  final FormSubmissionStatus formStatus;
  final String? conversationId;
  final String? otherUserId;
  final String? avatar;
  final String? userId;
  final String? username;

  MessageState(
      {this.messageList,
      this.formStatus = const InitialFormStatus(),
      this.conversationId,
      this.otherUserId,
      this.avatar,
      this.userId,
      this.username});

  MessageState copyWith(
      {List<Message>? messageList,
      FormSubmissionStatus? formStatus,
      String? conversationId,
      String? otherUserId,
      String? avatar,
      String? userId,
      String? username}) {
    return MessageState(
        messageList: messageList ?? this.messageList,
        formStatus: formStatus ?? this.formStatus,
        conversationId: conversationId ?? this.conversationId,
        otherUserId: otherUserId ?? this.otherUserId,
        avatar: avatar ?? this.avatar,
        userId: userId ?? this.userId,
        username: username ?? this.username);
  }
}
