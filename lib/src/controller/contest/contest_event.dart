part of 'contest_bloc.dart';

abstract class ContestEvent extends Equatable {
  const ContestEvent();

  @override
  List<Object> get props => [];
}

class InitContestFetched extends ContestEvent {
  final Contest? contest;
  final String? contestId;

  const InitContestFetched(this.contest, this.contestId);
}

class MoreContestPostFetched extends ContestEvent {}
