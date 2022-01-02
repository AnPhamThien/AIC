import 'dart:developer';

import '../../model/contest/contest.dart';
import '../../model/contest/contest_list_respone.dart';

import '../data_repository.dart';

abstract class ContestBehavior {
  Future<List<Contest>?> getActiveContestList(int limitContest);
  Future<List<Contest>?> getInactiveContestList(int limitContest);
  Future<List<Contest>?> getMoreActiveContestList(
      int limitContest, String dateBoundary);
  Future<List<Contest>?> getMoreInactiveContestList(
      int limitContest, String dateBoundary);
}

class ContestRepository extends ContestBehavior {
  final DataRepository _dataRepository = DataRepository();
  @override
  Future<List<Contest>?> getActiveContestList(int limitContest) async {
    try {
      final ContestListRespone respone =
          await _dataRepository.getActiveContestList("", limitContest, "", "");

      final List<Contest>? contestList = respone.data;
      return contestList;
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<List<Contest>?> getInactiveContestList(int limitContest) async {
    try {
      final ContestListRespone respone = await _dataRepository
          .getInactiveContestList("", limitContest, "", "");

      final List<Contest>? inactiveContestList = respone.data;
      return inactiveContestList;
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<List<Contest>?> getMoreActiveContestList(
      int limitContest, String dateBoundary) async {
    try {
      final ContestListRespone respone = await _dataRepository
          .getMoreActiveContestList("", limitContest, dateBoundary, "", "");

      final List<Contest>? inactiveContestList = respone.data;
      return inactiveContestList;
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<List<Contest>?> getMoreInactiveContestList(
      int limitContest, String dateBoundary) async {
    try {
      final ContestListRespone respone = await _dataRepository
          .getMoreInactiveContestList("", limitContest, dateBoundary, "", "");

      final List<Contest>? inactiveContestList = respone.data;
      return inactiveContestList;
    } catch (e) {
      log(e.toString());
    }
  }
}
