part of "profile_bloc.dart";

class ProfileState {
  final UserDetails? user;
  final bool isCurrentUser;
  //final String? avatarPath;

  final ProfileStatus status;
  bool imageSourceActionSheetIsVisible;

  ProfileState({
    this.user,
    required this.isCurrentUser,
    //String? avatarPath,
    this.imageSourceActionSheetIsVisible = false,
    this.status = const InitialStatus(),
  });

  ProfileState copyWith({
    UserDetails? user,
    bool? isCurrentUser,
    //String? avatarPath,
    ProfileStatus? status,
    bool? imageSourceActionSheetIsVisible,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isCurrentUser: this.isCurrentUser,
      //avatarPath: avatarPath ?? this.avatarPath,
      status: status ?? this.status,
      imageSourceActionSheetIsVisible: imageSourceActionSheetIsVisible ??
          this.imageSourceActionSheetIsVisible,
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
