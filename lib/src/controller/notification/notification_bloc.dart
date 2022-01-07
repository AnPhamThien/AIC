import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import '../../constanct/env.dart';
import '../../constanct/error_message.dart';
import '../../constanct/status_code.dart';
import '../../model/notification/notification.dart';
import '../../repositories/notification/notification_repository.dart';
import '../../constanct/env.dart';
import '../../constanct/error_message.dart';
import '../../constanct/status_code.dart';
import '../../model/notification/notification.dart';
import '../../repositories/notification/notification_repository.dart';
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
    // on<FetchMoreNotification>(_onFetchMore,
    //     transformer: throttleDroppable(throttleDuration));
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
        throw Exception(null);
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
}
