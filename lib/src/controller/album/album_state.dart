part of 'album_bloc.dart';

class AlbumState {
  final List<Post>? postList;
  final AlbumBlocStatus status;
  final Album? album;
  final bool hasReachedMax;

  AlbumState(
      {this.postList,
      this.status = const InitialStatus(),
      this.album,
      this.hasReachedMax = false});

  AlbumState copyWith(
      {List<Post>? postList,
      AlbumBlocStatus? status,
      Album? album,
      bool? hasReachedMax}) {
    return AlbumState(
        postList: postList ?? this.postList,
        status: status ?? this.status,
        album: album ?? this.album,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }
}

abstract class AlbumBlocStatus {
  const AlbumBlocStatus();
}

class InitialStatus extends AlbumBlocStatus {
  const InitialStatus();
}

class FinishInitializing extends AlbumBlocStatus {}

class ReachedMaxedStatus extends AlbumBlocStatus {}

class ErrorStatus extends AlbumBlocStatus {
  final String exception;
  ErrorStatus(this.exception);
}
