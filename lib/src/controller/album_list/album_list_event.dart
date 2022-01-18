part of 'album_list_bloc.dart';

abstract class AlbumListEvent {
  const AlbumListEvent();
}

class FetchAlbum extends AlbumListEvent {}

class FetchMoreAlbum extends AlbumListEvent {}

class AddNewAlbum extends AlbumListEvent {
  String albumName;
  AddNewAlbum(this.albumName);
}

class DeleteAlbum extends AlbumListEvent {
  String albumId;
  DeleteAlbum(this.albumId);
}
