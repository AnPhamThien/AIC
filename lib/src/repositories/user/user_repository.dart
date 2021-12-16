import 'dart:convert';

import 'package:dio/dio.dart';
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
  Future<UserDetails?> getUserDetail(
      {required String userID, required int limitPost});
  Future<dynamic> regenerateResetPasswordCode({required String email});
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
        AuthenticationResponseMessage resMessage =
            AuthenticationResponseMessage.fromJson(e.response!.data);
        return resMessage;
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
        RegisterDefaultResponseMessage resMessage =
            RegisterDefaultResponseMessage.fromJson(e.response!.data);
        return resMessage;
      }
      return null;
    }
  }

  @override
  Future<dynamic> activateAccount(
      {required String code, required String userID}) async {
    try {
      final resMessage = await _dataRepository.activateAccount(code, userID);
      final response = resMessage['messageCode'] ?? resMessage['statusCode'];
      return response;
    } catch (e) {
      if (e is DioError) {
        Map<String, dynamic> resMessage = json.decode(e.response!.data);
        final response = resMessage['messageCode'];
        return response;
      }
      return null;
    }
  }

  @override
  Future<dynamic> regenerateCodeForRegister({required String userID}) async {
    try {
      final resMessage =
          await _dataRepository.regenerateCodeForRegister(userID);
      final response = resMessage['messageCode'] ?? resMessage['statusCode'];

      return response;
    } catch (e) {
      if (e is DioError) {
        Map<String, dynamic> resMessage = json.decode(e.response!.data);
        final response = resMessage['messageCode'];
        return response;
      }
      return null;
    }
  }

  @override
  Future<UserDetails?> getUserDetail(
      {required String userID, required int limitPost}) async {
    try {
      final resMessage = await _dataRepository.getUserDetail(userID, limitPost);
      final userDetails = resMessage.data;
      return userDetails;
    } catch (e) {
      if (e is DioError) {
        Map<String, dynamic> resMessage = json.decode(e.response!.data);
        final response = resMessage['messageCode'];
        return response;
      }
      return null;
    }
  }

  @override
  Future<dynamic> regenerateResetPasswordCode({required String email}) async {
    try {
      final resMessage =
          await _dataRepository.regenerateResetPasswordCode(email);
      final response = resMessage['messageCode'] ?? resMessage['statusCode'];
      return response;
    } catch (e) {
      if (e is DioError) {
        Map<String, dynamic> resMessage = json.decode(e.response!.data);
        final response = resMessage['messageCode'];
        return response;
      }
      return null;
    }
  }
}
