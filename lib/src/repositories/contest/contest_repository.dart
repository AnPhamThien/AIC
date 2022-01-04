import 'dart:developer';

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
}
