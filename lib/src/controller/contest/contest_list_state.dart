part of 'contest_list_bloc.dart';

enum ContestListStatus {
  initial,
  success,
  failure,
}

class ContestListState extends Equatable {
  const ContestListState({
    this.status = ContestListStatus.initial,
    this.activeContestList = const <Contest>[],
    this.inactiveContestList = const <Contest>[],
    this.searchContestList = const <Contest>[],
    this.hasReachMaxActive = false,
    this.hasReachMaxInactive = false,
  });

  final ContestListStatus status;
  final List<Contest> activeContestList;
  final List<Contest> inactiveContestList;
  final List<Contest> searchContestList;
  final bool hasReachMaxActive;
  final bool hasReachMaxInactive;

  ContestListState copyWith({
    ContestListStatus? status,
    List<Contest>? activeContestList,
    List<Contest>? inactiveContestList,
    List<Contest>? searchContestList,
    bool? hasReachMaxActive,
    bool? hasReachMaxInactive,
  }) {
    return ContestListState(
      status: status ?? this.status,
      activeContestList: activeContestList ?? this.activeContestList,
      inactiveContestList: inactiveContestList ?? this.inactiveContestList,
      searchContestList: searchContestList ?? this.searchContestList,
      hasReachMaxActive: hasReachMaxActive ?? this.hasReachMaxActive,
      hasReachMaxInactive: hasReachMaxInactive ?? this.hasReachMaxInactive,
    );
  }

  @override
  List<Object> get props => [
        status,
        activeContestList,
        inactiveContestList,
        searchContestList,
        hasReachMaxActive,
        hasReachMaxInactive,
      ];
}
