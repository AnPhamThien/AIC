part of 'upload_bloc.dart';

abstract class UploadEvent {}

class UploadInitializing extends UploadEvent {
  final String imgPath;
  final String? contestId;
<<<<<<< HEAD

  UploadInitializing(this.imgPath, this.contestId);
=======
  final String originalImgPath;

  UploadInitializing(this.imgPath, this.contestId, this.originalImgPath);
>>>>>>> origin/NhanNT
}

class ChangeAvatar extends UploadEvent {
  final String avatarPath;

  ChangeAvatar(this.avatarPath);
}

class SaveUploadPost extends UploadEvent {
  final String? albumId;
  final String? contestId;
  final String userCaption;
  final String postImg;

  SaveUploadPost(
      {this.albumId,
      this.contestId,
      required this.userCaption,
      required this.postImg});
}

class RequestCaption extends UploadEvent {
  final String postImg;

  RequestCaption(
      {
      required this.postImg});
}