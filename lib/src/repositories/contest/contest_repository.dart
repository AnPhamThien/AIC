import 'dart:developer';

import 'package:imagecaptioning/src/model/contest/contest_respone.dart';

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
}
