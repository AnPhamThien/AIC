import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:imagecaptioning/src/constanct/configs.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/model/user/user.dart';
import 'package:imagecaptioning/src/model/user/user_details.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:imagecaptioning/src/retrofit/retrofit.dart';

class DataRepository implements RestClient {
  static final Dio _dio = Dio();
  late RestClient _client;

  DataRepository() {
    _dio.interceptors.clear();
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
    _dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) => handler.next(options),
        onResponse: (response, handler) => handler.next(response),
        onError: (error, handler) async {
          if (error.response != null) {
            if (error.response!.statusCode == 401) {
              String token = getIt<AppPref>().getToken;
              String refreshToken = getIt<AppPref>().getRefreshToken;

              Response? response = await refreshJwtToken(token, refreshToken);
              Map<String, dynamic> value = json.decode(response.data);
              getIt<AppPref>().setToken(value['data']);

              setJwtInHeader();
              handler.resolve(response);
            } else {
              handler.next(error);
            }
          }
        }));
    setJwtInHeader();
    _client = RestClient(_dio, baseUrl: appBaseUrl);
  }
  static setJwtInHeader() {
    _dio.options.headers.remove('Authorization');
    _dio.options.headers['Authorization'] =
        'Bearer ${getIt<AppPref>().getToken}';
  }

  @override
  Future<AuthenticationResponseMessage> login(
      String username, String password) async {
    return _client.login(username, password);
  }

  @override
  Future<RegisterDefaultResponseMessage> registerDefault(
      String username, String password, String email) async {
    return _client.registerDefault(username, password, email);
  }

  @override
  Future<Map<String, dynamic>> activateAccount(
      String code, String userID) async {
    return _client.activateAccount(code, userID);
  }

  @override
  Future<Map<String, dynamic>> regenerateCodeForRegister(String userID) async {
    return _client.regenerateCodeForRegister(userID);
  }

  @override
  Future<GetUserDetailsResponseMessage> getUserDetail(
      String userID, int limitPost) {
    return _client.getUserDetail(userID, limitPost);
  }

  @override
  Future<Map<String, dynamic>> regenerateResetPasswordCode(String email) {
    return _client.regenerateResetPasswordCode(email);
  }

  @override
  Future<Response> refreshJwtToken(String token, String refreshToken) {
    return _client.refreshJwtToken(token, refreshToken);
  }

  @override
  Future<Map<String, dynamic>> updateUserProfile(String username, String email,
      String phone, String desc, String userRealName, String avatarImg) {
    return _client.updateUserProfile(
        username, email, phone, desc, userRealName, avatarImg);
  }
}
