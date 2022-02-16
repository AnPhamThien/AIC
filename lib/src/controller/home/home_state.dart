part of 'home_bloc.dart';

enum HomeStatus { initial, success, failure, like, unlike }

class HomeState extends Equatable {
  const HomeState({
    this.status = HomeStatus.initial,
    this.postsList = const <Post>[],
    this.hasReachedMax = false,
    this.categoryList = const <Category>[],
    this.deletedPostId = '',
  });

  final HomeStatus status;
  final List<Post> postsList;
  final bool hasReachedMax;
  final String deletedPostId;
  final List<Category> categoryList;

  HomeState copyWith({
    HomeStatus? status,
    List<Post>? postsList,
    bool? hasReachedMax,
    String? deletedPostId,
    List<Category>? categoryList,
  }) {
    return HomeState(
      status: status ?? this.status,
      postsList: postsList ?? this.postsList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      deletedPostId: deletedPostId ?? this.deletedPostId,
      categoryList: categoryList ?? this.categoryList,
    );
  }

  @override
  List<Object> get props =>
      [status, postsList, hasReachedMax, deletedPostId, categoryList];
}
