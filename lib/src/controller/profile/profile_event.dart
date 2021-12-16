part of "profile_bloc.dart";

abstract class ProfileEvent {}

class Initializing extends ProfileEvent {}

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
  final String name;
  final String desc;
  final String email;
  final String phone;

  SaveProfileChanges(
      {required this.name,
      required this.desc,
      required this.email,
      required this.phone});
}
