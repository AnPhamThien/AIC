import 'dart:developer';
import 'dart:html';

import 'package:bloc/bloc.dart';
import 'package:imagecaptioning/src/controller/auth/form_submission_status.dart';
import 'package:imagecaptioning/src/model/conversation/conversation.dart';
import 'package:imagecaptioning/src/model/conversation/message.dart';
import 'package:imagecaptioning/src/repositories/conversation/conversation_repostitory.dart';
import 'package:imagecaptioning/src/signalr/signalr_helper.dart';

part 'message_event.dart';
part 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc()
      : _conversationRepository = ConversationRepository(),
        _signalRHelper = SignalRHelper(),
        super(MessageState()) {
    on<FetchMessage>(_onInitial);
  }
  final ConversationRepository _conversationRepository;
  final SignalRHelper _signalRHelper;

  void _onInitial(
    FetchMessage event,
    Emitter<MessageState> emit,
  ) async {
    try {
      GetMessageResponseMessage? resMessage;
      final conversationId = event.conversationId;
      log(conversationId);
      if (state.formStatus is InitialFormStatus) {
        resMessage = await _conversationRepository.getMessages(
            conversationId: conversationId);
      } else {
        resMessage = await _conversationRepository.getMoreMessages(
            conversationId: conversationId,
            dateBoundary: state.messageList!.last.conversationTime.toString());
      }

      if (resMessage == null) {
        throw Exception("");
      }

      List<Message>? messageList = resMessage.data;
      String? avatar = event.avatar;
      String? userId = event.username;
      String? username = event.username;

      emit(state.copyWith(
          formStatus: FinishInitializing(),
          messageList: messageList,
          conversationId: conversationId,
          avatar: avatar,
          userId: userId,
          username: username));
    } on Exception catch (_) {
      emit(state.copyWith(formStatus: FormSubmissionFailed(_)));
    }
  }

  void _onFetchMore(
    FetchMoreMessage event,
    Emitter<MessageState> emit,
  ) async {
    try {
      GetMessageResponseMessage? resMessage;
      final conversationId = state.conversationId;
      if (conversationId != null) {
        resMessage = await _conversationRepository.getMoreMessages(
            conversationId: conversationId,
            dateBoundary: state.messageList!.last.conversationTime.toString());
      } else {
        throw Exception("");
      }

      if (resMessage == null) {
        throw Exception("");
      }

      List<Message>? messageList = resMessage.data;

      emit(state.copyWith(
          formStatus: FinishInitializing(), messageList: messageList));
    } on Exception catch (_) {
      emit(state.copyWith(formStatus: FormSubmissionFailed(_)));
    }
  }
}
