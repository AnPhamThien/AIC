part of 'upload_bloc.dart';

class UploadState {
  final String? imgPath;
  final List<Contest> contestList;
  final List<Album> albumList;
  final String aiCaption;
  final UploadStatus status;
  final String? contestId;
  final String? originalImgPath;
  final bool aiGenerationInProgress;

  UploadState({
    this.imgPath,
    this.contestList = const <Contest>[],
    this.albumList = const <Album>[],
    this.aiCaption = '',
    this.status = const InitialStatus(),
    this.contestId,
    this.originalImgPath,
    this.aiGenerationInProgress = true
  });

  UploadState copyWith({
    String? imgPath,
    List<Contest>? contestList,
    List<Album>? albumList,
    String? aiCaption,
    UploadStatus? status,
    String? contestId,
    String? originalImgPath,
    bool? aiGenerationInProgress
  }) {
    return UploadState(
      imgPath: imgPath ?? this.imgPath,
      contestList: contestList ?? this.contestList,
      albumList: albumList ?? this.albumList,
      aiCaption: aiCaption ?? this.aiCaption,
      status: status ?? this.status,
      contestId: contestId ?? this.contestId,
      originalImgPath: originalImgPath ?? this.originalImgPath,
      aiGenerationInProgress: aiGenerationInProgress ?? this.aiGenerationInProgress
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
