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
      this.isSaved,
      this.categoryList = const <Category>[], 
      this.postCaption,
      this.error});

  final PostStatus status;
  final String postId;
  final Post? post;
  final bool needUpdate;
  final bool? isSaved;
  final List<Category> categoryList;
  final String? postCaption;
  final String? error;

  PostState copyWith({
    PostStatus? status,
    String? postId,
    Post? post,
    bool? needUpdate,
    bool? isSaved,
    List<Category>? categoryList,
    String? postCaption,
    String? error
  }) {
    return PostState(
      status: status ?? this.status,
      postId: postId ?? this.postId,
      post: post ?? this.post,
      needUpdate: needUpdate ?? this.needUpdate,
      isSaved: isSaved ?? this.isSaved,
      categoryList: categoryList ?? this.categoryList,
      postCaption: postCaption ?? this.postCaption,
      error: error ?? this.error
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
