part of 'upload_bloc.dart';

class UploadState {
  final String? imgPath;
  final List<Contest> contestList;
  final List<Album> albumList;

  final UploadStatus status;

  UploadState({
    this.imgPath,
    this.contestList = const <Contest>[],
    this.albumList = const <Album>[],
    this.status = const InitialStatus(),
  });

  UploadState copyWith({
    String? imgPath,
    List<Contest>? contestList,
    List<Album>? albumList,
    UploadStatus? status,
  }) {
    return UploadState(
      imgPath: imgPath ?? this.imgPath,
      contestList: contestList ?? this.contestList,
      albumList: albumList ?? this.albumList,
      status: status ?? this.status,
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
  Post post;
  UploadSuccess(this.post);
}

class ErrorStatus extends UploadStatus {
  final Exception exception;
  ErrorStatus(this.exception);
}
