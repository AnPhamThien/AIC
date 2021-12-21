part of 'home_bloc.dart';

enum HomeStatus { initial, success, failure }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.posts = const <Post>[],
    this.hasReachedMax = false,
  });

  final HomeStatus status;
  final List<Post> posts;
  final bool hasReachedMax;

  HomeState copyWith({
    HomeStatus? status,
    List<Post>? posts,
    bool? hasReachedMax,
  }) {
    return HomeState(
      status: status ?? this.status,
      posts: posts ?? this.posts,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${posts.length} }''';
  }

  @override
  List<Object> get props => [status, posts, hasReachedMax];
}
