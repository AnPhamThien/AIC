part of 'conversation_bloc.dart';

abstract class ConversationEvent {}

class FetchConversation extends ConversationEvent {
  FetchConversation();
}
