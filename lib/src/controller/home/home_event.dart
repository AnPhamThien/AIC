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

class PostAdded extends HomeEvent {
  final Post post;

  const PostAdded(this.post);
}

class PostUpdated extends HomeEvent {
  final String postId;
  final String postCaption;

  const PostUpdated(this.postId, this.postCaption);
}

class DeletePost extends HomeEvent{
  final String postId;
  const DeletePost(this.postId);
}

class PostListReset extends HomeEvent{}