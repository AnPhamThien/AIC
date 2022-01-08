part of 'edit_profile_bloc.dart';

abstract class EditProfileEvent {}

class EditProfileInitializing extends EditProfileEvent {
  EditProfileInitializing();
}

class ChangeAvatar extends EditProfileEvent {
  final String avatarPath;

  ChangeAvatar(this.avatarPath);
}

class SaveProfileChanges extends EditProfileEvent {
  final String username;
  final String desc;
  final String email;
  final String phone;
  final String userRealName;
  final String avatar;

  SaveProfileChanges(
      {required this.username,
      required this.desc,
      required this.email,
      required this.phone,
      required this.userRealName,
      required this.avatar});
}
