part of 'conversation_bloc.dart';

class ConversationState {
  final List<Conversation>? conversationList;
  final ConversationStatus status;
  final bool hasReachedMax;

  ConversationState(
      {this.conversationList,
      this.status = const InitialStatus(),
      this.hasReachedMax = false});

  ConversationState copyWith(
      {List<Conversation>? conversationList,
      ConversationStatus? status,
      bool? hasReachedMax}) {
    return ConversationState(
        conversationList: conversationList ?? this.conversationList,
        status: status ?? this.status,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }
}

abstract class ConversationStatus {
  const ConversationStatus();
}

class InitialStatus extends ConversationStatus {
  const InitialStatus();
}

class FinishInitializing extends ConversationStatus {}

class ReachedMaxedStatus extends ConversationStatus {}

class ErrorStatus extends ConversationStatus {
  final Exception exception;
  ErrorStatus(this.exception);
}
