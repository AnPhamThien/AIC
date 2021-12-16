part of "profile_bloc.dart";

class ProfileState {
  final UserDetails? user;
  final bool? isCurrentUser;
  //final String? avatarPath;

  final FormSubmissionStatus formStatus;
  bool imageSourceActionSheetIsVisible;

  ProfileState({
    this.user,
    this.isCurrentUser,
    //String? avatarPath,
    this.imageSourceActionSheetIsVisible = false,
    this.formStatus = const InitialFormStatus(),
  });

  ProfileState copyWith({
    UserDetails? user,
    bool? isCurrentUser,
    //String? avatarPath,
    FormSubmissionStatus? formStatus,
    bool? imageSourceActionSheetIsVisible,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isCurrentUser: this.isCurrentUser,
      //avatarPath: avatarPath ?? this.avatarPath,
      formStatus: formStatus ?? this.formStatus,
      imageSourceActionSheetIsVisible: imageSourceActionSheetIsVisible ??
          this.imageSourceActionSheetIsVisible,
    );
  }
}
