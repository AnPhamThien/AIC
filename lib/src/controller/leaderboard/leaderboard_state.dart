part of 'leaderboard_bloc.dart';

class LeaderboardState {
  final List<ListTopPostInContestData>? topPostInContestList;

  final LeaderboardStatus status;

  LeaderboardState({
    this.topPostInContestList,
    this.status = const InitialStatus(),
  });

  LeaderboardState copyWith({
    List<ListTopPostInContestData>? topPostInContestList,
    LeaderboardStatus? status,
  }) {
    return LeaderboardState(
      topPostInContestList: topPostInContestList ?? this.topPostInContestList,
      status: status ?? this.status    );
  }
}

abstract class LeaderboardStatus {
  const LeaderboardStatus();
}

class InitialStatus extends LeaderboardStatus {
  const InitialStatus();
}

class FinishInitializing extends LeaderboardStatus {}

class ErrorStatus extends LeaderboardStatus {
  final Exception exception;
  ErrorStatus(this.exception);
}
