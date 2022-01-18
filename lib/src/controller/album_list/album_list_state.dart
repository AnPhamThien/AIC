part of 'album_list_bloc.dart';

class AlbumListState {
  final List<Album>? albumList;
  final AlbumListStatus status;
  final bool hasReachedMax;

  AlbumListState(
      {this.albumList,
      this.status = const InitialStatus(),
      this.hasReachedMax = false});

  AlbumListState copyWith(
      {List<Album>? albumList, AlbumListStatus? status, bool? hasReachedMax}) {
    return AlbumListState(
        albumList: albumList ?? this.albumList,
        status: status ?? this.status,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax);
  }
}

abstract class AlbumListStatus {
  const AlbumListStatus();
}

class InitialStatus extends AlbumListStatus {
  const InitialStatus();
}

class FinishInitializing extends AlbumListStatus {}

class ReachedMaxedStatus extends AlbumListStatus {}

class ErrorStatus extends AlbumListStatus {
  final String exception;
  ErrorStatus(this.exception);
}
