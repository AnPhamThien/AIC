import 'package:dio/dio.dart';
import 'package:imagecaptioning/src/model/generic/generic.dart';
import 'package:imagecaptioning/src/repositories/data_repository.dart';

abstract class UserBehavior {
  Future<dynamic> addFollow({required String followeeId});
  Future<dynamic> deleteFollow({required String followeeId});
}

class FollowRepository extends UserBehavior {
  final DataRepository _dataRepository = DataRepository();

  @override
  Future<dynamic> addFollow({required String followeeId}) async {
    try {
      final resMessage = await _dataRepository.addFollow(followeeId);
      final response = resMessage.messageCode ?? resMessage.statusCode;
      return response;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetResponseMessage resMessage =
              GetResponseMessage.fromJson(e.response!.data);
          final response = resMessage.messageCode;
          return response;
        }
      }
      return null;
    }
  }

  @override
  Future<dynamic> deleteFollow({required String followeeId}) async {
    try {
      final resMessage = await _dataRepository.deleteFollow(followeeId);
      final response = resMessage.messageCode ?? resMessage.statusCode;
      return response;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetResponseMessage resMessage =
              GetResponseMessage.fromJson(e.response!.data);
          final response = resMessage.messageCode;
          return response;
        }
      }
      return null;
    }
  }
}
