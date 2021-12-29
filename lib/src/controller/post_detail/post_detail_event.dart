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
