part of 'post_detail_bloc.dart';

enum PostDetailStatus { initial, success, failure, maxcomment }

class PostDetailState extends Equatable {
  const PostDetailState({
    this.status = PostDetailStatus.initial,
    this.post,
    this.hasReachMax = false,
  });

  final PostDetailStatus status;
  final Post? post;
  final bool hasReachMax;

  PostDetailState copyWith(
      {PostDetailStatus? status, Post? post, bool? hasReachMax}) {
    return PostDetailState(
      status: status ?? this.status,
      post: post ?? this.post,
      hasReachMax: hasReachMax ?? this.hasReachMax,
    );
  }

  @override
  List<Object> get props => [];
}
