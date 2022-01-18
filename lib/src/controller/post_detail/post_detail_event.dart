part of 'post_detail_bloc.dart';

class PostDetailEvent extends Equatable {
  const PostDetailEvent();

  @override
  List<Object> get props => [];
}

class PostDetailInitEvent extends PostDetailEvent {
  final Post post;

  const PostDetailInitEvent(this.post);
}

class PostDetailFetchMoreComment extends PostDetailEvent {}

class PostDetailAddComment extends PostDetailEvent {
  final String comment;

  const PostDetailAddComment(this.comment);
}

class PostDetailDeleteComment extends PostDetailEvent {
  final String commentId;
  final int index;
  const PostDetailDeleteComment(this.commentId, this.index);
}

class CommentDeleted extends PostDetailEvent {}
