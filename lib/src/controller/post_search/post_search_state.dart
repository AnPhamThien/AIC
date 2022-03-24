part of 'post_search_bloc.dart';

class PostSearchState {
  final List<Post>? searchResultPostList;
  final List<String>? searchResultWordList;
  final String? imgPath;
  final PostSearchStatus status;

  PostSearchState({
    this.searchResultPostList,
    this.searchResultWordList,
    this.imgPath,
    this.status = const InitialStatus(),
  });

  PostSearchState copyWith({
    List<Post>? searchResultPostList,
    List<String>? searchResultWordList,
    String? imgPath,
    PostSearchStatus? status,
  }) {
    return PostSearchState(
      searchResultPostList: searchResultPostList ?? this.searchResultPostList,
      searchResultWordList: searchResultWordList ?? this.searchResultWordList,
      imgPath: imgPath ?? this.imgPath,
      status: status ?? this.status    
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
