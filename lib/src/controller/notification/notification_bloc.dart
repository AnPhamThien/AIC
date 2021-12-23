import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:imagecaptioning/src/constanct/configs.dart';
import 'package:imagecaptioning/src/constanct/status_code.dart';
import 'package:imagecaptioning/src/controller/auth/form_submission_status.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/model/notification/notification.dart';
import 'package:imagecaptioning/src/model/user/user_details.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:imagecaptioning/src/repositories/notification/notification_repository.dart';
import 'package:imagecaptioning/src/signalr/signalr_helper.dart';

part "notification_event.dart";
part "notification_state.dart";

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  NotificationBloc()
      : _notificationRepository = NotificationRepository(),
        _signalRHelper = SignalRHelper(),
        super(NotificationState()) {
    on<NotificationInitializing>(_onInitial);
  }
  final NotificationRepository _notificationRepository;
  final SignalRHelper _signalRHelper;

  void _onInitial(
    NotificationInitializing event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      GetNotificationResponseMessage? resMessage =
          await _notificationRepository.getNotification(limit: limitNoti);
      if (resMessage == null) {
        throw Exception("");
      }

      List<NotificationItem>? notiList = resMessage.data;

      emit(state.copyWith(
          formStatus: FinishInitializing(), notificationList: notiList));
    } on Exception catch (_) {
      emit(state.copyWith(formStatus: FormSubmissionFailed(_)));
    }
  }
}
