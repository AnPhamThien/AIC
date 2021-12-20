// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'retrofit.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

class _RestClient implements RestClient {
  _RestClient(this._dio, {this.baseUrl}) {
    baseUrl ??= 'http://13.250.109.141';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<AuthenticationResponseMessage> login(userName, passWord) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'Username': userName, 'Password': passWord};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<AuthenticationResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/users/authenticate',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AuthenticationResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<RegisterDefaultResponseMessage> registerDefault(
      username, password, email) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'user_name': username,
      'user_password': password,
      'user_email': email
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<RegisterDefaultResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/users/registrationdefault',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = RegisterDefaultResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Map<String, dynamic>> activateAccount(code, userID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'code': code, 'user_id': userID};
    Response _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options, '/users/activationaccount',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    Map<String, dynamic> value = json.decode(_result.data);
    return value;
  }

  @override
  Future<Map<String, dynamic>> regenerateCodeForRegister(userID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'userID': userID};
    Response _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options, '/users/regeneratecodeforregisaccount',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    Map<String, dynamic> value = json.decode(_result.data);
    return value;
  }

  @override
  Future<Map<String, dynamic>> regenerateResetPasswordCode(email) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'user_email': email};
    Response _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options, '/users/generateresetpasswordcode',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));

    Map<String, dynamic> value = json.decode(_result.data);
    return value;
  }

  @override
  Future<GetUserDetailsResponseMessage> getUserDetail(userID, limitPost) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'user_id': userID,
      r'limitpost': limitPost
    };
    final _headers = <String, dynamic>{};
    _headers.removeWhere((k, v) => v == null);
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetUserDetailsResponseMessage>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/users/getuserdetail',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetUserDetailsResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<Response> refreshJwtToken(token, refreshToken) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'JwtToken': token, 'RefreshToken': refreshToken};
    Response _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options, '/users/refreshtoken',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));

    return _result;
  }

  @override
  Future<Map<String, dynamic>> updateUserProfile(
      username, email, phone, desc, userRealName, avatarImg) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'user_name': username,
      'user_email': email,
      'phone': phone,
      'description': desc,
      'user_real_name': userRealName,
      'avatar_img': avatarImg
    };
    Response _result = await _dio.fetch<String>(_setStreamType<String>(
        Options(method: 'POST', headers: _headers, extra: _extra)
            .compose(_dio.options, '/users/updateuserprofile',
                queryParameters: queryParameters, data: _data)
            .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));

    Map<String, dynamic> value = json.decode(_result.data);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }
}