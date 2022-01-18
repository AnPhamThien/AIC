part of 'post_detail_bloc.dart';

enum PostDetailStatus {
  initial,
  success,
  failure,
  maxcomment,
  deleted,
}

class PostDetailState extends Equatable {
  const PostDetailState({
    this.status = PostDetailStatus.initial,
    this.post,
    this.commentList = const <Comment>[],
    this.commentCount,
    this.hasReachMax = false,
    this.deleted,
  });

  final PostDetailStatus status;
  final Post? post;
  final List<Comment> commentList;
  final int? commentCount;
  final bool hasReachMax;
  final int? deleted;

  PostDetailState copyWith({
    PostDetailStatus? status,
    Post? post,
    List<Comment>? commentList,
    int? commentCount,
    bool? hasReachMax,
    int? deleted,
  }) {
    return PostDetailState(
        status: status ?? this.status,
        post: post ?? this.post,
        commentList: commentList ?? this.commentList,
        commentCount: commentCount ?? this.commentCount,
        hasReachMax: hasReachMax ?? this.hasReachMax,
        deleted: deleted ?? this.deleted);
  }

  @override
  List<Object?> get props =>
      [status, post, commentCount, commentList, hasReachMax, deleted];
}
