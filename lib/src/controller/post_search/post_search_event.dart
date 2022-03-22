part of 'post_search_bloc.dart';

abstract class PostSearchEvent {}

class PostSearchInitializing extends PostSearchEvent {
  final String imgPath;
  PostSearchInitializing(this.imgPath);
}