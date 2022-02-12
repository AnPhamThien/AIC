part of 'album_list_bloc.dart';

class AlbumListState {
  final List<Album> albumList;
  final AlbumListStatus status;
  final bool hasReachedMax;
  final int currentPage;

  AlbumListState(
      {this.albumList = const <Album>[],
      this.status = const InitialStatus(),
      this.hasReachedMax = false,
      this.currentPage = 0});

  AlbumListState copyWith(
      {List<Album>? albumList,
      AlbumListStatus? status,
      bool? hasReachedMax,
      int? currentPage}) {
    return AlbumListState(
        albumList: albumList ?? this.albumList,
        status: status ?? this.status,
        hasReachedMax: hasReachedMax ?? this.hasReachedMax,
        currentPage: currentPage ?? this.currentPage);
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
