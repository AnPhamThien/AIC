part of 'album_bloc.dart';

abstract class AlbumListEvent {
  const AlbumListEvent();
}

class FetchAlbumPosts extends AlbumListEvent {
  Album album;
  FetchAlbumPosts(this.album);
}

class FetchMoreAlbumPosts extends AlbumListEvent {}

class DeleteAlbum extends AlbumListEvent {}
