import 'package:dio/dio.dart' hide Headers;
import '../constanct/env.dart';
import '../model/conversation/conversation.dart';
import '../model/generic/generic.dart';
import '../model/conversation/message.dart';
import '../model/notification/notification.dart';
import '../model/contest/contest_list_respone.dart';
import '../model/post/post_add_comment_request.dart';
import '../model/post/post_add_comment_respone.dart';
import '../model/post/post_comment_like_respone.dart';
import '../model/post/post_comment_list_respone.dart';
import '../model/post/post_list_request.dart';
import '../model/post/post_list_respone.dart';
import '../model/user/user.dart';
import '../model/user/user_details.dart';
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
  Future<GetResponseMessage> activateAccount(
      @Field('code') String code, @Field('user_id') String userID);
  @POST('/users/regeneratecodeforregisaccount')
  Future<GetResponseMessage> regenerateCodeForRegister(
      @Field('userID') String userID);

  @POST('/users/generateresetpasswordcode')
  Future<GetResponseMessage> regenerateResetPasswordCode(
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
  Future<GetResponseMessage> updateUserProfile(
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
      @Query('dateBoundary') String dateBoundary);

  @GET('/posts/getpostver2')
  Future<PostListRespone> getPost(
    @Query('postPerPerson') int postPerPerson,
    @Query('limitDay') int limitDay,
  );

  @POST('/posts/getmorepostver2')
  Future<PostListRespone> getMorePost(@Body() PostListRequest request);

  @GET('/conversations/getconversations')
  Future<GetConversationResponseMessage> getConversations();

  @GET('/conversations/getmoreconversations')
  Future<GetConversationResponseMessage> getMoreConversations(
      @Query('dateBoundary') String dateBoundary);

  @GET('/conversations/getmessages')
  Future<GetMessageResponseMessage> getMessages(
      @Query('conversationId') String conversationId);

  @GET('/conversations/getmoremessages')
  Future<GetMessageResponseMessage> getMoreMessages(
      @Query('conversationId') String conversationId,
      @Query('dateBoundary') String dateBoundary);

  @GET('/contests/getcontestforuser')
  Future<ContestListRespone> getActiveContestList(
    @Query('searchname') String? searchName,
    @Query('limitcontest') int limitContest,
    @Query('date_up') String? dateUp,
    @Query('date_dow') String? dateDown,
  );

  @GET('/contests/getcontestinactiveforuser')
  Future<ContestListRespone> getInactiveContestList(
    @Query('searchname') String? searchName,
    @Query('limitcontest') int limitContest,
    @Query('date_up') String? dateUp,
    @Query('date_dow') String? dateDown,
  );

  @GET('/posts/getpostdetailver2')
  Future<ContestListRespone> getPostDetail(
    @Query('post_id') String postId,
    @Query('limitComment') int limitComment,
    @Query('contest_id') String? contestId,
  );

  @GET('/posts/getpostcommentandlikeInit')
  Future<PostCommentLikeRespone> getInitPostLikeComment(
    @Query('commentPerPage') int commentPerPage,
    @Query('postId') String postId,
  );

  @GET('/posts/getpagecomment')
  Future<PostCommentListRespone> getMoreComment(
    @Query('date_boundary') String dateBoundary,
    @Query('commentPerPage') int commentPerPage,
    @Query('postId') String postId,
  );

  @POST('/comments/addcomment')
  Future<PostAddCommentRespone> addComment(
      @Body() PostAddCommentRequest request);

  @GET('/contests/getmorecontestforuser')
  Future<ContestListRespone> getMoreActiveContestList(
    @Query('searchname') String? searchName,
    @Query('limitcontest') int limitContest,
    @Query('date_boundary') String dateBoundary,
    @Query('date_up') String? dateUp,
    @Query('date_dow') String? dateDown,
  );

  @GET('/contests/getmorecontestinactiveforuser')
  Future<ContestListRespone> getMoreInactiveContestList(
    @Query('searchname') String? searchName,
    @Query('limitcontest') int limitContest,
    @Query('date_boundary') String dateBoundary,
    @Query('date_up') String? dateUp,
    @Query('date_dow') String? dateDown,
  );
}
