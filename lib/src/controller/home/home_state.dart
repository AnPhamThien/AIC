part of 'home_bloc.dart';

enum HomeStatus { initial, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.postsList = const <Post>[],
    this.hasReachedMax = false,
  });

  final HomeStatus status;
  final List<Post> postsList;
  final bool hasReachedMax;

  HomeState copyWith(
      {HomeStatus? status, List<Post>? postsList, bool? hasReachedMax}) {
    return HomeState(
        status: status ?? this.status,
        postsList: postsList ?? this.postsList,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${postsList.length} }''';
  }

  @override
  List<Object> get props => [status, postsList, hasReachedMax];
}
