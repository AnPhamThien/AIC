part of 'post_detail_bloc.dart';

class PostDetailEvent extends Equatable {
  const PostDetailEvent();

  @override
  List<Object> get props => [];
}

class PostInitEvent extends PostDetailEvent {
  final Post post;

  const PostInitEvent(this.post);
}
