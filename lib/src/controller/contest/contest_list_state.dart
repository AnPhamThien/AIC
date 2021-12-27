part of 'contest_list_bloc.dart';

enum ContestListStatus { initial, success, failure, maxcontest }

class ContestListState extends Equatable {
  const ContestListState({
    this.status = ContestListStatus.initial,
    this.contestsList = const <Contest>[],
    this.hasReachedMax = false,
  });

  final ContestListStatus status;
  final List<Contest> contestsList;
  final bool hasReachedMax;

  ContestListState copyWith({
    ContestListStatus? status,
    List<Contest>? contestsList,
    bool? hasReachedMax,
  }) {
    return ContestListState(
      status: status ?? this.status,
      contestsList: contestsList ?? this.contestsList,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  String toString() {
    return '''PostState { status: $status, hasReachedMax: $hasReachedMax, posts: ${contestsList.length} }''';
  }

  @override
  List<Object> get props => [status, contestsList, hasReachedMax];
}
