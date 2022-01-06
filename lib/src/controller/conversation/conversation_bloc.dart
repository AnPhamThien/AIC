import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:imagecaptioning/src/constanct/error_message.dart';
import 'package:imagecaptioning/src/constanct/status_code.dart';
import 'package:imagecaptioning/src/model/conversation/conversation.dart';
import 'package:imagecaptioning/src/repositories/conversation/conversation_repostitory.dart';
import 'package:stream_transform/stream_transform.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

const throttleDuration = Duration(milliseconds: 10);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc()
      : _conversationRepository = ConversationRepository(),
        super(ConversationState()) {
    on<FetchConversation>(_onInitial,
        transformer: throttleDroppable(throttleDuration));
    on<FetchMoreConversation>(_onFetchMore,
        transformer: throttleDroppable(throttleDuration));
    on<ReceiveNewConversation>(_onReceiveNewConversation,
        transformer: throttleDroppable(throttleDuration));
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
      final data = resMessage.data ?? [];

      if (status == StatusCode.successStatus && data.isNotEmpty) {
        emit(state.copyWith(
            status: FinishInitializing(), conversationList: data));
      } else if (message == MessageCode.noConversationToDisplay) {
        emit(state.copyWith(
            status: ReachedMaxedStatus(),
            conversationList: [],
            hasReachedMax: true));
      } else {
        throw Exception(message);
      }
    } catch (_) {
      emit(state.copyWith(status: ErrorStatus(_.toString())));
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

      if (state.hasReachedMax) {
        emit(state.copyWith(status: ReachedMaxedStatus(), hasReachedMax: true));
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
      final data = resMessage.data ?? [];

      if (status == StatusCode.successStatus && data.isNotEmpty) {
        final currentList = state.conversationList ?? [];

        emit(state.copyWith(
            status: FinishInitializing(),
            conversationList: [...currentList, ...data]));
      } else if (message == MessageCode.noConversationToDisplay) {
        emit(state.copyWith(status: ReachedMaxedStatus(), hasReachedMax: true));
      } else {
        throw Exception(message);
      }
    } catch (_) {
      emit(state.copyWith(status: ErrorStatus(_.toString())));
    }
  }

  void _onReceiveNewConversation(
    ReceiveNewConversation event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      final newConversation = event.newConversation;

      if (newConversation != null) {
        final currentList = state.conversationList ?? [];
        currentList.removeWhere(((element) =>
            element.conversationId == newConversation.conversationId));
        currentList.insert(0, newConversation);

        emit(state.copyWith(
            status: FinishInitializing(), conversationList: currentList));
      } else {
        throw Exception('');
      }
    } catch (_) {
      emit(state.copyWith(status: ErrorStatus(_.toString())));
    }
  }
}
