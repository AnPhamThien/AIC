import 'dart:developer';
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
            (element) => element.albumName == "Contest Post Storage");
        emit(state.copyWith(
            imgPath: imgPath,
            albumList: data,
            contestList: _activeContestList,
            status: FinishInitializing()));
      } else {
        throw Exception(albumRes.messageCode);
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }

  void _onSaveUploadPostChanges(
      SaveUploadPost event, Emitter<UploadState> emit) async {
    try {
      String? albumId = event.albumId;
      String? contestId = event.contestId;
      String aiCaption = event.aiCaption;
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
      log(response.messageCode.toString());
      int status = response.statusCode ?? 0;
      Post? post = response.data;

      if (status == StatusCode.successStatus && post != null) {
        emit(state.copyWith(status: UploadSuccess(post)));
      } else {
        throw Exception(response.messageCode);
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }
}
