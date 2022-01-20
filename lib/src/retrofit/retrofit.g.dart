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
  Future<GetResponseMessage> generateResetPasswordCode(email) async {
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
  Future<GetResponseMessage> validateResetPasswordCode(code, userId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'code': code, 'user_id': userId};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/users/validresetpasswordcode',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetResponseMessage> resetPassword(userId, password) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'Id': userId, 'user_password': password};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/users/resetpassword',
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
  Future<GetResponseMessage> refreshJwtToken(token, refreshToken) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'JwtToken': token, 'RefreshToken': refreshToken};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/users/refreshtoken',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
    return value;
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
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('user_name', username));
    _data.fields.add(MapEntry('user_email', email));
    if (phone != null) {
      _data.fields.add(MapEntry('phone', phone));
    }
    if (desc != null) {
      _data.fields.add(MapEntry('description', desc));
    }
    if (userRealName != null) {
      _data.fields.add(MapEntry('user_real_name', userRealName));
    }
    _data.files.add(MapEntry(
        'avatar_img',
        MultipartFile.fromFileSync(avatarImg!.path,
            filename: avatarImg.path.split(Platform.pathSeparator).last)));
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
  Future<AddPostResponseMessage> addPost(
      albumId, contestId, postImg, aiCaption, userCaption) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry('album_id', albumId));
    if (contestId != null) {
      _data.fields.add(MapEntry('contest_id', contestId));
    }
    _data.files.add(MapEntry(
        'PostImg',
        MultipartFile.fromFileSync(postImg.path,
            filename: postImg.path.split(Platform.pathSeparator).last)));
    _data.fields.add(MapEntry('ai_caption', aiCaption));
    if (userCaption != null) {
      _data.fields.add(MapEntry('user_caption', userCaption));
    }
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/posts/addpost',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = AddPostResponseMessage.fromJson(_result.data!);
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
  Future<GetMessageResponseMessage> getMessages(
      conversationId, limitMessage) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'conversationId': conversationId,
      r'limitMessage': limitMessage
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
      conversationId, dateBoundary, limitMessage) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'conversationId': conversationId,
      r'date_boundary': dateBoundary,
      r'limitMessage': limitMessage
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
  Future<GetResponseMessage> addComment(request) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    _data.addAll(request.toJson());
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/comments/addcomment',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
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
  Future<GetResponseMessage> addFollow(followeeId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'followeeId': followeeId};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/follows/addfollow',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetResponseMessage> deleteFollow(followeeId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'followeeId': followeeId};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/follows/deletefollow',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
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
  Future<GetResponseMessage> checkSavePost(postId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'post_id': postId};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/posts/checksavepost',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<SearchRespone> moreSearchUser(dateBoundary, limitUser, name) async {
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

  @override
  Future<GetAlbumResponseMessage> getAlbumInit(productPerPage) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'productPerPage': productPerPage
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetAlbumResponseMessage>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/albums/getalbuminit',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetAlbumResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetAlbumResponseMessage> getPageAlbum(
      currentPage, productPerPage) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'currentPage': currentPage,
      r'productPerPage': productPerPage
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetAlbumResponseMessage>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/albums/getpagealbum',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetAlbumResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetAlbumResponseMessage> getSearchAlbum(productPerPage, name) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'productPerPage': productPerPage,
      r'name': name
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetAlbumResponseMessage>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/albums/getsearchalbum',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetAlbumResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetAlbumResponseMessage> getPageAlbumSearch(
      currentPage, productPerPage, name) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'currentPage': currentPage,
      r'productPerPage': productPerPage,
      r'name': name
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetAlbumResponseMessage>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/albums/getpagealbumsearch',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetAlbumResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetResponseMessage> addAlbum(albumName) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'albumName': albumName};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/albums/addalbum',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetResponseMessage> addDefaultSaveStorage() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/albums/adddefaultsavestorage',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetResponseMessage> updateAlbum(id, albumName) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'Id': id, 'album_name': albumName};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/albums/updatealbum',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetResponseMessage> deleteAlbum(id, status) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'Id': id, 'status': status};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/albums/deletealbum',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetAlbumPostListResponseMessage> getAlbumPost(
      limitPost, albumId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'limitPost': limitPost,
      r'albumId': albumId
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetAlbumPostListResponseMessage>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/posts/getalbumpost',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetAlbumPostListResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetAlbumPostListResponseMessage> getMoreAlbumPost(
      limitPost, currentPage, albumId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{
      r'limitPost': limitPost,
      r'currentPage': currentPage,
      r'albumId': albumId
    };
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetAlbumPostListResponseMessage>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/posts/getmorealbumpost',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetAlbumPostListResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetResponseMessage> addSearchHistory(userId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'user_id': userId};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/searchhistories/addsearchhistory',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetResponseMessage> deleteSearchHistory(userId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'user_id': userId};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/searchhistories/deletehistory',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetResponseMessage> deleteComment(id) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'Id': id};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/comments/deletecomment',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetResponseMessage> addAndDeleteLike(postId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'postId': postId};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/likes/addanddeletelike',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetResponseMessage> addReferencePost(postId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {'post_reference_id': postId};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/posts/addreferencepost',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetResponseMessage> unsavePost(postId) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{r'post_id': postId};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/posts/unsavepost',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
    return value;
  }

  @override
  Future<CategoryRespone> getCategory() async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = <String, dynamic>{};
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<CategoryRespone>(
            Options(method: 'GET', headers: _headers, extra: _extra)
                .compose(_dio.options, '/categories/getcategory',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = CategoryRespone.fromJson(_result.data!);
    return value;
  }

  @override
  Future<GetResponseMessage> addReport(postId, categoryId, description) async {
    const _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    final _headers = <String, dynamic>{};
    final _data = {
      'post_id': postId,
      'category_id': categoryId,
      'description': description
    };
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<GetResponseMessage>(
            Options(method: 'POST', headers: _headers, extra: _extra)
                .compose(_dio.options, '/reports/addreport',
                    queryParameters: queryParameters, data: _data)
                .copyWith(baseUrl: baseUrl ?? _dio.options.baseUrl)));
    final value = GetResponseMessage.fromJson(_result.data!);
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
