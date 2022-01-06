import 'package:dio/dio.dart';
import 'package:imagecaptioning/src/model/generic/generic.dart';
import 'package:imagecaptioning/src/model/user/user.dart';
import 'package:imagecaptioning/src/model/user/user_details.dart';
import 'package:imagecaptioning/src/repositories/data_repository.dart';

abstract class UserBehavior {
  Future<AuthenticationResponseMessage?> login(
      {required String username, required String password});
  Future<RegisterDefaultResponseMessage?> registerDefault(
      {required String username,
      required String password,
      required String email});
  Future<dynamic> activateAccount(
      {required String userID, required String code});
  Future<dynamic> regenerateCodeForRegister({required String userID});
  Future<GetUserDetailsResponseMessage?> getUserDetail(
      {required String userID, required int limitPost});
  Future<dynamic> regenerateResetPasswordCode({required String email});
  Future<dynamic> updateUserProfile(
      {required String username,
      required String email,
      required String phone,
      required String desc,
      required String userRealName,
      required String avatarImg});
}

class UserRepository extends UserBehavior {
  final DataRepository _dataRepository = DataRepository();

  @override
  Future<AuthenticationResponseMessage?> login(
      {required String username, required String password}) async {
    try {
      AuthenticationResponseMessage resMessage =
          await _dataRepository.login(username, password);
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          AuthenticationResponseMessage resMessage =
              AuthenticationResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<RegisterDefaultResponseMessage?> registerDefault(
      {required String username,
      required String password,
      required String email}) async {
    try {
      RegisterDefaultResponseMessage resMessage =
          await _dataRepository.registerDefault(username, password, email);
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          RegisterDefaultResponseMessage resMessage =
              RegisterDefaultResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<dynamic> activateAccount(
      {required String code, required String userID}) async {
    try {
      final resMessage = await _dataRepository.activateAccount(code, userID);
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
  Future<dynamic> regenerateCodeForRegister({required String userID}) async {
    try {
      final resMessage =
          await _dataRepository.regenerateCodeForRegister(userID);
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
  Future<GetUserDetailsResponseMessage?> getUserDetail(
      {required String userID, required int limitPost}) async {
    try {
      final resMessage = await _dataRepository.getUserDetail(userID, limitPost);
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetUserDetailsResponseMessage resMessage =
              GetUserDetailsResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<dynamic> regenerateResetPasswordCode({required String email}) async {
    try {
      final resMessage =
          await _dataRepository.regenerateResetPasswordCode(email);
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
  Future<dynamic> updateUserProfile(
      {required String username,
      required String email,
      required String phone,
      required String desc,
      required String userRealName,
      required String avatarImg}) async {
    try {
      final resMessage = await _dataRepository.updateUserProfile(
          username, email, phone, desc, userRealName, avatarImg);
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
