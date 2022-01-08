part of 'search_bloc.dart';

enum SearchStatus { initial, success, failure }

class SearchState extends Equatable {
  const SearchState({
    this.status = SearchStatus.initial,
    this.searchHistoryList = const <SearchHistoryData>[],
    this.searchList = const <SearchData>[],
    this.hasReachMaxHistoryList = false,
    this.hasReachMaxSearchList = false,
    this.searchName = '',
  });

  final SearchStatus status;
  final List<SearchHistoryData> searchHistoryList;
  final List<SearchData> searchList;
  final bool hasReachMaxHistoryList;
  final bool hasReachMaxSearchList;
  final String searchName;

  SearchState copyWith(
      {SearchStatus? status,
      List<SearchHistoryData>? searchHistoryList,
      List<SearchData>? searchList,
      bool? hasReachMaxHistoryList,
      bool? hasReachMaxSearchList,
      String? searchName}) {
    return SearchState(
      status: status ?? this.status,
      searchHistoryList: searchHistoryList ?? this.searchHistoryList,
      searchList: searchList ?? this.searchList,
      hasReachMaxHistoryList:
          hasReachMaxHistoryList ?? this.hasReachMaxHistoryList,
      hasReachMaxSearchList:
          hasReachMaxSearchList ?? this.hasReachMaxSearchList,
      searchName: searchName ?? this.searchName,
    );
  }

  @override
  List<Object> get props => [
        status,
        searchHistoryList,
        searchList,
        hasReachMaxHistoryList,
        hasReachMaxSearchList,
        searchName,
      ];
}
