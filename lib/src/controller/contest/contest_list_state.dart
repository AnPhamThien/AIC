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
    this.onGoingContestList = const <Contest>[],
    this.closedContestList = const <Contest>[],
    this.searchContestList = const <Contest>[],
    this.hasReachedMax = false,
  });

  final ContestListStatus status;
  final List<Contest> onGoingContestList;
  final List<Contest> closedContestList;
  final List<Contest> searchContestList;
  final bool hasReachedMax;

  ContestListState copyWith({
    ContestListStatus? status,
    List<Contest>? onGoingContestList,
    bool? hasReachedMax,
  }) {
    return ContestListState(
      status: status ?? this.status,
      onGoingContestList: onGoingContestList ?? this.onGoingContestList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${onGoingContestList.length} }''';
  }

  @override
  List<Object> get props => [status, onGoingContestList, hasReachedMax];
}
