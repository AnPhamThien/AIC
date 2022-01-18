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

class FetchMoreSearchHistory extends SearchEvent {}

class FetchMoreSearch extends SearchEvent {}

class DeleteSearchHistory extends SearchEvent {
  final SearchHistoryData user;

  const DeleteSearchHistory(this.user);
}

class AddSearchHistory extends SearchEvent {
  final String userId;

  const AddSearchHistory(this.userId);
}
