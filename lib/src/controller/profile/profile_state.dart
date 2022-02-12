part of "profile_bloc.dart";

class ProfileState {
  final UserDetails? user;
  final List<Post>? savedPostList;
  final bool isCurrentUser;
  final ProfileStatus status;
  bool isFollow;

  ProfileState({
    this.user,
    this.savedPostList,
    required this.isCurrentUser,
    this.isFollow = false,
    this.status = const InitialStatus(),
  });

  ProfileState copyWith({
    UserDetails? user,
    List<Post>? savedPostList,
    bool? isCurrentUser,
    ProfileStatus? status,
    bool? isFollow,
  }) {
    return ProfileState(
      user: user ?? this.user,
      savedPostList: savedPostList ?? this.savedPostList,
      isCurrentUser: this.isCurrentUser,
      status: status ?? this.status,
      isFollow: isFollow ?? this.isFollow,
    );
  }
}

abstract class ProfileStatus {
  const ProfileStatus();
}

class InitialStatus extends ProfileStatus {
  const InitialStatus();
}

class FinishInitializing extends ProfileStatus {}

class ReachedMaxedStatus extends ProfileStatus {}

class ErrorStatus extends ProfileStatus {
  final Exception exception;
  ErrorStatus(this.exception);
}
