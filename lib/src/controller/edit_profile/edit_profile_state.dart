part of 'edit_profile_bloc.dart';

class EditProfileState {
  final UserDetails? user;
  final String? avatarPath;

  final EditProfileStatus status;
  bool imageSourceActionSheetIsVisible;

  EditProfileState({
    this.user,
    this.avatarPath,
    this.imageSourceActionSheetIsVisible = false,
    this.status = const InitialStatus(),
  });

  EditProfileState copyWith({
    UserDetails? user,
    String? avatarPath,
    EditProfileStatus? status,
    bool? imageSourceActionSheetIsVisible,
  }) {
    return EditProfileState(
      user: user ?? this.user,
      avatarPath: avatarPath ?? this.avatarPath,
      status: status ?? this.status,
      imageSourceActionSheetIsVisible: imageSourceActionSheetIsVisible ??
          this.imageSourceActionSheetIsVisible,
    );
  }
}

abstract class EditProfileStatus {
  const EditProfileStatus();
}

class InitialStatus extends EditProfileStatus {
  const InitialStatus();
}

class FinishInitializing extends EditProfileStatus {}

class ReachedMaxedStatus extends EditProfileStatus {}

class ErrorStatus extends EditProfileStatus {
  final Exception exception;
  ErrorStatus(this.exception);
}
