part of 'upload_bloc.dart';

class UploadState {
  final String? imgPath;
  final List<Contest> contestList;
  final List<Album> albumList;
  final String aiCaption;
  final UploadStatus status;
  final String? contestId;
<<<<<<< HEAD
=======
  final String? originalImgPath;
>>>>>>> origin/NhanNT

  UploadState({
    this.imgPath,
    this.contestList = const <Contest>[],
    this.albumList = const <Album>[],
    this.aiCaption = '',
    this.status = const InitialStatus(),
<<<<<<< HEAD
    this.contestId
=======
    this.contestId,
    this.originalImgPath
>>>>>>> origin/NhanNT
  });

  UploadState copyWith({
    String? imgPath,
    List<Contest>? contestList,
    List<Album>? albumList,
    String? aiCaption,
    UploadStatus? status,
<<<<<<< HEAD
    String? contestId
=======
    String? contestId,
    String? originalImgPath
>>>>>>> origin/NhanNT
  }) {
    return UploadState(
      imgPath: imgPath ?? this.imgPath,
      contestList: contestList ?? this.contestList,
      albumList: albumList ?? this.albumList,
      aiCaption: aiCaption ?? this.aiCaption,
      status: status ?? this.status,
<<<<<<< HEAD
      contestId: contestId ?? this.contestId
=======
      contestId: contestId ?? this.contestId,
      originalImgPath: originalImgPath ?? this.originalImgPath
>>>>>>> origin/NhanNT
    );
  }
}

abstract class UploadStatus {
  const UploadStatus();
}

class InitialStatus extends UploadStatus {
  const InitialStatus();
}

class FinishInitializing extends UploadStatus {}

class UploadSuccess extends UploadStatus {
  Post? post;
  UploadSuccess(this.post);
}

class ErrorStatus extends UploadStatus {
  final Exception exception;
  ErrorStatus(this.exception);
}
