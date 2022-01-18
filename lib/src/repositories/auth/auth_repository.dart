import 'package:dio/dio.dart';
import 'package:imagecaptioning/src/model/generic/generic.dart';
import 'package:imagecaptioning/src/repositories/data_repository.dart';

abstract class UserBehavior {
  Future<GetResponseMessage?> refreshJwtToken(
      {required String token, required String refreshToken});
  Future<dynamic> deleteRefreshToken();
}

class AuthRepository extends UserBehavior {
  final DataRepository _dataRepository = DataRepository();

  @override
  Future<GetResponseMessage?> refreshJwtToken(
      {required String token, required String refreshToken}) async {
    try {
      GetResponseMessage? resMessage =
          await _dataRepository.refreshJwtToken(token, refreshToken);

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

  @override
  Future<dynamic> deleteRefreshToken() async {
    try {
      GetResponseMessage resMessage =
          await _dataRepository.deleteRefreshJwtToken();

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
