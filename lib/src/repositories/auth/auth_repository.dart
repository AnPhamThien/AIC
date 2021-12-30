import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:imagecaptioning/src/repositories/data_repository.dart';

abstract class UserBehavior {
  Future<Map<String, dynamic>?> refreshJwtToken(
      {required String token, required String refreshToken});
}

class AuthRepository extends UserBehavior {
  final DataRepository _dataRepository = DataRepository();

  @override
  Future<Map<String, dynamic>?> refreshJwtToken(
      {required String token, required String refreshToken}) async {
    try {
      Response<Map<String, dynamic>>? resMessage =
          await _dataRepository.refreshJwtToken(token, refreshToken);

      return resMessage.data;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          Map<String, dynamic> resMessage = e.response!.data;
          return resMessage;
        }
      }
      return null;
    }
  }
}
