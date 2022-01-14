part of 'contest_user_bloc.dart';

abstract class ContestUserEvent extends Equatable {
  const ContestUserEvent();

  @override
  List<Object> get props => [];
}

class InitContestUserFetched extends ContestUserEvent {
  final String contestId;

  const InitContestUserFetched(this.contestId);
}

class SearchContestUserFetched extends ContestUserEvent {
  final String searchName;

  const SearchContestUserFetched(this.searchName);
}

class FetchMoreContestUser extends ContestUserEvent {}

class FetchMoreSearchContestUser extends ContestUserEvent {}

class PostFromUserFetched extends ContestUserEvent {
  final String postId;

  const PostFromUserFetched(this.postId);
}

class NavigatedToPost extends ContestUserEvent {}
