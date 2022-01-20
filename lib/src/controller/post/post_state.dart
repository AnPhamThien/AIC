part of 'post_bloc.dart';

enum PostStatus { init, like, success, unlike, fail, reported, deleted }

class PostState extends Equatable {
  const PostState(
      {this.status = PostStatus.init,
      this.postId = '',
      this.needUpdate = false,
      this.isSaved = false,
      this.categoryList = const <Category>[]});

  final PostStatus status;
  final String postId;
  final bool needUpdate;
  final bool isSaved;
  final List<Category> categoryList;

  PostState copyWith({
    PostStatus? status,
    String? postId,
    bool? needUpdate,
    bool? isSaved,
    List<Category>? categoryList,
  }) {
    return PostState(
      status: status ?? this.status,
      postId: postId ?? this.postId,
      needUpdate: needUpdate ?? this.needUpdate,
      isSaved: isSaved ?? this.isSaved,
      categoryList: categoryList ?? this.categoryList,
    );
  }

  @override
  List<Object> get props => [
        status,
        postId,
        needUpdate,
        isSaved,
        categoryList,
      ];
}
