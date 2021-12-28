import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:imagecaptioning/src/constanct/env.dart';
import 'package:imagecaptioning/src/constanct/status_code.dart';
import 'package:imagecaptioning/src/controller/auth/form_submission_status.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/model/conversation/conversation.dart';
import 'package:imagecaptioning/src/model/notification/notification.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:imagecaptioning/src/repositories/conversation/conversation_repostitory.dart';
import 'package:imagecaptioning/src/repositories/notification/notification_repository.dart';
import 'package:imagecaptioning/src/signalr/signalr_helper.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationBloc extends Bloc<ConversationEvent, ConversationState> {
  ConversationBloc()
      : _conversationRepository = ConversationRepository(),
        _signalRHelper = SignalRHelper(),
        super(ConversationState()) {
    on<FetchConversation>(_onInitial);
  }
  final ConversationRepository _conversationRepository;
  final SignalRHelper _signalRHelper;

  void _onInitial(
    FetchConversation event,
    Emitter<ConversationState> emit,
  ) async {
    try {
      GetConversationResponseMessage? resMessage;
      if (state.formStatus is InitialFormStatus) {
        resMessage = await _conversationRepository.getConversations();
      } else {
        resMessage = await _conversationRepository.getMoreConversations(
            dateBoundary:
                state.conversationList!.last.conversationDate.toString());
      }

      if (resMessage == null) {
        throw Exception("");
      }

      List<Conversation>? conversationList = resMessage.data;

      emit(state.copyWith(
          formStatus: FinishInitializing(),
          conversationList: conversationList));
    } on Exception catch (_) {
      emit(state.copyWith(formStatus: FormSubmissionFailed(_)));
    }
  }
}
