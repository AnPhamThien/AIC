part of "profile_bloc.dart";

abstract class ProfileEvent {}

class ProfileInitializing extends ProfileEvent {
  final String userID;

  ProfileInitializing(this.userID);
}

class ProfileFetchMorePost extends ProfileEvent {}

class ProfileFetchMoreSavedPost extends ProfileEvent {}

class ProfileChangeFollowUser extends ProfileEvent {
  final String followeeID;

  ProfileChangeFollowUser(this.followeeID);
}
