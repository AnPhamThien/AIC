import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:imagecaptioning/src/constant/error_message.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/model/conversation/message.dart';
import 'package:imagecaptioning/src/repositories/conversation/conversation_repostitory.dart';
import 'package:stream_transform/stream_transform.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';

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
    on<ReceiveNewMessage>(_onReceiveNewMessage,
        transformer: throttleDroppable(throttleDuration));
  }
  final ConversationRepository _conversationRepository;

  void _onInitial(
    FetchMessage event,
    Emitter<MessageState> emit,
  ) async {
    try {
      String? avatar = event.avatar;
      String? userId = event.otherUserId;
      String? username = event.username;
      String? userRealName = event.userRealName;

      final conversationId = event.conversationId;
      if (conversationId != null) {
        GetMessageResponseMessage? resMessage = await _conversationRepository
            .getMessages(conversationId: conversationId, limitMessage: 10);

        if (resMessage == null) {
          throw Exception("");
        }

        final status = resMessage.statusCode ?? 0;
        final message = resMessage.messageCode ?? "";
        final data = resMessage.data ?? [];

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
              hasReachedMax:
                  (message == MessageCode.noMessageToDisplay) ? true : false));

          if (data.isNotEmpty) {
            if (data.first.userId != getIt<AppPref>().getUserID &&
                data.first.messageId != null) {
              await _conversationRepository.updateIsSeenMessage(
                  messageId: data.first.messageId!);
            }
          }
        } else {
          throw Exception(message);
        }
      } else {
        GetMessageResponseMessage? resMessage =
            await _conversationRepository.getConversationByUser(userId: userId);

        if (resMessage == null) {
          throw Exception("");
        }

        final status = resMessage.statusCode ?? 0;
        final message = resMessage.messageCode ?? "";
        final data = resMessage.data ?? [];

        if (status == StatusCode.successStatus ||
            message == MessageCode.noMessageToDisplay ||
            message == MessageCode.conversationNotFound) {
          emit(state.copyWith(
              status: FinishInitializing(),
              messageList: data,
              conversationId:
                  data.isNotEmpty ? data.first.conversationId : null,
              avatar: avatar,
              userId: userId,
              username: username,
              userRealName: userRealName,
              hasReachedMax: (message == MessageCode.noMessageToDisplay ||
                      message == MessageCode.conversationNotFound)
                  ? true
                  : false));

          if (data.isNotEmpty) {
            if (data.last.userId != getIt<AppPref>().getUserID &&
                data.last.messageId != null) {
              await _conversationRepository.updateIsSeenMessage(
                  messageId: data.last.messageId!);
            }
          }
        } else {
          throw Exception(message);
        }
      }
    } catch (_) {
      emit(state.copyWith(status: ErrorStatus(_.toString())));
    }
  }

  void _onFetchMore(
    FetchMoreMessage event,
    Emitter<MessageState> emit,
  ) async {
    try {
      if (!state.hasReachedMax) {
        final conversationId = state.conversationId;
        if (conversationId == null) {
          throw Exception("");
        }
        GetMessageResponseMessage? resMessage =
            await _conversationRepository.getMoreMessages(
                conversationId: conversationId,
                dateBoundary: state.messageList!.last.realTime.toString(),
                limitMessage: 10);

        if (resMessage == null) {
          throw Exception("");
        }

        final status = resMessage.statusCode ?? 0;
        final message = resMessage.messageCode ?? "";
        final data = resMessage.data;

        if (status == StatusCode.successStatus && data != null) {
          List<Message> conversationList = data;
          final currentList = state.messageList ?? [];

          emit(state.copyWith(
              status: FinishInitializing(),
              messageList: [...currentList, ...conversationList],
              hasReachedMax: false));
        } else if (message == MessageCode.noMessageToDisplay) {
          emit(state.copyWith(
              status: FinishInitializing(), hasReachedMax: true));
        } else {
          throw Exception(message);
        }
      }
    } catch (_) {
      emit(state.copyWith(status: ErrorStatus(_.toString())));
    }
  }

  void _onReceiveNewMessage(
    ReceiveNewMessage event,
    Emitter<MessageState> emit,
  ) async {
    try {
      final message = event.message;

      if (message != null) {
        final currentList = state.messageList ?? [];
        currentList.insert(0, message);

        emit(state.copyWith(
            status: FinishInitializing(),
            messageList: currentList,
            conversationId: message.conversationId ?? state.conversationId,
            hasReachedMax: false));

        await _conversationRepository.updateIsSeenMessage(
            messageId: message.messageId!);
      } else {
        throw Exception("");
      }
    } catch (_) {
      emit(state.copyWith(status: ErrorStatus(_.toString())));
    }
  }
}
