part of 'post_search_bloc.dart';

class PostSearchState {
  final List<ListTopPostInContestData>? searchResultList;
  final String? imgPath;
  final PostSearchStatus status;

  PostSearchState({
    this.searchResultList,
    this.imgPath,
    this.status = const InitialStatus(),
  });

  PostSearchState copyWith({
    List<ListTopPostInContestData>? searchResultList,
    String? imgPath,
    PostSearchStatus? status,
  }) {
    return PostSearchState(
      searchResultList: searchResultList ?? this.searchResultList,
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
