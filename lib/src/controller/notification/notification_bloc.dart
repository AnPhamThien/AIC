import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/constant/error_message.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/model/notification/notification.dart';
import 'package:imagecaptioning/src/repositories/notification/notification_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part "notification_event.dart";
part "notification_state.dart";

const throttleDuration = Duration(milliseconds: 10);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc()
      : _notificationRepository = NotificationRepository(),
        super(NotificationState()) {
    on<FetchNotification>(_onFetch,
        transformer: throttleDroppable(throttleDuration));
    on<FetchMoreNotification>(_onFetchMore,
        transformer: throttleDroppable(throttleDuration));
  }
  final NotificationRepository _notificationRepository;

  void _onFetch(
    FetchNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      GetNotificationResponseMessage? resMessage =
          await _notificationRepository.getNotification(limit: limitNoti);

      if (resMessage == null) {
        throw Exception('');
      }

      final status = resMessage.statusCode ?? 0;
      final message = resMessage.messageCode ?? "";
      final data = resMessage.data ?? [];

      if (status == StatusCode.successStatus && data.isNotEmpty) {
        emit(state.copyWith(
            status: FinishInitializing(),
            notificationList: data,
            hasReachedMax: false));
      } else if (message == MessageCode.noNotificationToDisplay) {
        emit(state.copyWith(
            status: FinishInitializing(),
            notificationList: [],
            hasReachedMax: true));
      } else {
        throw Exception(message);
      }
    } catch (_) {
      emit(state.copyWith(status: ErrorStatus(_.toString())));
    }
  }

  void _onFetchMore(
    FetchMoreNotification event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      if (state.hasReachedMax) {
        return;
      }
      String dateBoundary = state.notificationList?.last.dateCreate.toString() ?? '';

      GetNotificationResponseMessage? resMessage =
          await _notificationRepository.getMoreNotification(limit: limitNoti, dateBoundary: dateBoundary);

      if (resMessage == null) {
        throw Exception(null);
      }

      final status = resMessage.statusCode ?? 0;
      final message = resMessage.messageCode ?? "";
      final data = resMessage.data ?? [];

      if (status == StatusCode.successStatus && data.isNotEmpty) {
        List<NotificationItem> list = [];
        if (state.notificationList != null) {
          list.addAll(state.notificationList!);
        }
        list.addAll(data);
        emit(state.copyWith(
            status: FinishInitializing(),
            notificationList: list,
            hasReachedMax: false));
      } else if (message == MessageCode.noNotificationToDisplay) {
        emit(state.copyWith(
            status: FinishInitializing(),
            hasReachedMax: true));
      } else {
        throw Exception(message);
      }
    } catch (_) {
      emit(state.copyWith(status: ErrorStatus(_.toString())));
    }
  }
}
