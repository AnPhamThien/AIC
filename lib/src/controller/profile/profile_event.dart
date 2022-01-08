part of "profile_bloc.dart";

abstract class ProfileEvent {}

class ProfileInitializing extends ProfileEvent {
  final String userID;

  ProfileInitializing(this.userID);
}

class ProfileChangeFollowUser extends ProfileEvent {
  final String followeeID;

  ProfileChangeFollowUser(this.followeeID);
}
