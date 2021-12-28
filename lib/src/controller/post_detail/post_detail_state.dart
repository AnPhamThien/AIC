part of 'post_detail_bloc.dart';

enum PostDetailStatus { initial, success, failure, maxcomment }

class PostDetailState extends Equatable {
  const PostDetailState({
    this.status = PostDetailStatus.initial,
    this.post,
    this.commentList = const <Comment>[],
    this.commentCount,
    this.hasReachMax = false,
  });

  final PostDetailStatus status;
  final Post? post;
  final List<Comment>? commentList;
  final int? commentCount;
  final bool hasReachMax;

  PostDetailState copyWith({
    PostDetailStatus? status,
    Post? post,
    List<Comment>? commentList,
    int? commentCount,
    bool? hasReachMax,
  }) {
    return PostDetailState(
      status: status ?? this.status,
      post: post ?? this.post,
      commentList: commentList ?? this.commentList,
      commentCount: commentCount ?? this.commentCount,
      hasReachMax: hasReachMax ?? this.hasReachMax,
    );
  }

  @override
  List<Object> get props => [];
}
