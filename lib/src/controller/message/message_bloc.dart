
import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import '../../constanct/error_message.dart';
import '../../constanct/status_code.dart';
import '../../model/conversation/message.dart';
import '../../repositories/conversation/conversation_repostitory.dart';
import 'package:stream_transform/stream_transform.dart';

part 'message_event.dart';
part 'message_state.dart';

const throttleDuration = Duration(milliseconds: 10);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  MessageBloc()
      : _conversationRepository = ConversationRepository(),
        super(MessageState()) {
    on<FetchMessage>(_onInitial,
        transformer: throttleDroppable(throttleDuration));
    on<FetchMoreMessage>(_onFetchMore,
        transformer: throttleDroppable(throttleDuration));
  }
  final ConversationRepository _conversationRepository;

  void _onInitial(
    FetchMessage event,
    Emitter<MessageState> emit,
  ) async {
    try {
      final conversationId = event.conversationId;
      GetMessageResponseMessage? resMessage = await _conversationRepository
          .getMessages(conversationId: conversationId);

      if (resMessage == null) {
        throw Exception("");
      }

      final status = resMessage.statusCode ?? 0;
      final message = resMessage.messageCode ?? "";
      final data = resMessage.data ?? [];

      String? avatar = event.avatar;
      String? userId = event.username;
      String? username = event.username;
      String? userRealName = event.userRealName;

      if (status == StatusCode.successStatus ||
          message == MessageCode.noMessageToDisplay) {
        emit(state.copyWith(
            status: FinishInitializing(),
            messageList: data,
            conversationId: conversationId,
            avatar: avatar,
            userId: userId,
            username: username,
            userRealName: userRealName,
            hasReachedMax: false));
      } else {
        throw Exception(message);
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }

  void _onFetchMore(
    FetchMoreMessage event,
    Emitter<MessageState> emit,
  ) async {
    try {
      final conversationId = state.conversationId;
      if (conversationId == null) {
        throw Exception("");
      }
      GetMessageResponseMessage? resMessage =
          await _conversationRepository.getMoreMessages(
              conversationId: conversationId,
              dateBoundary:
                  state.messageList!.last.conversationTime.toString());

      if (resMessage == null) {
        throw Exception("");
      }

      final status = resMessage.statusCode ?? 0;
      final message = resMessage.messageCode ?? "";
      final data = resMessage.data;

      if (status == StatusCode.successStatus && data != null) {
        List<Message> conversationList = resMessage.data ?? [];
        final currentList = state.messageList ?? [];

        emit(state.copyWith(
            status: FinishInitializing(),
            messageList: [...currentList, ...conversationList],
            hasReachedMax: false));
      } else if (message == MessageCode.noMessageToDisplay) {
        emit(state.copyWith(status: FinishInitializing(), hasReachedMax: true));
      } else {
        throw Exception(message);
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }
}
