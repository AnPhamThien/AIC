part of 'post_search_bloc.dart';

class PostSearchState {
  final List<Post>? searchResultPostList;
  final String? imgPath;
  final PostSearchStatus status;
  final String? searchString;
  final bool hasReachedMax;

  PostSearchState({
    this.searchResultPostList,
    this.imgPath,
    this.status = const InitialStatus(),
    this.searchString,
    this.hasReachedMax = false
  });

  PostSearchState copyWith({
    List<Post>? searchResultPostList,
    String? imgPath,
    PostSearchStatus? status,
    String? searchString,
    bool? hasReachedMax
  }) {
    return PostSearchState(
      searchResultPostList: searchResultPostList ?? this.searchResultPostList,
      imgPath: imgPath ?? this.imgPath,
      status: status ?? this.status,
      searchString: searchString ?? this.searchString,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax
      );
  }
}

abstract class PostSearchStatus {
  const PostSearchStatus();
}

class InitialStatus extends PostSearchStatus {
  const InitialStatus();
}

class FinishInitializing extends PostSearchStatus {}

class ErrorStatus extends PostSearchStatus {
  final Exception exception;
  ErrorStatus(this.exception);
}
