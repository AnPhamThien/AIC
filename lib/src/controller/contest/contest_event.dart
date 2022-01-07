part of 'contest_bloc.dart';

abstract class ContestEvent extends Equatable {
  const ContestEvent();

  @override
  List<Object> get props => [];
}

class InitContestFetched extends ContestEvent {
  final Contest contest;

  const InitContestFetched(this.contest);
}

class MoreContestPostFetched extends ContestEvent {}
