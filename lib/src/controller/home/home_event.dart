part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

class InitPostFetched extends HomeEvent {}

class FetchMorePost extends HomeEvent {}

class PostDeleted extends HomeEvent {
  final String postId;

  const PostDeleted(this.postId);
}
