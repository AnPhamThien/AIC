import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/constant/error_message.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/model/album/album.dart';
import 'package:imagecaptioning/src/model/post/list_of_post_respone.dart';
import 'package:imagecaptioning/src/model/post/post.dart';
import 'package:imagecaptioning/src/repositories/album/album_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'album_event.dart';
part 'album_state.dart';

const throttleDuration = Duration(milliseconds: 10);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class AlbumBloc extends Bloc<AlbumListEvent, AlbumState> {
  AlbumBloc()
      : _albumRepository = AlbumRepository(),
        super(AlbumState()) {
    on<FetchAlbumPosts>(_onInitial,
        transformer: throttleDroppable(throttleDuration));
    on<FetchMoreAlbumPosts>(_onFetchMore,
        transformer: throttleDroppable(throttleDuration));
    on<DeleteAlbum>(_onDeleteAlbum);
  }
  final AlbumRepository _albumRepository;

  void _onInitial(
    FetchAlbumPosts event,
    Emitter<AlbumState> emit,
  ) async {
    try {
      final album = event.album;
      if (album.id == null) {
        throw Exception();
      }
      GetListOfPostResponseMessage? resMessage = await _albumRepository
          .getAlbumPost(limitPost: limitPost, albumId: album.id!);

      if (resMessage == null) {
        throw Exception("");
      }

      final status = resMessage.statusCode ?? 0;
      final message = resMessage.messageCode ?? "";
      final data = resMessage.data ?? [];

      if (status == StatusCode.successStatus ||
          message == MessageCode.noPostToDisplay) {
        emit(state.copyWith(
            status: FinishInitializing(),
            album: album,
            postList: data,
            currentPage: 1,
            hasReachedMax:
                (message == MessageCode.noPostToDisplay) ? true : false));
      } else {
        throw Exception(message);
      }
    } catch (_) {
      emit(state.copyWith(status: ErrorStatus(_.toString())));
    }
  }

  void _onFetchMore(
    FetchMoreAlbumPosts event,
    Emitter<AlbumState> emit,
  ) async {
    try {
      if (!state.hasReachedMax) {
        int currentPage = state.currentPage;
        GetListOfPostResponseMessage? resMessage =
            await _albumRepository.getMoreAlbumPost(
                limitPost: limitPost,
                currentPage: currentPage + 1,
                albumId: state.album!.id!);

        if (resMessage == null) {
          throw Exception("");
        }

        final status = resMessage.statusCode ?? 0;
        final message = resMessage.messageCode ?? "";
        final data = resMessage.data;

        if (status == StatusCode.successStatus && data != null) {
          List<Post> postList = data;
          final currentList = state.postList ?? [];

          emit(state.copyWith(
              status: FinishInitializing(),
              postList: [...currentList, ...postList],
              hasReachedMax: false,
              currentPage: currentPage + 1));
        } else if (message == MessageCode.noPostToDisplay) {
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

  void _onDeleteAlbum(
    DeleteAlbum event,
    Emitter<AlbumState> emit,
  ) async {
    try {
      String albumId = state.album?.id ?? '';
      if (albumId.isNotEmpty) {
        final resMessage =
            await _albumRepository.deleteAlbum(id: albumId, status: 4);

        if (resMessage == null) {
          throw Exception("");
        }

        if (resMessage is int) {
          if (resMessage == StatusCode.successStatus) {
            emit(state.copyWith(status: DeletedStatus()));
            //add(FetchAlbumPosts(state.album!));
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
