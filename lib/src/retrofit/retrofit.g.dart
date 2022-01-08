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
  Future<GetResponseMessage> activateAccount(code, userID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'code': code, 'user_id': userID};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/users/activationaccount',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetResponseMessage> regenerateCodeForRegister(userID) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'userID': userID};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/users/regeneratecodeforregisaccount',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetResponseMessage> regenerateResetPasswordCode(email) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'user_email': email};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/users/generateresetpasswordcode',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
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
  Future<Response<Map<String, dynamic>>> refreshJwtToken(
      token, refreshToken) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'JwtToken': token, 'RefreshToken': refreshToken};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<Response<Map<String, dynamic>>>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/users/refreshtoken',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    return _result;
  }

  @override
  Future<GetResponseMessage> deleteRefreshJwtToken() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'DELETE', headers: _headers, extra: _extra)
                .compose(_dio.options, '/users/deleterefreshtoken',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetResponseMessage> updateUserProfile(
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
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/users/updateuserprofile',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetNotificationResponseMessage> getNotification(limit) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'limitNotification': limit};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetNotificationResponseMessage>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/notifications/getnotification',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetNotificationResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetNotificationResponseMessage> getMoreNotification(
      limit, dateBoundary) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'limitNotification': limit,
      r'dateBoundary': dateBoundary
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetNotificationResponseMessage>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/notifications/getmorenotification',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetNotificationResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PostListRespone> getPost(postPerPerson, limitDay) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'postPerPerson': postPerPerson,
      r'limitDay': limitDay
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PostListRespone>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/posts/getpostver2',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PostListRespone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PostListRespone> getMorePost(request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PostListRespone>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/posts/getmorepostver2',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PostListRespone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetConversationResponseMessage> getConversations() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetConversationResponseMessage>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/conversations/getconversations',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetConversationResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetConversationResponseMessage> getMoreConversations(
      dateBoundary) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'date_boundary': dateBoundary};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetConversationResponseMessage>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/conversations/getmoreconversations',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetConversationResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetResponseMessage> updateIsSeenMessage(messageId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'message_id': messageId};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/conversations/updateisseenmessage',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetMessageResponseMessage> getMessages(conversationId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'conversationId': conversationId
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetMessageResponseMessage>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/conversations/getmessages',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetMessageResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetMessageResponseMessage> getConversationByUser(userId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'userId': userId};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetMessageResponseMessage>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/conversations/getconversationbyuser',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetMessageResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetMessageResponseMessage> getMoreMessages(
      conversationId, dateBoundary) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'conversationId': conversationId,
      r'date_boundary': dateBoundary
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetMessageResponseMessage>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/conversations/getmoremessages',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetMessageResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ContestListRespone> getActiveContestList(
      searchName, limitContest, dateUp, dateDown) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'searchname': searchName,
      r'limitcontest': limitContest,
      r'date_up': dateUp,
      r'date_dow': dateDown
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ContestListRespone>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/contests/getcontestforuser',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ContestListRespone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ContestListRespone> getInactiveContestList(
      searchName, limitContest, dateUp, dateDown) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'searchname': searchName,
      r'limitcontest': limitContest,
      r'date_up': dateUp,
      r'date_dow': dateDown
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ContestListRespone>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/contests/getcontestinactiveforuser',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ContestListRespone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PostCommentLikeRespone> getInitPostLikeComment(
      commentPerPage, postId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'commentPerPage': commentPerPage,
      r'postId': postId
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PostCommentLikeRespone>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/posts/getpostcommentandlikeInit',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PostCommentLikeRespone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PostCommentListRespone> getMoreComment(
      dateBoundary, commentPerPage, postId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'date_boundary': dateBoundary,
      r'commentPerPage': commentPerPage,
      r'postId': postId
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PostCommentListRespone>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/posts/getpagecomment',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PostCommentListRespone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PostAddCommentRespone> addComment(request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PostAddCommentRespone>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/comments/addcomment',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PostAddCommentRespone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ContestListRespone> getMoreActiveContestList(
      searchName, limitContest, dateBoundary, dateUp, dateDown) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'searchname': searchName,
      r'limitcontest': limitContest,
      r'date_boundary': dateBoundary,
      r'date_up': dateUp,
      r'date_dow': dateDown
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ContestListRespone>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/contests/getmorecontestforuser',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ContestListRespone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ContestListRespone> getMoreInactiveContestList(
      searchName, limitContest, dateBoundary, dateUp, dateDown) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'searchname': searchName,
      r'limitcontest': limitContest,
      r'date_boundary': dateBoundary,
      r'date_up': dateUp,
      r'date_dow': dateDown
    };
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ContestListRespone>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(
                    _dio.options, '/contests/getmorecontestinactiveforuser',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ContestListRespone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ContestRespone> getInitContest(contestId, limitPost) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'contest_id': contestId,
      r'limitPost': limitPost
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ContestRespone>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/contests/getcontestpostver2',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ContestRespone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<ContestPostRespone> getMoreContestPost(
      contestId, limitPost, dateBoundary) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'contest_id': contestId,
      r'limitPost': limitPost,
      r'dateboundary': dateBoundary
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<ContestPostRespone>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/contests/getmorecontestpost',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = ContestPostRespone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UserInContestRespone> getUserInContest(contestId, limitUser) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'contest_id': contestId,
      r'limituser': limitUser
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<UserInContestRespone>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/contests/getuserincontest',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UserInContestRespone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UserInContestRespone> getMoreUserInContest(
      contestId, limitUser, dateBoundary) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'contest_id': contestId,
      r'limituser': limitUser,
      r'date_boundary': dateBoundary
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<UserInContestRespone>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/contests/getmoreuserincontest',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UserInContestRespone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UserInContestRespone> getSearchUserInContest(
      contestId, limitUser, username) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'contest_id': contestId,
      r'limituser': limitUser,
      r'user_name': username
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<UserInContestRespone>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/contests/getsearchuserincontest',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UserInContestRespone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<UserInContestRespone> getMoreSearchUserInContest(
      contestId, limitUser, username, dateBoundary) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'contest_id': contestId,
      r'limituser': limitUser,
      r'user_name': username,
      r'date_boundary': dateBoundary
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<UserInContestRespone>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/contests/getmoresearchuserincontest',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = UserInContestRespone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SearchHistoryRespone> getSearchHistory(limit) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'limit': limit};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SearchHistoryRespone>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/searchhistories/getsearchhistory',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SearchHistoryRespone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SearchHistoryRespone> getMoreSearchHistory(limit, dateBoundary) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'limit': limit,
      r'date_boundary': dateBoundary
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SearchHistoryRespone>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/searchhistories/getmoresearchhistory',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SearchHistoryRespone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<PostDetailRespone> getPostDetail(postId, contestId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'post_id': postId,
      r'contest_id': contestId
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<PostDetailRespone>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/posts/getpostdetailver2',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = PostDetailRespone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SearchRespone> searchUser(limitUser, name) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'limituser': limitUser,
      r'name': name
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SearchRespone>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/users/searchuser',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SearchRespone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SearchRespone> moreSearchUser(
      dateBoundary, limitUser, name) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'date_boundary': dateBoundary,
      r'limituser': limitUser,
      r'name': name
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<SearchRespone>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/users/searchuserpage',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = SearchRespone.fromJson(_result.data!);
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
