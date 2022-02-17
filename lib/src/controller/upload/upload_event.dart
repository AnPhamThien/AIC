part of 'upload_bloc.dart';

abstract class UploadEvent {}

class UploadInitializing extends UploadEvent {
  final String imgPath;

  UploadInitializing(this.imgPath);
}

class ChangeAvatar extends UploadEvent {
  final String avatarPath;

  ChangeAvatar(this.avatarPath);
}

class SaveUploadPost extends UploadEvent {
  final String? albumId;
  final String? contestId;
  final String aiCaption;
  final String userCaption;
  final String postImg;

  SaveUploadPost(
      {this.albumId,
      this.contestId,
      required this.aiCaption,
      required this.userCaption,
      required this.postImg});
}
