import 'dart:developer';

import 'package:imagecaptioning/src/model/category/category_respone.dart';
import 'package:imagecaptioning/src/model/generic/generic.dart';

import '../../model/post/list_post_data.dart';
import '../../model/post/post_add_comment_request.dart';
import '../../model/post/post_comment_like_respone.dart';
import '../../model/post/post_comment_list_respone.dart';
import '../../model/post/post_list_request.dart';
import '../../model/post/post_list_respone.dart';
import '../data_repository.dart';

abstract class PostBehavior {
  Future<ListPostData?> getPost(int postPerPerson, int limitDay);
  Future<ListPostData?> getMorePost(PostListRequest request);
  Future<PostCommentLikeRespone> getInitLikeComment(
      int commentPerPage, String postId);
  Future<PostCommentListRespone> getMoreComment(
      String dateBoundary, int commentPerPage, String postId);
  Future<GetResponseMessage> addComment(PostAddCommentRequest request);
  Future<GetResponseMessage> deleteComment(String id);
  Future<GetResponseMessage> addAndDeleteLike(String postId);
  Future<GetResponseMessage> checkSavePost(String postId);
  Future<GetResponseMessage> savePost(String postId);
  Future<GetResponseMessage> unsavePost(String postId);
  Future<GetResponseMessage> deletePost(String postId);
  Future<GetResponseMessage> addReport(
      String postId, String categoryId, String description);
  Future<CategoryRespone> getCategory();
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
  Future<PostCommentLikeRespone> getInitLikeComment(
      int commentPerPage, String postId) async {
    PostCommentLikeRespone respone = PostCommentLikeRespone();
    try {
      respone =
          await _dataRepository.getInitPostLikeComment(commentPerPage, postId);
      return respone;
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }

  @override
  Future<PostCommentListRespone> getMoreComment(
      String dateBoundary, int commentPerPage, String postId) async {
    PostCommentListRespone respone = PostCommentListRespone();
    try {
      respone = await _dataRepository.getMoreComment(
          dateBoundary, commentPerPage, postId);
      return respone;
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }

  @override
  Future<GetResponseMessage> addComment(PostAddCommentRequest request) async {
    GetResponseMessage respone = GetResponseMessage();
    try {
      respone = await _dataRepository.addComment(request);
      return respone;
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }

  @override
  Future<GetResponseMessage> deleteComment(String id) async {
    GetResponseMessage respone = GetResponseMessage();
    try {
      respone = await _dataRepository.deleteComment(id);
      return respone;
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }

  @override
  Future<GetResponseMessage> addAndDeleteLike(String postId) async {
    GetResponseMessage respone = GetResponseMessage();
    try {
      respone = await _dataRepository.addAndDeleteLike(postId);
      return respone;
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }

  @override
  Future<GetResponseMessage> checkSavePost(String postId) async {
    GetResponseMessage respone = GetResponseMessage();
    try {
      respone = await _dataRepository.checkSavePost(postId);
      return respone;
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }

  @override
  Future<GetResponseMessage> savePost(String postId) async {
    GetResponseMessage respone = GetResponseMessage();
    try {
      respone = await _dataRepository.addReferencePost(postId);
      return respone;
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }

  @override
  Future<GetResponseMessage> unsavePost(String postId) async {
    GetResponseMessage respone = GetResponseMessage();
    try {
      respone = await _dataRepository.unsavePost(postId);
      return respone;
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }

  @override
  Future<CategoryRespone> getCategory() async {
    CategoryRespone respone = CategoryRespone();
    try {
      respone = await _dataRepository.getCategory();
      return respone;
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }

  @override
  Future<GetResponseMessage> addReport(
      String postId, String categoryId, String description) async {
    GetResponseMessage respone = GetResponseMessage();
    try {
      respone =
          await _dataRepository.addReport(postId, categoryId, description);
      return respone;
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }

  @override
  Future<GetResponseMessage> deletePost(String postId) async {
    GetResponseMessage respone = GetResponseMessage();
    try {
      respone = await _dataRepository.deletePost(postId, 4);
      return respone;
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }
}
