part of 'contest_list_bloc.dart';

abstract class ContestListEvent extends Equatable {
  const ContestListEvent();

  @override
  List<Object> get props => [];
}

class InitContestFetched extends ContestListEvent {}

class FetchMoreContest extends ContestListEvent {}
