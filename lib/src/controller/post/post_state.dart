part of 'post_bloc.dart';

enum PostStatus { init, like, unlike, fail }

class PostState extends Equatable {
  const PostState(
      {this.status = PostStatus.init,
      this.postId = '',
      this.needUpdate = false,
      this.isSaved = false});

  final PostStatus status;
  final String postId;
  final bool needUpdate;
  final bool isSaved;

  PostState copyWith({
    PostStatus? status,
    String? postId,
    bool? needUpdate,
    bool? isSaved,
  }) {
    return PostState(
      status: status ?? this.status,
      postId: postId ?? this.postId,
      needUpdate: needUpdate ?? this.needUpdate,
      isSaved: isSaved ?? this.isSaved,
    );
  }

  @override
  List<Object> get props => [
        status,
        postId,
        needUpdate,
        isSaved,
      ];
}
