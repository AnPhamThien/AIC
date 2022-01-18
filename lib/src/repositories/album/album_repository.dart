import 'package:dio/dio.dart';
import 'package:imagecaptioning/src/model/album/album.dart';
import 'package:imagecaptioning/src/model/generic/generic.dart';
import 'package:imagecaptioning/src/model/post/album_post_list_respone.dart';
import 'package:imagecaptioning/src/repositories/data_repository.dart';

abstract class UserBehavior {
  Future<GetAlbumResponseMessage?> getAlbumInit({required int productPerPage});

  Future<GetAlbumResponseMessage?> getPageAlbum(
      {required int currentPage, required int productPerPage});

  Future<GetAlbumResponseMessage?> getPageAlbumSearch(
      {required int currentPage,
      required int productPerPage,
      required String name});

  Future<GetAlbumResponseMessage?> getSearchAlbum(
      {required int productPerPage, required String name});

  Future<dynamic> addAlbum({required String albumName});

  Future<dynamic> addDefaultSaveStorage();

  Future<dynamic> deleteAlbum({required String id, required int status});

  Future<dynamic> updateAlbum({required String id, required String albumName});

  Future<GetAlbumPostListResponseMessage?> getAlbumPost(
      {required int limitPost, required String albumId});

  Future<GetAlbumPostListResponseMessage?> getMoreAlbumPost(
      {required int limitPost,
      required int currentPage,
      required String albumId});
}

class AlbumRepository extends UserBehavior {
  final DataRepository _dataRepository = DataRepository();

  @override
  Future<GetAlbumResponseMessage?> getAlbumInit(
      {required int productPerPage}) async {
    try {
      GetAlbumResponseMessage resMessage =
          await _dataRepository.getAlbumInit(productPerPage);
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetAlbumResponseMessage resMessage =
              GetAlbumResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<GetAlbumResponseMessage?> getPageAlbum(
      {required int currentPage, required int productPerPage}) async {
    try {
      GetAlbumResponseMessage resMessage =
          await _dataRepository.getPageAlbum(currentPage, productPerPage);
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetAlbumResponseMessage resMessage =
              GetAlbumResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<GetAlbumResponseMessage?> getSearchAlbum(
      {required int productPerPage, required String name}) async {
    try {
      GetAlbumResponseMessage resMessage =
          await _dataRepository.getSearchAlbum(productPerPage, name);
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetAlbumResponseMessage resMessage =
              GetAlbumResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<GetAlbumResponseMessage?> getPageAlbumSearch(
      {required int currentPage,
      required int productPerPage,
      required String name}) async {
    try {
      GetAlbumResponseMessage resMessage = await _dataRepository
          .getPageAlbumSearch(currentPage, productPerPage, name);
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetAlbumResponseMessage resMessage =
              GetAlbumResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<dynamic> addAlbum({required String albumName}) async {
    try {
      GetResponseMessage resMessage = await _dataRepository.addAlbum(albumName);
      final response = resMessage.messageCode ?? resMessage.statusCode;
      return response;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetResponseMessage resMessage =
              GetResponseMessage.fromJson(e.response!.data);
          final response = resMessage.messageCode;
          return response;
        }
      }
      return null;
    }
  }

  @override
  Future<dynamic> addDefaultSaveStorage() async {
    try {
      GetResponseMessage resMessage =
          await _dataRepository.addDefaultSaveStorage();
      final response = resMessage.messageCode ?? resMessage.statusCode;
      return response;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetResponseMessage resMessage =
              GetResponseMessage.fromJson(e.response!.data);
          final response = resMessage.messageCode;
          return response;
        }
      }
      return null;
    }
  }

  @override
  Future<dynamic> deleteAlbum({required String id, required int status}) async {
    try {
      GetResponseMessage resMessage =
          await _dataRepository.deleteAlbum(id, status);
      final response = resMessage.messageCode ?? resMessage.statusCode;
      return response;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetResponseMessage resMessage =
              GetResponseMessage.fromJson(e.response!.data);
          final response = resMessage.messageCode;
          return response;
        }
      }
      return null;
    }
  }

  @override
  Future<dynamic> updateAlbum(
      {required String id, required String albumName}) async {
    try {
      GetResponseMessage resMessage =
          await _dataRepository.updateAlbum(id, albumName);
      final response = resMessage.messageCode ?? resMessage.statusCode;
      return response;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetResponseMessage resMessage =
              GetResponseMessage.fromJson(e.response!.data);
          final response = resMessage.messageCode;
          return response;
        }
      }
      return null;
    }
  }

  @override
  Future<GetAlbumPostListResponseMessage?> getAlbumPost(
      {required int limitPost, required String albumId}) async {
    try {
      GetAlbumPostListResponseMessage resMessage =
          await _dataRepository.getAlbumPost(limitPost, albumId);
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetAlbumPostListResponseMessage resMessage =
              GetAlbumPostListResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<GetAlbumPostListResponseMessage?> getMoreAlbumPost(
      {required int limitPost,
      required int currentPage,
      required String albumId}) async {
    try {
      GetAlbumPostListResponseMessage resMessage = await _dataRepository
          .getMoreAlbumPost(limitPost, currentPage, albumId);
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetAlbumPostListResponseMessage resMessage =
              GetAlbumPostListResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }
}
