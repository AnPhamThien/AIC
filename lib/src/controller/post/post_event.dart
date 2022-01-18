part of 'post_bloc.dart';

class PostEvent extends Equatable {
  const PostEvent();

  @override
  List<Object> get props => [];
}

class LikePress extends PostEvent {
  final String postId;
  final int isLike;
  const LikePress(this.postId, this.isLike);
}

class Reset extends PostEvent {}

class CheckSavePost extends PostEvent {
  final String postId;
  const CheckSavePost(this.postId);
}
