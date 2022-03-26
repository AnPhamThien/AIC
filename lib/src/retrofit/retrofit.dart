import 'dart:io';

import 'package:dio/dio.dart' hide Headers;
import 'package:imagecaptioning/src/model/album/album.dart';
import 'package:imagecaptioning/src/model/contest/list_top_post_in_contest.dart';
import 'package:imagecaptioning/src/model/post/add_post_response.dart';
import 'package:imagecaptioning/src/model/category/category_respone.dart';
import 'package:imagecaptioning/src/model/post/list_of_post_respone.dart';
import 'package:imagecaptioning/src/model/search/search_post.dart';
import '../constant/env.dart';
import '../model/post/post_detail_respone.dart';
import '../model/search/search_history_respone.dart';
import '../model/search/search_respone.dart';
import 'package:retrofit/retrofit.dart';

import '../model/contest/contest_list_respone.dart';
import '../model/contest/contest_post_respone.dart';
import '../model/contest/contest_respone.dart';
import '../model/contest/user_in_contest_respone.dart';
import '../model/conversation/conversation.dart';
import '../model/conversation/message.dart';
import '../model/generic/generic.dart';
import '../model/notification/notification.dart';
import '../model/post/post_add_comment_request.dart';
import '../model/post/post_comment_like_respone.dart';
import '../model/post/post_comment_list_respone.dart';
import '../model/post/post_list_request.dart';
import '../model/post/post_list_respone.dart';
import '../model/user/user.dart';
import '../model/user/user_details.dart';

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
  Future<GetResponseMessage> generateResetPasswordCode(
      @Field('user_email') String email);

  @POST('/users/validresetpasswordcode')
  Future<GetResponseMessage> validateResetPasswordCode(
      @Field('code') String code, @Field('user_id') String userId);

  @POST('/users/resetpassword')
  Future<GetResponseMessage> resetPassword(
      @Field('Id') String userId, @Field('user_password') String password);

  @GET('/users/getuserdetail')
  Future<GetUserDetailsResponseMessage> getUserDetail(
    @Query('user_id') String userID,
    @Query('limitpost') int limitPost,
  );

  @GET('/posts/getusercontestpost')
  Future<GetListOfPostResponseMessage> getUserContestPost(
    @Query('userId') String userID,
    @Query('limitPost') int limitPost,
  );

  @GET('/posts/getmoreusercontestpost')
  Future<GetListOfPostResponseMessage> getMoreUserContestPost(
      @Query('userId') String userID,
      @Query('limitPost') int limitPost,
      @Query('date_boundary') String dateBoundary);

  @GET('/users/getmoreuserpost')
  Future<GetListOfPostResponseMessage> getMoreUserPost(
      @Query('user_id') String userID,
      @Query('limitpost') int limitPost,
      @Query('date_boundary') String dateBoundary);

  @POST('/users/refreshtoken')
  Future<GetResponseMessage> refreshJwtToken(@Field('JwtToken') String token,
      @Field('RefreshToken') String refreshToken);

  @DELETE('/users/deleterefreshtoken')
  Future<GetResponseMessage> deleteRefreshJwtToken();

  @POST('/users/updateuserprofile')
  @MultiPart()
  Future<GetResponseMessage> updateUserProfile(
      @Part(value: 'user_name') String username,
      @Part(value: 'user_email') String email,
      @Part(value: 'phone') String? phone,
      @Part(value: 'description') String? desc,
      @Part(value: 'user_real_name') String? userRealName,
      @Part(value: 'avatar_img') File? avatarImg);

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

  @GET('/posts/getpoststorage')
  Future<GetListOfPostResponseMessage> getPostStorage(
      @Query('limitPost') int limitPost);

  @GET('/posts/getmorepoststorage')
  Future<GetListOfPostResponseMessage> getMorePostStorage(
    @Query('limitPost') int limitPost,
    @Query('currentPage') int currentPage,
  );

  @POST('/posts/addpost')
  @MultiPart()
  Future<AddPostResponseMessage> addPost(
    @Part(value: 'album_id') String albumId,
    @Part(value: 'contest_id') String? contestId,
    @Part(value: 'PostImg') File postImg,
    @Part(value: 'ai_caption') String aiCaption,
    @Part(value: 'user_caption') String? userCaption,
  );

  @GET('/conversations/getconversations')
  Future<GetConversationResponseMessage> getConversations();

  @GET('/conversations/getmoreconversations')
  Future<GetConversationResponseMessage> getMoreConversations(
      @Query('date_boundary') String dateBoundary);

  @POST('/conversations/updateisseenmessage')
  Future<GetResponseMessage> updateIsSeenMessage(
      @Field('message_id') String messageId);

  @GET('/conversations/getmessages')
  Future<GetMessageResponseMessage> getMessages(
      @Query('conversationId') String conversationId,
      @Query('limitMessage') int limitMessage);

  @GET('/conversations/getconversationbyuser')
  Future<GetMessageResponseMessage> getConversationByUser(
      @Query('userId') String userId);

  @GET('/conversations/getmoremessages')
  Future<GetMessageResponseMessage> getMoreMessages(
      @Query('conversationId') String conversationId,
      @Query('date_boundary') String dateBoundary,
      @Query('limitMessage') int limitMessage);

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
  Future<GetResponseMessage> addComment(@Body() PostAddCommentRequest request);

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

  @GET('/contests/getcontestpostver2')
  Future<ContestRespone> getInitContest(
    @Query('contest_id') String contestId,
    @Query('limitPost') int limitPost,
  );

  @POST('/follows/addfollow')
  Future<GetResponseMessage> addFollow(@Field('followeeId') String followeeId);

  @POST('/follows/deletefollow')
  Future<GetResponseMessage> deleteFollow(
      @Field('followeeId') String followeeId);

  @GET('/contests/getmorecontestpost')
  Future<ContestPostRespone> getMoreContestPost(
      @Query('contest_id') String contestId,
      @Query('limitPost') int limitPost,
      @Query('dateboundary') String dateBoundary);

  @GET('/contests/getuserincontest')
  Future<UserInContestRespone> getUserInContest(
    @Query('contest_id') String contestId,
    @Query('limituser') int limitUser,
  );

  @GET('/contests/getmoreuserincontest')
  Future<UserInContestRespone> getMoreUserInContest(
    @Query('contest_id') String contestId,
    @Query('limituser') int limitUser,
    @Query('date_boundary') String dateBoundary,
  );

  @GET('/contests/getsearchuserincontest')
  Future<UserInContestRespone> getSearchUserInContest(
    @Query('contest_id') String contestId,
    @Query('limituser') int limitUser,
    @Query('user_name') String username,
  );

  @GET('/contests/getmoresearchuserincontest')
  Future<UserInContestRespone> getMoreSearchUserInContest(
    @Query('contest_id') String contestId,
    @Query('limituser') int limitUser,
    @Query('user_name') String username,
    @Query('date_boundary') String dateBoundary,
  );

  @GET('/searchhistories/getsearchhistory')
  Future<SearchHistoryRespone> getSearchHistory(
    @Query('limit') int limit,
  );

  @GET('/searchhistories/getmoresearchhistory')
  Future<SearchHistoryRespone> getMoreSearchHistory(
      @Query('limit') int limit, @Query('date_boundary') String dateBoundary);

  @GET('/posts/getpostdetailver2')
  Future<PostDetailRespone> getPostDetail(
    @Query('post_id') String postId,
    @Query('contest_id') String contestId,
  );

  @GET('/users/searchuser')
  Future<SearchRespone> searchUser(
    @Query('limituser') int limitUser,
    @Query('name') String name,
  );
  @GET('/posts/checksavepost')
  Future<GetResponseMessage> checkSavePost(
    @Query('post_id') String postId,
  );

  @GET('/users/searchuserpage')
  Future<SearchRespone> moreSearchUser(
    @Query('date_boundary') String dateBoundary,
    @Query('limituser') int limitUser,
    @Query('name') String name,
  );

  @GET('/albums/getalbuminit')
  Future<GetAlbumResponseMessage> getAlbumInit(
    @Query('productPerPage') int productPerPage,
  );

  @GET('/albums/getpagealbum')
  Future<GetAlbumResponseMessage> getPageAlbum(
    @Query('currentPage') int currentPage,
    @Query('productPerPage') int productPerPage,
  );

  @GET('/albums/getsearchalbum')
  Future<GetAlbumResponseMessage> getSearchAlbum(
    @Query('productPerPage') int productPerPage,
    @Query('name') String name,
  );

  @GET('/albums/getpagealbumsearch')
  Future<GetAlbumResponseMessage> getPageAlbumSearch(
    @Query('currentPage') int currentPage,
    @Query('productPerPage') int productPerPage,
    @Query('name') String name,
  );

  @POST('/albums/addalbum')
  Future<GetResponseMessage> addAlbum(
    @Field('albumName') String albumName,
  );

  @POST('/albums/adddefaultsavestorage')
  Future<GetResponseMessage> addDefaultSaveStorage();

  @POST('/albums/updatealbum')
  Future<GetResponseMessage> updateAlbum(
      @Field('Id') String id, @Field('album_name') String albumName);

  @POST('/albums/deletealbum')
  Future<GetResponseMessage> deleteAlbum(
      @Field('Id') String id, @Field('status') int status);

  @GET('/posts/getalbumpost')
  Future<GetListOfPostResponseMessage> getAlbumPost(
    @Query('limitPost') int limitPost,
    @Query('albumId') String albumId,
  );

  @GET('/posts/getmorealbumpost')
  Future<GetListOfPostResponseMessage> getMoreAlbumPost(
    @Query('limitPost') int limitPost,
    @Query('currentPage') int currentPage,
    @Query('albumId') String albumId,
  );

  @POST('/searchhistories/addsearchhistory')
  Future<GetResponseMessage> addSearchHistory(
    @Field('user_id') String userId,
  );

  @POST('/searchhistories/deletehistory')
  Future<GetResponseMessage> deleteSearchHistory(
    @Field('user_id') String userId,
  );

  @POST('/comments/deletecomment')
  Future<GetResponseMessage> deleteComment(
    @Field('Id') String id,
  );
  @POST('/likes/addanddeletelike')
  Future<GetResponseMessage> addAndDeleteLike(
    @Field('postId') String postId,
  );

  @POST('/posts/addreferencepost')
  Future<GetResponseMessage> addReferencePost(
    @Field('post_reference_id') String postId,
  );

  @GET('/posts/unsavepost')
  Future<GetResponseMessage> unsavePost(
    @Query('post_id') String postId,
  );
  @GET('/categories/getcategory')
  Future<CategoryRespone> getCategory();

  @POST('/reports/addreport')
  Future<GetResponseMessage> addReport(
    @Field('post_id') String postId,
    @Field('category_id') String categoryId,
    @Field('description') String description,
  );
  @POST('/posts/deletepost')
  Future<GetResponseMessage> deletePost(
    @Field('Id') String postId,
    @Field('status') int status,
  );
  @POST('/posts/updatepost')
  Future<GetResponseMessage> updatePost(
    @Field('post_id') String postId,
    @Field('new_caption') String newCaption,
  );
  @POST('/users/getcaption')
  @MultiPart()
  Future<GetResponseMessage> getCaption(
      @Part(value: 'Img') File img);

  @GET('/contests/getlisttoppostcontest')
  Future<ListTopPostInContestResponseMessage> getListTopPostInContest(
    @Query('contestId') String contestId,
    @Query('limitPost') int limitPost,
  );

  @POST('/posts/searchpostbyimg')
  @MultiPart()
  Future<ListSearchPostResponseMessage> searchPostByImg(
    @Part(value: 'Img') File img,
      @Part(value: 'limitPost') int limitPost
      );
}
