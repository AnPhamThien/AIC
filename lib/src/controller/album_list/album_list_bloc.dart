import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/model/album/album.dart';
import 'package:imagecaptioning/src/repositories/album/album_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'album_list_event.dart';
part 'album_list_state.dart';

const throttleDuration = Duration(milliseconds: 10);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class AlbumListBloc extends Bloc<AlbumListEvent, AlbumListState> {
  AlbumListBloc()
      : _albumRepository = AlbumRepository(),
        super(AlbumListState()) {
    on<FetchAlbum>(_onInitial,
        transformer: throttleDroppable(throttleDuration));
    on<FetchMoreAlbum>(_onFetchMore,
        transformer: throttleDroppable(throttleDuration));
    on<AddNewAlbum>(_onAddNewAlbum);
    on<EditAlbum>(_onEditAlbum);
    on<DeleteAlbum>(_onDeleteAlbum);
  }
  final AlbumRepository _albumRepository;

  void _onInitial(
    FetchAlbum event,
    Emitter<AlbumListState> emit,
  ) async {
    try {
      GetAlbumResponseMessage? resMessage =
          await _albumRepository.getAlbumInit(productPerPage: 8);

      if (resMessage == null) {
        throw Exception("");
      }

      final status = resMessage.statusCode ?? 0;
      final message = resMessage.messageCode ?? "";
      final data = resMessage.data ?? [];

      if (status == StatusCode.successStatus) {
        if (state.albumList.isNotEmpty) {
          state.albumList.clear();
        }
        emit(state.copyWith(
            status: FinishInitializing(),
            albumList: data,
            currentPage: 1,
            hasReachedMax: false));
      } else {
        throw Exception(message);
      }
    } catch (_) {
      emit(state.copyWith(status: ErrorStatus(_.toString())));
    }
  }

  void _onFetchMore(
    FetchMoreAlbum event,
    Emitter<AlbumListState> emit,
  ) async {
    try {
      if (!state.hasReachedMax) {
        int currentPage = state.currentPage;
        GetAlbumResponseMessage? resMessage = await _albumRepository
            .getPageAlbum(currentPage: currentPage + 1, productPerPage: 8);

        if (resMessage == null) {
          throw Exception("");
        }

        final status = resMessage.statusCode ?? 0;
        final message = resMessage.messageCode ?? "";
        final data = resMessage.data ?? [];

        if (status == StatusCode.successStatus && data.isNotEmpty) {
          List<Album> albumList = data;
          final currentList = state.albumList;

          emit(state.copyWith(
              status: FinishInitializing(),
              albumList: [...currentList, ...albumList],
              hasReachedMax: false,
              currentPage: currentPage + 1));
        } else if (data.isEmpty) {
          emit(state.copyWith(
              status: FinishInitializing(), hasReachedMax: true));
        } else {
          throw Exception(message);
        }
      }
    } catch (_) {
      emit(state.copyWith(status: ErrorStatus(_.toString())));
    }
  }

  void _onAddNewAlbum(
    AddNewAlbum event,
    Emitter<AlbumListState> emit,
  ) async {
    try {
      String albumName = event.albumName.trim();
      if (albumName.isNotEmpty) {
        final resMessage =
            await _albumRepository.addAlbum(albumName: albumName);

        if (resMessage == null) {
          throw Exception("");
        }

        if (resMessage is int) {
          if (resMessage == StatusCode.successStatus) {
            emit(state.copyWith(status: CreateAlbumStatus()));
          } else {
            throw Exception('');
          }
        } else {
          throw Exception(resMessage);
        }
      }
    } catch (_) {
      emit(state.copyWith(status: ErrorStatus(_.toString())));
    }
  }

  void _onEditAlbum(
    EditAlbum event,
    Emitter<AlbumListState> emit,
  ) async {
    try {
      String albumName = event.albumName.trim();
      String albumId = event.albumId;
      if (albumName.isNotEmpty && albumId.isNotEmpty) {
        final resMessage = await _albumRepository.updateAlbum(
            albumName: albumName, id: albumId);

        if (resMessage == null) {
          throw Exception("");
        }

        if (resMessage is int) {
          if (resMessage == StatusCode.successStatus) {
          } else {
            throw Exception('');
          }
        } else {
          throw Exception(resMessage);
        }
      }
    } catch (_) {
      emit(state.copyWith(status: ErrorStatus(_.toString())));
    }
  }

  void _onDeleteAlbum(
    DeleteAlbum event,
    Emitter<AlbumListState> emit,
  ) async {
    try {
      String albumId = event.albumId;
      if (albumId.isNotEmpty) {
        final resMessage =
            await _albumRepository.deleteAlbum(id: albumId, status: 4);

        if (resMessage == null) {
          throw Exception("");
        }

        if (resMessage is int) {
          if (resMessage == StatusCode.successStatus) {
            emit(state.copyWith(status: DeleteAlbumStatus()));
          } else {
            throw Exception('');
          }
        } else {
          throw Exception(resMessage);
        }
      }
    } catch (_) {
      emit(state.copyWith(status: ErrorStatus(_.toString())));
    }
  }
}
