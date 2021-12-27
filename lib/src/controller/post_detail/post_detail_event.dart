part of 'post_detail_bloc.dart';

class PostDetailEvent extends Equatable {
  const PostDetailEvent();

  @override
  List<Object> get props => [];
}

class PostInitEvent extends PostDetailEvent {
  final String postId;

  const PostInitEvent(this.postId);
}
