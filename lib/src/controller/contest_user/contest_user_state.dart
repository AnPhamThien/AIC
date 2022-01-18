part of 'contest_user_bloc.dart';

enum ContestUserStatus { initial, success, failure, postfetched }

class ContestUserState extends Equatable {
  const ContestUserState({
    this.status = ContestUserStatus.initial,
    this.userInContest = const <UserInContestData>[],
    this.searchUserInContest = const <UserInContestData>[],
    this.hasReachMaxUser = false,
    this.hasReachMaxSearch = false,
    this.post,
    this.searchName = '',
  });

  final ContestUserStatus status;
  final List<UserInContestData> userInContest;
  final List<UserInContestData> searchUserInContest;
  final bool hasReachMaxUser;
  final bool hasReachMaxSearch;
  final Post? post;
  final String searchName;

  ContestUserState copyWith(
      {ContestUserStatus? status,
      List<UserInContestData>? userInContest,
      List<UserInContestData>? searchUserInContest,
      bool? hasReachMaxUser,
      bool? hasReachMaxSearch,
      Post? post,
      String? searchName}) {
    return ContestUserState(
        status: status ?? this.status,
        userInContest: userInContest ?? this.userInContest,
        searchUserInContest: searchUserInContest ?? this.searchUserInContest,
        hasReachMaxUser: hasReachMaxUser ?? this.hasReachMaxUser,
        hasReachMaxSearch: hasReachMaxSearch ?? this.hasReachMaxSearch,
        post: post ?? this.post,
        searchName: searchName ?? this.searchName);
  }

  @override
  List<Object?> get props => [
        status,
        userInContest,
        searchUserInContest,
        hasReachMaxUser,
        hasReachMaxSearch,
        post,
        searchName
      ];
}
