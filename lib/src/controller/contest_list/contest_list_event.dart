part of 'contest_list_bloc.dart';

abstract class ContestListEvent extends Equatable {
  const ContestListEvent();

  @override
  List<Object> get props => [];
}

class InitContestFetched extends ContestListEvent {}

class FetchMoreContest extends ContestListEvent {
  final int indexTab;
  final String searchName;
  final String dateUp;
  final String dateDown;

  const FetchMoreContest(this.indexTab, this.searchName,
      this.dateUp, this.dateDown);
}

class InitSearchContestFetched extends ContestListEvent {
  final String searchName;
  final String dateUp;
  final String dateDown;

  const InitSearchContestFetched(this.searchName, this.dateUp, this.dateDown);
}
