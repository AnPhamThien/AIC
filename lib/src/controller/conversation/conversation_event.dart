part of 'conversation_bloc.dart';

abstract class ConversationEvent {
  const ConversationEvent();
}

class FetchConversation extends ConversationEvent {}

class FetchMoreConversation extends ConversationEvent {}

class ReceiveNewConversation extends ConversationEvent {
  Conversation? newConversation;
  ReceiveNewConversation(this.newConversation);
}
