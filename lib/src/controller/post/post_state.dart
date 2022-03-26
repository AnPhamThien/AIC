part of 'post_bloc.dart';

enum PostStatus {
  init,
  like,
  success,
  unlike,
  fail,
  reported,
  deleted,
  save,
  added,
  updated
}

class PostState extends Equatable {
  const PostState(
      {this.status = PostStatus.init,
      this.postId = '',
      this.post,
      this.needUpdate = false,
      this.isSaved = null,
      this.categoryList = const <Category>[], this.postCaption});

  final PostStatus status;
  final String postId;
  final Post? post;
  final bool needUpdate;
  final bool? isSaved;
  final List<Category> categoryList;
  final String? postCaption;

  PostState copyWith({
    PostStatus? status,
    String? postId,
    Post? post,
    bool? needUpdate,
    bool? isSaved,
    List<Category>? categoryList,
    String? postCaption
  }) {
    return PostState(
      status: status ?? this.status,
      postId: postId ?? this.postId,
      post: post ?? this.post,
      needUpdate: needUpdate ?? this.needUpdate,
      isSaved: isSaved ?? this.isSaved,
      categoryList: categoryList ?? this.categoryList,
      postCaption: postCaption ?? this.postCaption
    );
  }

  @override
  List<Object?> get props => [
        status,
        postId,
        needUpdate,
        isSaved,
        categoryList,
      ];
}
