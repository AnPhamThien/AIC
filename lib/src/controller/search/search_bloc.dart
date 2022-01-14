import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:imagecaptioning/src/constant/error_message.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/model/generic/generic.dart';
import 'package:imagecaptioning/src/model/search/search_data.dart';
import 'package:imagecaptioning/src/model/search/search_history_data.dart';
import 'package:imagecaptioning/src/model/search/search_history_respone.dart';
import 'package:imagecaptioning/src/model/search/search_respone.dart';
import 'package:imagecaptioning/src/repositories/search/search_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'search_event.dart';
part 'search_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

const _paging = 2;

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState()) {
    on<InitSearchHistoryFetched>(
      _initSearchHistoryFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<FetchMoreSearchHistory>(
      _fetchMoreSearchHistory,
      transformer: throttleDroppable(throttleDuration),
    );
    on<InitSearchFetched>(
      _initSearchFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<FetchMoreSearch>(
      _fetchMoreSearch,
      transformer: throttleDroppable(throttleDuration),
    );
    on<AddSearchHistory>(
      _addSearchHistory,
      transformer: throttleDroppable(throttleDuration),
    );
    on<DeleteSearchHistory>(
      _deleteSearchHistory,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final SearchRepository _searchRepository = SearchRepository();

  void _addSearchHistory(
    AddSearchHistory event,
    Emitter<SearchState> emit,
  ) async {
    try {
      String _userId = event.userId;
      final GetResponseMessage _respone =
          await _searchRepository.addSearchHistory(_userId);
      if (_respone.statusCode == StatusCode.successStatus) {
        add(InitSearchHistoryFetched());
      } else {
        throw Exception(_respone.statusCode);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void _deleteSearchHistory(
    DeleteSearchHistory event,
    Emitter<SearchState> emit,
  ) async {
    try {
      String _userId = event.user.userId!;
      final GetResponseMessage _respone =
          await _searchRepository.deleteSearchHistory(_userId);
      if (_respone.statusCode == StatusCode.successStatus) {
        add(InitSearchHistoryFetched());
      } else {
        throw Exception(_respone.statusCode);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void _initSearchHistoryFetched(
      InitSearchHistoryFetched event, Emitter<SearchState> emit) async {
    try {
      final SearchHistoryRespone _respone =
          await _searchRepository.getSearchHistory(_paging);
      final List<SearchHistoryData>? _data = _respone.data;
      if (_respone.statusCode == StatusCode.successStatus && _data != null) {
        emit(state.copyWith(
            status: SearchStatus.success,
            hasReachMaxHistoryList: false,
            searchHistoryList: _data));
      } else if (_respone.statusCode == StatusCode.failStatus &&
          _respone.messageCode == "HS114") {
        emit(state.copyWith(
            status: SearchStatus.success,
            hasReachMaxHistoryList: false,
            searchHistoryList: []));
      }
    } catch (_) {
      emit(state.copyWith(status: SearchStatus.failure));
    }
  }

  void _fetchMoreSearchHistory(
      FetchMoreSearchHistory event, Emitter<SearchState> emit) async {
    try {
      if (state.hasReachMaxHistoryList == true) {
        return;
      }
      final _dateBoundary = state.searchHistoryList.last.dateSearch.toString();
      final SearchHistoryRespone _respone =
          await _searchRepository.getMoreSearchHistory(_paging, _dateBoundary);
      final List<SearchHistoryData>? _moreSearchHistory = _respone.data;
      if (_respone.statusCode == StatusCode.failStatus &&
          _respone.messageCode == MessageCode.noSearchHistoryToDisplay) {
        emit(state.copyWith(hasReachMaxHistoryList: true));
      } else if (_respone.statusCode == StatusCode.successStatus &&
          _moreSearchHistory != null) {
        emit(state.copyWith(
            status: SearchStatus.success,
            searchHistoryList: [
              ...state.searchHistoryList,
              ..._moreSearchHistory
            ],
            hasReachMaxHistoryList: false));
      } else {
        throw Exception(_respone.messageCode);
      }
    } catch (_) {
      emit(state.copyWith(status: SearchStatus.failure));
    }
  }

  void _initSearchFetched(
      InitSearchFetched event, Emitter<SearchState> emit) async {
    try {
      final _searchName = event.name;
      if (_searchName == '') {
        emit(state.copyWith(status: SearchStatus.success, searchList: []));
      } else {
        final SearchRespone _respone =
            await _searchRepository.searchUser(_paging, _searchName);
        final List<SearchData>? _searchedUser = _respone.data;
        if (_respone.statusCode == StatusCode.successStatus &&
            _searchedUser != null) {
          emit(state.copyWith(
              status: SearchStatus.success,
              searchList: _searchedUser,
              searchName: _searchName,
              hasReachMaxSearchList: false));
        } else if (_respone.messageCode ==
            MessageCode.noSearchHistoryToDisplay) {
          emit(state.copyWith(status: SearchStatus.success, searchList: []));
        } else {
          throw Exception(_respone.messageCode);
        }
      }
    } catch (_) {
      emit(state.copyWith(status: SearchStatus.failure));
    }
  }

  void _fetchMoreSearch(
      FetchMoreSearch event, Emitter<SearchState> emit) async {
    try {
      if (state.hasReachMaxSearchList == true) {
        return;
      }
      final _dateBoundary = state.searchList.last.dateCreate.toString();
      final _searchName = state.searchName;
      final SearchRespone _respone = await _searchRepository.moreSearchUser(
          _dateBoundary, _paging, _searchName);
      final List<SearchData>? _moreSearch = _respone.data;
      if (_respone.statusCode == StatusCode.failStatus &&
          _respone.messageCode == MessageCode.userNotFound) {
        emit(state.copyWith(hasReachMaxSearchList: true));
      } else if (_respone.statusCode == StatusCode.successStatus &&
          _moreSearch != null) {
        emit(state.copyWith(
            status: SearchStatus.success,
            searchList: [...state.searchList, ..._moreSearch],
            hasReachMaxSearchList: false));
      } else {
        throw Exception(_respone.messageCode);
      }
    } catch (_) {
      emit(state.copyWith(status: SearchStatus.failure));
    }
  }
}
