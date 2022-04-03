part of 'post_search_bloc.dart';

abstract class PostSearchEvent {}

class PostSearch extends PostSearchEvent {
  final String searchString;
  PostSearch(this.searchString);
}