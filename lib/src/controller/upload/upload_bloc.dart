import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/model/album/album.dart';
import 'package:imagecaptioning/src/model/contest/contest.dart';
import 'package:imagecaptioning/src/model/post/post.dart';
import 'package:imagecaptioning/src/repositories/album/album_repository.dart';
import 'package:imagecaptioning/src/repositories/contest/contest_repository.dart';
import 'package:imagecaptioning/src/repositories/post/post_repository.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  UploadBloc()
      : _postRepository = PostRepository(),
        _albumRepository = AlbumRepository(),
        _contestRepository = ContestRepository(),
        super(UploadState()) {
    on<UploadInitializing>(_onInitial);
    on<SaveUploadPost>(_onSaveUploadPostChanges);
    on<RequestCaption>(_onRequestCaption);
  }
  final PostRepository _postRepository;
  final AlbumRepository _albumRepository;
  final ContestRepository _contestRepository;

  final int _limitAlbum = 50;
  final int _limitContest = 50;

  void _onInitial(
    UploadInitializing event,
    Emitter<UploadState> emit,
  ) async {
    try {
      String imgPath = event.imgPath;
      String? contestId = event.contestId;
      String originalImgPath = event.originalImgPath;
      emit(state.copyWith(
            imgPath: imgPath,
            contestId: contestId,
            originalImgPath: originalImgPath,
            status: FinishInitializing()));
      if (contestId != null) {
        
        final response = await _postRepository.getCaption(
          img: File(originalImgPath));

          

        if (response == null) {
        throw Exception("");
        }

        String message = response.messageCode ?? '';

        if (message.isNotEmpty) {
          throw Exception(message);
        }

        emit(state.copyWith(
            aiCaption: response.data,
            status: FinishInitializing()));
      } else {
        GetAlbumResponseMessage? albumRes =
          await _albumRepository.getAlbumInit(productPerPage: _limitAlbum);

      final List<Contest>? _activeContestList = await _contestRepository
          .getActiveContestList('', _limitContest, '', '');
      

      if (albumRes == null) {
        throw Exception("");
      }
      if (albumRes.statusCode == StatusCode.successStatus &&
          albumRes.data != null) {
        final data = albumRes.data;
        data!.removeWhere(
            (element) => element.albumName == "Poll Post Storage");
            if (_activeContestList != null) {
              _activeContestList.removeWhere((element) => element.isPosted == 1);
            }

            emit(state.copyWith(
            albumList: data,
            contestList: _activeContestList,
            status: FinishInitializing()));

      final response = await _postRepository.getCaption(
          img: File(imgPath));

      if (response == null) {
        throw Exception("");
      }

      String message = response.messageCode ?? '';

        if (message.isNotEmpty) {
          throw Exception(message);
        }

        emit(state.copyWith(
            aiCaption: response.data,
            status: FinishInitializing()));
      } else {
        throw Exception(albumRes.messageCode);
      }}
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }

  void _onSaveUploadPostChanges(
      SaveUploadPost event, Emitter<UploadState> emit) async {
    try {
      String? albumId = event.albumId;
      String? contestId = event.contestId;
      String aiCaption = state.aiCaption;
      String userCaption = event.userCaption;
      String postImg = event.postImg;

      final response = await _postRepository.addPost(
          albumId: albumId ?? "d5bd480f-1ddd-4bd6-9942-5f267792cdb7",
          contestId: contestId,
          postImg: File(postImg),
          aiCaption: aiCaption,
          userCaption: userCaption);

      if (response == null) {
        throw Exception("");
      }
      int status = response.statusCode ?? 0;
      Post? post = response.data;

      if (status == StatusCode.successStatus) {
        emit(state.copyWith(status: UploadSuccess(post)));
      } else {
        throw Exception(response.messageCode);
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }

  void _onRequestCaption(
      RequestCaption event, Emitter<UploadState> emit) async {
    try {
      String postImg = event.postImg;

      final response = await _postRepository.getCaption(
          img: File(postImg));

      if (response == null) {
        throw Exception("");
      }

      String message = response.messageCode ?? '';

        if (message.isNotEmpty) {
          throw Exception(message);
        }
        emit(state.copyWith(aiCaption: response.data));
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }
}
