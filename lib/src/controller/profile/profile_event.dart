part of "profile_bloc.dart";

abstract class ProfileEvent {}

class Initializing extends ProfileEvent {
  final String userID;

  Initializing(this.userID);
}

class ChangeAvatarRequest extends ProfileEvent {}

class OpenImagePicker extends ProfileEvent {
  final ImageSource imageSource;

  OpenImagePicker(this.imageSource);
}

class ProvideImagePath extends ProfileEvent {
  final String avatarPath;

  ProvideImagePath(this.avatarPath);
}

class SaveProfileChanges extends ProfileEvent {
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
