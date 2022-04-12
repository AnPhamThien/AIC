import 'package:dio/dio.dart';
import 'package:imagecaptioning/src/model/generic/generic.dart';
import '../../model/notification/notification.dart';
import '../data_repository.dart';

abstract class UserBehavior {
  Future<GetNotificationResponseMessage?> getNotification({required int limit});

  Future<GetNotificationResponseMessage?> getMoreNotification(
      {required int limit, required String dateBoundary});
  Future<GetResponseMessage?> updateIsRead();
}

class NotificationRepository extends UserBehavior {
  final DataRepository _dataRepository = DataRepository();
  @override
  Future<GetNotificationResponseMessage?> getNotification(
      {required int limit}) async {
    try {
      GetNotificationResponseMessage resMessage =
          await _dataRepository.getNotification(limit);
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetNotificationResponseMessage resMessage =
              GetNotificationResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<GetNotificationResponseMessage?> getMoreNotification(
      {required int limit, required String dateBoundary}) async {
    try {
      GetNotificationResponseMessage resMessage =
          await _dataRepository.getMoreNotification(limit, dateBoundary);
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetNotificationResponseMessage resMessage =
              GetNotificationResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<GetResponseMessage?> updateIsRead() async {
    try {
      GetResponseMessage resMessage =
          await _dataRepository.updateIsRead();
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetResponseMessage resMessage =
              GetResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }
}
