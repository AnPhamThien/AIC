import 'package:dio/dio.dart' hide Headers;
import 'package:imagecaptioning/src/constanct/configs.dart';
import 'package:imagecaptioning/src/constanct/env.dart';
import 'package:imagecaptioning/src/model/notification/notification.dart';
import 'package:imagecaptioning/src/model/user/user.dart';
import 'package:imagecaptioning/src/model/user/user_details.dart';
import 'package:retrofit/retrofit.dart';

part 'retrofit.g.dart';

//flutter pub run build_runner build
//generation code
@RestApi(baseUrl: appBaseUrl)
abstract class RestClient {
  factory RestClient(Dio dio, {String baseUrl}) = _RestClient;

  @POST('/users/authenticate')
  Future<AuthenticationResponseMessage> login(
    @Field('Username') String userName,
    @Field('Password') String passWord,
  );
  @POST('/users/registrationdefault')
  Future<RegisterDefaultResponseMessage> registerDefault(
      @Field('user_name') String username,
      @Field('user_password') String password,
      @Field('user_email') String email);

  @POST('/users/activationaccount')
  Future<Map<String, dynamic>> activateAccount(
      @Field('code') String code, @Field('user_id') String userID);
  @POST('/users/regeneratecodeforregisaccount')
  Future<Map<String, dynamic>> regenerateCodeForRegister(
      @Field('userID') String userID);

  @POST('/users/generateresetpasswordcode')
  Future<Map<String, dynamic>> regenerateResetPasswordCode(
      @Field('user_email') String email);

  @GET('/users/getuserdetail')
  Future<GetUserDetailsResponseMessage> getUserDetail(
    @Query('user_id') String userID,
    @Query('limitpost') int limitPost,
  );

  @POST('/users/refreshtoken')
  Future<Response<Map<String, dynamic>>> refreshJwtToken(
      @Field('JwtToken') String token,
      @Field('RefreshToken') String refreshToken);

  @POST('/users/updateuserprofile')
  Future<Map<String, dynamic>> updateUserProfile(
      @Field('user_name') String username,
      @Field('user_email') String email,
      @Field('phone') String phone,
      @Field('description') String desc,
      @Field('user_real_name') String userRealName,
      @Field('avatar_img') String avatarImg);

  @GET('/notifications/getnotification')
  Future<GetNotificationResponseMessage> getNotification(
    @Query('limitNotification') int limit,
  );

  @GET('/notifications/getmorenotification')
  Future<GetNotificationResponseMessage> getMoreNotification(
    @Query('limitNotification') int limit,
    @Query('dateBoundary') String dateBoundary,
  );
}
