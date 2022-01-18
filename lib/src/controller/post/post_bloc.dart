import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/model/generic/generic.dart';
import 'package:imagecaptioning/src/repositories/post/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  PostBloc() : super(const PostState()) {
    on<LikePress>(_onLikePress);
    on<Reset>(_onReset);
    on<CheckSavePost>(_onCheckSavePost);
  }

  final PostRepository _postRepository = PostRepository();

  void _onCheckSavePost(
    CheckSavePost event,
    Emitter<PostState> emit,
  ) async {
    try {
      GetResponseMessage _respone =
          await _postRepository.checkSavePost(event.postId);
      if (_respone.statusCode == StatusCode.successStatus) {
        if (_respone.data == 0) {
          emit(state.copyWith(isSaved: false));
        } else {
          emit(state.copyWith(isSaved: true));
        }
      } else {
        throw Exception(_respone.messageCode);
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void _onLikePress(
    LikePress event,
    Emitter<PostState> emit,
  ) async {
    try {
      if (event.isLike == 0) {
        GetResponseMessage _respone =
            await _postRepository.addAndDeleteLike(event.postId);
        if (_respone.statusCode == StatusCode.successStatus) {
          emit(state.copyWith(
              status: PostStatus.like, postId: event.postId, needUpdate: true));
        }
      } else {
        GetResponseMessage _respone =
            await _postRepository.addAndDeleteLike(event.postId);
        if (_respone.statusCode == StatusCode.successStatus) {
          emit(state.copyWith(
              status: PostStatus.unlike,
              postId: event.postId,
              needUpdate: true));
        }
      }
    } catch (e) {
      log(e.toString());
    }
  }

  void _onReset(
    Reset event,
    Emitter<PostState> emit,
  ) async {
    emit(
        state.copyWith(status: PostStatus.init, postId: '', needUpdate: false));
  }
}
