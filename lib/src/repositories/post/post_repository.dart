import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:imagecaptioning/src/model/category/category_respone.dart';
import 'package:imagecaptioning/src/model/generic/generic.dart';
import 'package:imagecaptioning/src/model/post/add_post_response.dart';
import 'package:imagecaptioning/src/model/post/list_of_post_respone.dart';
import 'package:imagecaptioning/src/model/search/search_post.dart';

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
  Future<AddPostResponseMessage?> addPost(
      {required String albumId,
      required String? contestId,
      required File postImg,
      required String aiCaption,
      required String? userCaption});
  Future<PostCommentLikeRespone> getInitLikeComment(
      int commentPerPage, String postId);
  Future<PostCommentListRespone> getMoreComment(
      String dateBoundary, int commentPerPage, String postId);
  Future<GetResponseMessage> addComment(PostAddCommentRequest request);
  Future<GetResponseMessage> deleteComment(String id);
  Future<GetResponseMessage?> addAndDeleteLike(String postId);
  Future<GetResponseMessage> checkSavePost(String postId);
  Future<GetResponseMessage> savePost(String postId);
  Future<GetResponseMessage> unsavePost(String postId);
  Future<GetResponseMessage> deletePost(String postId);
  Future<GetResponseMessage> addReport(
      String postId, String categoryId, String description);
  Future<GetListOfPostResponseMessage?> getRandomPost(
      int limitPost, int LimitDay);
  Future<GetListOfPostResponseMessage?> getMoreRandomPost(
      int limitPost, int LimitDay, String dateBoundary);
  Future<CategoryRespone> getCategory();
  Future<GetListOfPostResponseMessage?> getPostStorage(
      {required int limitPost});
  Future<GetListOfPostResponseMessage?> getMorePostStorage(
      {required int limitPost, required int currentPage});
  Future<GetListOfPostResponseMessage?> getMoreUserPost(
      {required String userID,
      required int limitPost,
      required String dateBoundary});
  Future<GetListOfPostResponseMessage?> getMoreUserContestPost(
      {required String userID,
      required int limitPost,
      required String dateBoundary});
  Future<GetListOfPostResponseMessage?> getUserContestPost(
      {required String userID, required int limitPost});
  Future<GetResponseMessage?> getCaption({required File img});
  Future<ListSearchPostResponseMessage?> searchPostByImg(
      {required File img, required int limitPost});
  Future<GetResponseMessage?> updatePost(
      {required String postId, required String newCaption});
  Future<ListSearchPostResponseMessage?> searchPostByKey(
      {required String searchString, required int limitPost});
  Future<ListSearchPostResponseMessage?> searchMorePostByKey(
      {required String searchString,
      required int limitPost,
      required String dateBoundary});
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
      log(e.toString());
      return null;
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
      log(e.toString());
      return null;
    }
  }

  @override
  Future<AddPostResponseMessage?> addPost(
      {required String albumId,
      required String? contestId,
      required File postImg,
      required String aiCaption,
      required String? userCaption}) async {
    try {
      final resMessage = await _dataRepository.addPost(
          albumId, contestId, postImg, aiCaption, userCaption);

      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          AddPostResponseMessage resMessage =
              AddPostResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<GetResponseMessage?> getCaption({required File img}) async {
    try {
      final resMessage = await _dataRepository.getCaption(img);

      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetResponseMessage resMessage =
              GetResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
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
  Future<GetResponseMessage?> addAndDeleteLike(String postId) async {
    GetResponseMessage respone = GetResponseMessage();
    try {
      respone = await _dataRepository.addAndDeleteLike(postId);
      return respone;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetResponseMessage resMessage =
              GetResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
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

  @override
  Future<GetListOfPostResponseMessage?> getPostStorage(
      {required int limitPost}) async {
    try {
      final resMessage = await _dataRepository.getPostStorage(limitPost);
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetListOfPostResponseMessage resMessage =
              GetListOfPostResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<GetListOfPostResponseMessage?> getMorePostStorage(
      {required int limitPost, required int currentPage}) async {
    try {
      final resMessage =
          await _dataRepository.getMorePostStorage(limitPost, currentPage);
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetListOfPostResponseMessage resMessage =
              GetListOfPostResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<GetListOfPostResponseMessage?> getMoreUserPost(
      {required String userID,
      required int limitPost,
      required String dateBoundary}) async {
    try {
      final resMessage = await _dataRepository.getMoreUserPost(
          userID, limitPost, dateBoundary);
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetListOfPostResponseMessage resMessage =
              GetListOfPostResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<GetListOfPostResponseMessage?> getMoreUserContestPost(
      {required String userID,
      required int limitPost,
      required String dateBoundary}) async {
    try {
      final resMessage = await _dataRepository.getMoreUserPost(
          userID, limitPost, dateBoundary);

      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetListOfPostResponseMessage resMessage =
              GetListOfPostResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<GetListOfPostResponseMessage?> getUserContestPost(
      {required String userID, required int limitPost}) async {
    try {
      final resMessage =
          await _dataRepository.getUserContestPost(userID, limitPost);
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetListOfPostResponseMessage resMessage =
              GetListOfPostResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<ListSearchPostResponseMessage?> searchPostByImg(
      {required File img, required int limitPost}) async {
    try {
      final resMessage = await _dataRepository.searchPostByImg(img, limitPost);

      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          ListSearchPostResponseMessage resMessage =
              ListSearchPostResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<GetResponseMessage?> updatePost(
      {required String postId, required String newCaption}) async {
    try {
      final resMessage = await _dataRepository.updatePost(postId, newCaption);

      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetResponseMessage resMessage =
              GetResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<ListSearchPostResponseMessage?> searchPostByKey(
      {required String searchString, required int limitPost}) async {
    try {
      final resMessage =
          await _dataRepository.searchPostByKey(searchString, limitPost);

      return resMessage;
    } catch (e) {
<<<<<<< HEAD
      log(e.toString());
=======
>>>>>>> origin/NhanNT
      if (e is DioError) {
        if (e.response != null) {
          ListSearchPostResponseMessage resMessage =
              ListSearchPostResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<ListSearchPostResponseMessage?> searchMorePostByKey(
      {required String searchString,
      required int limitPost,
      required String dateBoundary}) async {
    try {
      final resMessage = await _dataRepository.searchMorePostByKey(
          searchString, limitPost, dateBoundary);

      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          ListSearchPostResponseMessage resMessage =
              ListSearchPostResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<GetListOfPostResponseMessage?> getMoreRandomPost(
      int limitPost, int LimitDay, String dateBoundary) async {
    try {
      final GetListOfPostResponseMessage respone = await _dataRepository
          .getMoreRandomPost(limitPost, LimitDay, dateBoundary);
      return respone;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }

  @override
  Future<GetListOfPostResponseMessage?> getRandomPost(
      int limitPost, int LimitDay) async {
    try {
      final GetListOfPostResponseMessage respone =
          await _dataRepository.getRandomPost(
        limitPost,
        LimitDay,
      );
      return respone;
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}
