import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
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

const _paging = 10;

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
  }

  final SearchRepository _searchRepository = SearchRepository();

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
    try {} catch (_) {
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
        } else if (_respone.messageCode == 'HS114') {
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
    try {} catch (_) {
      emit(state.copyWith(status: SearchStatus.failure));
    }
  }
}
