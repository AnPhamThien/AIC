part of 'contest_user_bloc.dart';

enum ContestUserStatus { initial, success, failure, postfetched }

class ContestUserState extends Equatable {
  const ContestUserState({
    this.status = ContestUserStatus.initial,
    this.userInContest = const <UserInContestData>[],
    this.searchUserInContest = const <UserInContestData>[],
    this.hasReachMax = false,
    this.post,
    this.searchName = '',
  });

  final ContestUserStatus status;
  final List<UserInContestData> userInContest;
  final List<UserInContestData> searchUserInContest;
  final bool hasReachMax;
  final Post? post;
  final String searchName;

  ContestUserState copyWith(
      {ContestUserStatus? status,
      List<UserInContestData>? userInContest,
      List<UserInContestData>? searchUserInContest,
      bool? hasReachMax,
      Post? post,
      String? searchName}) {
    return ContestUserState(
        status: status ?? this.status,
        userInContest: userInContest ?? this.userInContest,
        searchUserInContest: searchUserInContest ?? this.searchUserInContest,
        hasReachMax: hasReachMax ?? this.hasReachMax,
        post: post ?? this.post,
        searchName: searchName ?? this.searchName);
  }

  @override
  List<Object?> get props => [
        status,
        userInContest,
        searchUserInContest,
        hasReachMax,
        post,
        searchName
      ];
}
