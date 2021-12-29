import 'dart:developer';

import 'package:imagecaptioning/src/model/post/comment.dart';
import 'package:imagecaptioning/src/model/post/list_post_data.dart';
import 'package:imagecaptioning/src/model/post/post_comment_like_data.dart';
import 'package:imagecaptioning/src/model/post/post_comment_like_respone.dart';
import 'package:imagecaptioning/src/model/post/post_comment_respone.dart';
import 'package:imagecaptioning/src/model/post/post_list_request.dart';
import 'package:imagecaptioning/src/model/post/post_list_respone.dart';

import '../data_repository.dart';

abstract class PostBehavior {
  Future<ListPostData?> getPost(int postPerPerson, int limitDay);
  Future<ListPostData?> getMorePost(PostListRequest request);
  Future<PostCommentLikeData?> getInitLikeComment(
      int commentPerPage, String postId);
  Future<PostCommentRespone?> getMoreComment(
      String dateBoundary, int commentPerPage, String postId);
}

class PostRepository extends PostBehavior {
  final DataRepository _dataRepository = DataRepository();

  @override
  Future<ListPostData?> getPost(int postPerPerson, int limitDay) async {
    try {
      final PostListRespone respone =
          await _dataRepository.getPost(postPerPerson, limitDay);
      final ListPostData? data = respone.data;
      return data;
    } catch (e) {
      //return null;
      log(e.toString());
    }
  }

  @override
  Future<ListPostData?> getMorePost(PostListRequest request) async {
    try {
      final PostListRespone respone =
          await _dataRepository.getMorePost(request);
      final ListPostData? data = respone.data;
      return data;
    } catch (e) {
      //return null;
      log(e.toString());
    }
  }

  @override
  Future<PostCommentLikeData?> getInitLikeComment(
      int commentPerPage, String postId) async {
    try {
      final PostCommentLikeRespone respone =
          await _dataRepository.getInitPostLikeComment(commentPerPage, postId);
      final PostCommentLikeData? data = respone.data;
      return data;
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<PostCommentRespone?> getMoreComment(
      String dateBoundary, int commentPerPage, String postId) async {
    try {
      final PostCommentRespone respone = await _dataRepository.getMoreComment(
          dateBoundary, commentPerPage, postId);
      return respone;
    } catch (e) {
      log(e.toString());
    }
  }
}
