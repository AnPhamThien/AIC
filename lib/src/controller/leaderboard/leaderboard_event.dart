part of 'leaderboard_bloc.dart';

abstract class LeaderboardEvent {}

class LeaderboardInitializing extends LeaderboardEvent {
  final String contestId;
  LeaderboardInitializing(this.contestId);
}