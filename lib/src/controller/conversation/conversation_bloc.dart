import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:imagecaptioning/src/constanct/status_code.dart';
import 'package:imagecaptioning/src/controller/auth/form_submission_status.dart';
import 'package:imagecaptioning/src/model/conversation/conversation.dart';
import 'package:imagecaptioning/src/repositories/conversation/conversation_repostitory.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc()
      : _conversationRepository = ConversationRepository(),
        super(ConversationState()) {
    on<FetchConversation>(_onInitial);
  }
  final ConversationRepository _conversationRepository;

  void _onInitial(
    FetchConversation event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      GetConversationResponseMessage? resMessage =
          await _conversationRepository.getConversations();

      if (resMessage == null) {
        throw Exception("");
      }

      final status = resMessage.statusCode ?? 0;
      final message = resMessage.messageCode ?? "";
      final data = resMessage.data;

      if (status == StatusCode.successStatus && data != null) {
        List<Conversation>? conversationList = resMessage.data;

        emit(state.copyWith(
            formStatus: FinishInitializing(),
            conversationList: conversationList));
      } else {
        throw Exception(message);
      }
    } on Exception catch (_) {
      emit(state.copyWith(formStatus: FormSubmissionFailed(_)));
    }
  }

  void _onFetchMore(
    FetchMoreConversation event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      if (state.conversationList == null) {
        throw Exception("");
      }
      GetConversationResponseMessage? resMessage =
          await _conversationRepository.getMoreConversations(
              dateBoundary:
                  state.conversationList!.last.conversationDate.toString());

      if (resMessage == null) {
        throw Exception("");
      }

      final status = resMessage.statusCode ?? 0;
      final message = resMessage.messageCode ?? "";
      final data = resMessage.data;

      if (status == StatusCode.successStatus && data != null) {
        List<Conversation>? conversationList = resMessage.data;

        emit(state.copyWith(
            formStatus: FinishInitializing(),
            conversationList: conversationList));
      } else {
        throw Exception(message);
      }
    } on Exception catch (_) {
      emit(state.copyWith(formStatus: FormSubmissionFailed(_)));
    }
  }
}
