part of 'search_bloc.dart';

class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class InitSearchHistoryFetched extends SearchEvent {}

class InitSearchFetched extends SearchEvent {
  final String name;

  const InitSearchFetched(this.name);
}

class FetchMoreSearchHistory extends SearchEvent{}
class FetchMoreSearch extends SearchEvent{}