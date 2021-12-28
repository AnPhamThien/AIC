part of 'conversation_bloc.dart';

class ConversationState {
  final List<Conversation>? conversationList;
  final FormSubmissionStatus formStatus;

  ConversationState({
    this.conversationList,
    this.formStatus = const InitialFormStatus(),
  });

  ConversationState copyWith({
    List<Conversation>? conversationList,
    FormSubmissionStatus? formStatus,
  }) {
    return ConversationState(
        conversationList: conversationList ?? this.conversationList,
        formStatus: formStatus ?? this.formStatus);
  }
}
