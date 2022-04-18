import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:imagecaptioning/src/model/contest/contest_details_response.dart';
import 'package:imagecaptioning/src/model/user/user_details.dart';

import '../../model/contest/list_top_post_in_contest.dart';
import '../../model/post/post_detail_respone.dart';

import '../../model/contest/contest_post_respone.dart';
import '../../model/contest/contest_respone.dart';
import '../../model/contest/user_in_contest_respone.dart';

import '../../model/contest/contest.dart';
import '../../model/contest/contest_list_respone.dart';

import '../data_repository.dart';

abstract class ContestBehavior {
  Future<List<Contest>?> getActiveContestList(
      String? searchName, int limitContest, String? dateUp, String? dateDown);
  Future<List<Contest>?> getInactiveContestList(
      String? searchName, int limitContest, String? dateUp, String? dateDown);
  Future<List<Contest>?> getMoreActiveContestList(String? searchName,
      int limitContest, String dateBoundary, String? dateUp, String? dateDown);
  Future<List<Contest>?> getMoreInactiveContestList(String? searchName,
      int limitContest, String dateBoundary, String? dateUp, String? dateDown);
  Future<ContestRespone> getInitContest(String contestId, int limitPost);
  Future<ContestPostRespone> getMoreContestPost(
      String contestId, int limitPost, String dateBoundary);
  Future<UserInContestRespone> getMoreSearchUserInContest(
      String contestId, int limitUser, String username, String dateBoundary);
  Future<UserInContestRespone> getMoreUserInContest(
      String contestId, int limitUser, String dateBoundary);
  Future<UserInContestRespone> getSearchUserInContest(
      String contestId, int limitUser, String username);
  Future<UserInContestRespone> getUserInContest(
      String contestId, int limitUser);
  Future<PostDetailRespone> getPostDetail(String postId, String contestId);
  Future<ListTopPostInContestResponseMessage?> getListTopPostInContest(String contestId, int limitPost);
  Future<GetContestDetailsRespone?> getContestDetailForTransaction(String contestId);
}

class ContestRepository extends ContestBehavior {
  final DataRepository _dataRepository = DataRepository();
  @override
  Future<List<Contest>?> getActiveContestList(String? searchName,
      int limitContest, String? dateUp, String? dateDown) async {
    try {
      final ContestListRespone respone = await _dataRepository
          .getActiveContestList(searchName, limitContest, dateUp, dateDown);

      final List<Contest>? contestList = respone.data;
      return contestList;
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<List<Contest>?> getInactiveContestList(String? searchName,
      int limitContest, String? dateUp, String? dateDown) async {
    try {
      final ContestListRespone respone = await _dataRepository
          .getInactiveContestList(searchName, limitContest, dateUp, dateDown);

      final List<Contest>? inactiveContestList = respone.data;
      return inactiveContestList;
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<List<Contest>?> getMoreActiveContestList(
      String? searchName,
      int limitContest,
      String dateBoundary,
      String? dateUp,
      String? dateDown) async {
    try {
      final ContestListRespone respone =
          await _dataRepository.getMoreActiveContestList(
              searchName, limitContest, dateBoundary, dateUp, dateDown);

      final List<Contest>? inactiveContestList = respone.data;
      return inactiveContestList;
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<List<Contest>?> getMoreInactiveContestList(
      String? searchName,
      int limitContest,
      String dateBoundary,
      String? dateUp,
      String? dateDown) async {
    try {
      final ContestListRespone respone =
          await _dataRepository.getMoreInactiveContestList(
              searchName, limitContest, dateBoundary, dateUp, dateDown);

      final List<Contest>? inactiveContestList = respone.data;
      return inactiveContestList;
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<ContestRespone> getInitContest(String contestId, int limitPost) async {
    ContestRespone respone = ContestRespone();
    try {
      respone = await _dataRepository.getInitContest(contestId, limitPost);
      return respone;
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }

  @override
  Future<ContestPostRespone> getMoreContestPost(
      String contestId, int limitPost, String dateBoundary) async {
    ContestPostRespone respone = ContestPostRespone();
    try {
      respone = await _dataRepository.getMoreContestPost(
          contestId, limitPost, dateBoundary);
      return respone;
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }

  @override
  Future<UserInContestRespone> getMoreSearchUserInContest(String contestId,
      int limitUser, String username, String dateBoundary) async {
    UserInContestRespone respone = UserInContestRespone();
    try {
      respone = await _dataRepository.getMoreSearchUserInContest(
          contestId, limitUser, username, dateBoundary);
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }

  @override
  Future<UserInContestRespone> getMoreUserInContest(
      String contestId, int limitUser, String dateBoundary) async {
    UserInContestRespone respone = UserInContestRespone();
    try {
      respone = await _dataRepository.getMoreUserInContest(
          contestId, limitUser, dateBoundary);
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }

  @override
  Future<UserInContestRespone> getSearchUserInContest(
      String contestId, int limitUser, String username) async {
    UserInContestRespone respone = UserInContestRespone();
    try {
      respone = await _dataRepository.getSearchUserInContest(
          contestId, limitUser, username);
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }

  @override
  Future<UserInContestRespone> getUserInContest(
      String contestId, int limitUser) async {
    UserInContestRespone respone = UserInContestRespone();
    try {
      respone = await _dataRepository.getUserInContest(contestId, limitUser);
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }

  @override
  Future<PostDetailRespone> getPostDetail(
      String postId, String contestId) async {
    PostDetailRespone respone = PostDetailRespone();
    try {
      respone = await _dataRepository.getPostDetail(postId, contestId);
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }

  @override
  Future<ListTopPostInContestResponseMessage?> getListTopPostInContest(String contestId, int limitPost) async {
    try {
      ListTopPostInContestResponseMessage? resMessage =
          await _dataRepository.getListTopPostInContest(contestId, limitPost);
          
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          ListTopPostInContestResponseMessage resMessage =
              ListTopPostInContestResponseMessage.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }

  @override
  Future<GetContestDetailsRespone?> getContestDetailForTransaction(String contestId) async {
    try {
      GetContestDetailsRespone? resMessage =
          await _dataRepository.getContestDetailForTransaction(contestId);
          
      return resMessage;
    } catch (e) {
      if (e is DioError) {
        if (e.response != null) {
          GetContestDetailsRespone resMessage =
              GetContestDetailsRespone.fromJson(e.response!.data);
          return resMessage;
        }
      }
      return null;
    }
  }
}
