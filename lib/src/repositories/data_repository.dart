import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/constant/error_message.dart';
import 'package:imagecaptioning/src/model/album/album.dart';
import 'package:imagecaptioning/src/model/post/album_post_list_respone.dart';
import 'package:imagecaptioning/src/model/post/post_detail_respone.dart';
import 'package:imagecaptioning/src/model/search/search_history_respone.dart';
import 'package:imagecaptioning/src/model/search/search_respone.dart';
import '../model/contest/contest_post_respone.dart';
import '../model/contest/contest_respone.dart';
import '../model/contest/user_in_contest_respone.dart';
import '../controller/get_it/get_it.dart';
import '../model/conversation/conversation.dart';
import '../model/generic/generic.dart';
import '../model/conversation/message.dart';
import '../model/notification/notification.dart';
import '../model/contest/contest_list_respone.dart';
import '../model/post/post_add_comment_request.dart';
import '../model/post/post_comment_like_respone.dart';
import '../model/post/post_comment_list_respone.dart';
import '../model/post/post_list_request.dart';
import '../model/post/post_list_respone.dart';
import '../model/user/user.dart';
import '../model/user/user_details.dart';
import '../prefs/app_prefs.dart';
import '../retrofit/retrofit.dart';

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
          try {
            if (error.response != null) {
              log(error.response!.data['messageCode'].toString());
              if (error.response!.statusCode == 401 &&
                  error.response!.data['messageCode'] ==
                      MessageCode.tokenExpired) {
                String token = getIt<AppPref>().getToken;
                String refreshToken = getIt<AppPref>().getRefreshToken;

                // const _extra = <String, dynamic>{};
                // final queryParameters = <String, dynamic>{};
                // final _headers = <String, dynamic>{};
                final _data = {'JwtToken': token, 'RefreshToken': refreshToken};

                final response = await _dio
                    .post(appBaseUrl + '/users/refreshtoken', data: _data);
                final value = GetResponseMessage.fromJson(response.data!);

                //Map<String, dynamic> value = response.data!;
                String? data = value.data;
                if (data != null) {
                  getIt<AppPref>().setToken(value.data);
                  setJwtInHeader();
                  handler.resolve(response);
                } else {
                  handler.reject(error);
                }
              } else if (error.response!.statusCode == 401 &&
                  error.response!.data['messageCode'] ==
                      MessageCode.refreshTokenExpired) {
                handler.next(error);
              } else {
                handler.next(error);
              }
            } else {
              handler.next(error);
            }
          } catch (_) {
            log(_.toString());
            handler.next(error);
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
  Future<GetResponseMessage> activateAccount(String code, String userID) async {
    return _client.activateAccount(code, userID);
  }

  @override
  Future<GetResponseMessage> regenerateCodeForRegister(String userID) async {
    return _client.regenerateCodeForRegister(userID);
  }

  @override
  Future<GetUserDetailsResponseMessage> getUserDetail(
      String userID, int limitPost) {
    return _client.getUserDetail(userID, limitPost);
  }

  @override
  Future<GetResponseMessage> generateResetPasswordCode(String email) {
    return _client.generateResetPasswordCode(email);
  }

  @override
  Future<GetResponseMessage> validateResetPasswordCode(
      String code, String userId) {
    return _client.validateResetPasswordCode(code, userId);
  }

  @override
  Future<GetResponseMessage> resetPassword(String userId, String password) {
    return _client.resetPassword(userId, password);
  }

  @override
  Future<GetResponseMessage> refreshJwtToken(
      String token, String refreshToken) {
    return _client.refreshJwtToken(token, refreshToken);
  }

  @override
  Future<GetResponseMessage> updateUserProfile(String username, String email,
      String? phone, String? desc, String? userRealName, File? avatarImg) {
    return _client.updateUserProfile(
        username, email, phone, desc, userRealName, avatarImg);
  }

  @override
  Future<GetNotificationResponseMessage> getNotification(int limit) {
    return _client.getNotification(limit);
  }

  @override
  Future<GetNotificationResponseMessage> getMoreNotification(
      int limit, String dateBoundary) {
    return _client.getMoreNotification(limit, dateBoundary);
  }

  @override
  Future<PostListRespone> getPost(int postPerPerson, int limitDay) {
    return _client.getPost(postPerPerson, limitDay);
  }

  @override
  Future<PostListRespone> getMorePost(PostListRequest request) {
    return _client.getMorePost(request);
  }

  @override
  Future<GetConversationResponseMessage> getConversations() {
    return _client.getConversations();
  }

  @override
  Future<GetConversationResponseMessage> getMoreConversations(
      String dateBoundary) {
    return _client.getMoreConversations(dateBoundary);
  }

  @override
  Future<ContestListRespone> getActiveContestList(
      String? searchName, int limitContest, String? dateUp, String? dateDown) {
    return _client.getActiveContestList(
        searchName, limitContest, dateUp, dateDown);
  }

  @override
  Future<PostDetailRespone> getPostDetail(String postId, String contestId) {
    return _client.getPostDetail(postId, contestId);
  }

  @override
  Future<GetResponseMessage> updateIsSeenMessage(String messageId) {
    return _client.updateIsSeenMessage(messageId);
  }

  @override
  Future<GetMessageResponseMessage> getMessages(
      String conversationId, int limitMessage) {
    return _client.getMessages(conversationId, limitMessage);
  }

  @override
  Future<GetMessageResponseMessage> getConversationByUser(String userId) {
    return _client.getConversationByUser(userId);
  }

  @override
  Future<GetMessageResponseMessage> getMoreMessages(
      String conversationId, String dateBoundary, int limitMessage) {
    return _client.getMoreMessages(conversationId, dateBoundary, limitMessage);
  }

  @override
  Future<PostCommentLikeRespone> getInitPostLikeComment(
      int commentPerPage, String postId) {
    return _client.getInitPostLikeComment(commentPerPage, postId);
  }

  @override
  Future<PostCommentListRespone> getMoreComment(
      String dateBoundary, int commentPerPage, String postId) {
    return _client.getMoreComment(dateBoundary, commentPerPage, postId);
  }

  @override
  Future<GetResponseMessage> addComment(PostAddCommentRequest request) {
    return _client.addComment(request);
  }

  @override
  Future<GetResponseMessage> deleteRefreshJwtToken() {
    return _client.deleteRefreshJwtToken();
  }

  @override
  Future<ContestListRespone> getInactiveContestList(
      String? searchName, int limitContest, String? dateUp, String? dateDown) {
    return _client.getInactiveContestList(
        searchName, limitContest, dateUp, dateDown);
  }

  @override
  Future<ContestRespone> getInitContest(String contestId, int limitPost) {
    return _client.getInitContest(contestId, limitPost);
  }

  @override
  Future<ContestListRespone> getMoreActiveContestList(String? searchName,
      int limitContest, String dateBoundary, String? dateUp, String? dateDown) {
    return _client.getMoreActiveContestList(
        searchName, limitContest, dateBoundary, dateUp, dateDown);
  }

  @override
  Future<ContestListRespone> getMoreInactiveContestList(String? searchName,
      int limitContest, String dateBoundary, String? dateUp, String? dateDown) {
    return _client.getMoreInactiveContestList(
        searchName, limitContest, dateBoundary, dateUp, dateDown);
  }

  @override
  Future<GetResponseMessage> addFollow(String followeeId) {
    return _client.addFollow(followeeId);
  }

  @override
  Future<GetResponseMessage> deleteFollow(String followeeId) {
    return _client.deleteFollow(followeeId);
  }

  @override
  Future<ContestPostRespone> getMoreContestPost(
      String contestId, int limitPost, String dateBoundary) {
    return _client.getMoreContestPost(contestId, limitPost, dateBoundary);
  }

  @override
  Future<UserInContestRespone> getMoreSearchUserInContest(
      String contestId, int limitUser, String username, String dateBoundary) {
    return _client.getMoreSearchUserInContest(
        contestId, limitUser, username, dateBoundary);
  }

  @override
  Future<UserInContestRespone> getMoreUserInContest(
      String contestId, int limitUser, String dateBoundary) {
    return _client.getMoreUserInContest(contestId, limitUser, dateBoundary);
  }

  @override
  Future<UserInContestRespone> getSearchUserInContest(
      String contestId, int limitUser, String username) {
    return _client.getSearchUserInContest(contestId, limitUser, username);
  }

  @override
  Future<UserInContestRespone> getUserInContest(
      String contestId, int limitUser) {
    return _client.getUserInContest(contestId, limitUser);
  }

  @override
  Future<SearchHistoryRespone> getSearchHistory(int limit) {
    return _client.getSearchHistory(limit);
  }

  @override
  Future<SearchHistoryRespone> getMoreSearchHistory(
      int limit, String dateBoundary) {
    return _client.getMoreSearchHistory(limit, dateBoundary);
  }

  @override
  Future<SearchRespone> moreSearchUser(
      String dateBoundary, int limitUser, String name) {
    return _client.moreSearchUser(dateBoundary, limitUser, name);
  }

  @override
  Future<SearchRespone> searchUser(int limitUser, String name) {
    return _client.searchUser(limitUser, name);
  }

  @override
  Future<GetResponseMessage> addAlbum(String albumName) {
    return _client.addAlbum(albumName);
  }

  @override
  Future<GetResponseMessage> addDefaultSaveStorage() {
    return _client.addDefaultSaveStorage();
  }

  @override
  Future<GetResponseMessage> deleteAlbum(String id, int status) {
    return _client.deleteAlbum(id, status);
  }

  @override
  Future<GetAlbumResponseMessage> getAlbumInit(int productPerPage) {
    return _client.getAlbumInit(productPerPage);
  }

  @override
  Future<GetAlbumResponseMessage> getPageAlbum(
      int currentPage, int productPerPage) {
    return _client.getPageAlbum(currentPage, productPerPage);
  }

  @override
  Future<GetAlbumResponseMessage> getPageAlbumSearch(
      int currentPage, int productPerPage, String name) {
    return _client.getPageAlbumSearch(currentPage, productPerPage, name);
  }

  @override
  Future<GetAlbumResponseMessage> getSearchAlbum(
      int productPerPage, String name) {
    return _client.getSearchAlbum(productPerPage, name);
  }

  @override
  Future<GetResponseMessage> updateAlbum(String id, String albumName) {
    return _client.updateAlbum(id, albumName);
  }

  @override
  Future<GetAlbumPostListResponseMessage> getAlbumPost(
      int limitPost, String albumId) {
    return _client.getAlbumPost(limitPost, albumId);
  }

  @override
  Future<GetAlbumPostListResponseMessage> getMoreAlbumPost(
      int limitPost, int currentPage, String albumId) {
    return _client.getMoreAlbumPost(limitPost, currentPage, albumId);
  }

  @override
  Future<GetResponseMessage> addSearchHistory(String userId) {
    return _client.addSearchHistory(userId);
  }

  @override
  Future<GetResponseMessage> deleteSearchHistory(String userId) {
    return _client.deleteSearchHistory(userId);
  }

  @override
  Future<GetResponseMessage> deleteComment(String id) {
    return _client.deleteComment(id);
  }

  @override
  Future<GetResponseMessage> addAndDeleteLike(String postId) {
    return _client.addAndDeleteLike(postId);
  }

  @override
  Future<GetResponseMessage> checkSavePost(String postId) {
    return _client.checkSavePost(postId);
  }
}
