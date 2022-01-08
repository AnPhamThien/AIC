import 'dart:developer';

import 'package:imagecaptioning/src/model/search/search_history_respone.dart';
import 'package:imagecaptioning/src/model/search/search_respone.dart';

import '../data_repository.dart';

abstract class SearchBehavior {
  Future<SearchHistoryRespone> getSearchHistory(int limit);
  Future<SearchHistoryRespone> getMoreSearchHistory(
      int limit, String dateBoundary);
  Future<SearchRespone> searchUser(int limitUser, String name);
  Future<SearchRespone> moreSearchUser(
      String dateBoundary, int limitUser, String name);
}

class SearchRepository extends SearchBehavior {
  final DataRepository _dataRepository = DataRepository();
  @override
  Future<SearchHistoryRespone> getSearchHistory(int limit) async {
    SearchHistoryRespone respone = SearchHistoryRespone();
    try {
      respone = await _dataRepository.getSearchHistory(limit);

      return respone;
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }

  @override
  Future<SearchHistoryRespone> getMoreSearchHistory(
      int limit, String dateBoundary) async {
    SearchHistoryRespone respone = SearchHistoryRespone();
    try {
      respone = await _dataRepository.getMoreSearchHistory(limit, dateBoundary);

      return respone;
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }

  @override
  Future<SearchRespone> moreSearchUser(
      String dateBoundary, int limitUser, String name) async {
    SearchRespone respone = SearchRespone();
    try {
      respone =
          await _dataRepository.moreSearchUser(dateBoundary, limitUser, name);
      return respone;
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }

  @override
  Future<SearchRespone> searchUser(int limitUser, String name) async {
    SearchRespone respone = SearchRespone();
    try {
      respone = await _dataRepository.searchUser(limitUser, name);
      return respone;
    } catch (e) {
      log(e.toString());
    }
    return respone;
  }
}
