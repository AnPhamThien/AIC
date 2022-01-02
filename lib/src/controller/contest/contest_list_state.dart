part of 'contest_list_bloc.dart';

enum ContestListStatus {
  initial,
  success,
  failure,
  maxongoingcontest,
  maxclosedcontest,
  maxsearchcontest
}

class ContestListState extends Equatable {
  const ContestListState({
    this.status = ContestListStatus.initial,
    this.activeContestList = const <Contest>[],
    this.inactiveContestList = const <Contest>[],
    this.searchContestList = const <Contest>[],
  });

  final ContestListStatus status;
  final List<Contest> activeContestList;
  final List<Contest> inactiveContestList;
  final List<Contest> searchContestList;

  ContestListState copyWith({
    ContestListStatus? status,
    List<Contest>? activeContestList,
    List<Contest>? inactiveContestList,
    List<Contest>? searchContestList,
    bool? hasReachedMax,
  }) {
    return ContestListState(
      status: status ?? this.status,
      activeContestList: activeContestList ?? this.activeContestList,
      inactiveContestList: inactiveContestList ?? this.inactiveContestList,
      searchContestList: searchContestList ?? this.searchContestList,
    );
  }

  @override
  List<Object> get props => [
        status,
        activeContestList,
        inactiveContestList,
        searchContestList,
      ];
}
