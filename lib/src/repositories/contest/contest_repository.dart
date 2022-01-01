import 'dart:developer';

import '../../model/contest/contest.dart';
import '../../model/contest/contest_list_respone.dart';

import '../data_repository.dart';

abstract class ContestBehavior {
  Future<List<Contest>?> getContest(int limitContest);
  Future<List<Contest>?> getMoreContest(int limitContest);
}

class ContestRepository extends ContestBehavior {
  final DataRepository _dataRepository = DataRepository();
  @override
  Future<List<Contest>?> getContest(int limitContest) async {
    try {
      final ContestListRespone respone =
          await _dataRepository.getContestList("", limitContest, "", "");

      final List<Contest>? contestList = respone.data;
      return contestList;
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Future<List<Contest>?> getMoreContest(int limitContest) {
    // TODO: implement getMoreContest
    throw UnimplementedError();
  }
}
