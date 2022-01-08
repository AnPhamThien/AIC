part of 'edit_profile_bloc.dart';

class EditProfileState {
  final UserDetails? user;
  final String? avatarPath;

  final EditProfileStatus status;
  bool avatarChanged;

  EditProfileState({
    this.user,
    this.avatarPath,
    this.avatarChanged = false,
    this.status = const InitialStatus(),
  });

  EditProfileState copyWith({
    UserDetails? user,
    String? avatarPath,
    EditProfileStatus? status,
    bool? avatarChanged,
  }) {
    return EditProfileState(
      user: user ?? this.user,
      avatarPath: avatarPath ?? this.avatarPath,
      status: status ?? this.status,
      avatarChanged: avatarChanged ?? this.avatarChanged,
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

class EditProfileSuccess extends EditProfileStatus {}

class ErrorStatus extends EditProfileStatus {
  final Exception exception;
  ErrorStatus(this.exception);
}
