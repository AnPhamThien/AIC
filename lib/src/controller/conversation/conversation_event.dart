part of 'conversation_bloc.dart';

abstract class ConversationEvent {}

class FetchConversation extends ConversationEvent {
  FetchConversation();
}

class FetchMoreConversation extends ConversationEvent {
  FetchMoreConversation();
}

class ReceiveNewConversation extends ConversationEvent {}
