import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:imagecaptioning/src/constant/error_message.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/model/generic/generic.dart';
import 'package:imagecaptioning/src/model/post/post_comment_like_respone.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../model/post/comment.dart';
import '../../model/post/post.dart';
import '../../model/post/post_add_comment_request.dart';
import '../../model/post/post_comment_like_data.dart';
import '../../model/post/post_comment_list_respone.dart';
import '../../repositories/post/post_repository.dart';

part 'post_detail_event.dart';
part 'post_detail_state.dart';

const throttleDuration = Duration(milliseconds: 10);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

const _commentPerPage = 4;

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  PostDetailBloc() : super(const PostDetailState()) {
    on<PostDetailInitEvent>(
      _onPostDetailInitial,
      transformer: throttleDroppable(throttleDuration),
    );
    on<PostDetailFetchMoreComment>(
      _fetchMoreComment,
      transformer: throttleDroppable(throttleDuration),
    );

    on<PostDetailAddComment>(
      _addComment,
      transformer: throttleDroppable(throttleDuration),
    );
    on<PostDetailDeleteComment>(
      _postDetailDeleteComment,
      transformer: throttleDroppable(throttleDuration),
    );
    on<CommentDeleted>(
      _commentDeleted,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final PostRepository _postRepository = PostRepository();
  late Post _post;

  void _commentDeleted(
    CommentDeleted event,
    Emitter<PostDetailState> emit,
  ) async {
    try {
      emit(state.copyWith(deleted: null, status: PostDetailStatus.success));
    } catch (e) {
      log(e.toString());
    }
  }

  void _postDetailDeleteComment(
    PostDetailDeleteComment event,
    Emitter<PostDetailState> emit,
  ) async {
    try {
      String _commentId = event.commentId;
      GetResponseMessage? _respone =
          await _postRepository.deleteComment(_commentId);
      if (_respone.statusCode == StatusCode.successStatus) {
        emit(
          state.copyWith(
            deleted: event.index,
            status: PostDetailStatus.deleted,
          ),
        );
      } else if (_respone.statusCode == StatusCode.failStatus &&
          _respone.messageCode == MessageCode.commentNotFound) {
        return;
      } else {
        throw Exception(_respone.messageCode);
      }
    } catch (_) {
      emit(state.copyWith(status: PostDetailStatus.failure));
    }
  }

  void _onPostDetailInitial(
      PostDetailInitEvent event, Emitter<PostDetailState> emit) async {
    try {
      _post = event.post;
      final String _postId = _post.postId!;
      final PostCommentLikeRespone _respone =
          await _postRepository.getInitLikeComment(_commentPerPage, _postId);
      final PostCommentLikeData _data = _respone.data!;
      if (_respone.statusCode == StatusCode.successStatus) {
        event.post.likecount = _data.totalLike;
        emit(state.copyWith(
          status: PostDetailStatus.success,
          post: event.post,
          commentList: _data.comments ?? [],
          commentCount: _data.totalComment,
          hasReachMax: false,
          deleted: null,
        ));
      } else {
        throw Exception(_respone.messageCode);
      }
    } on Exception catch (_) {
      log(_.toString() + "init");
      //emit(state.copyWith(status: PostDetailStatus.success));
    }
  }

  void _fetchMoreComment(
      PostDetailFetchMoreComment event, Emitter<PostDetailState> emit) async {
    if (state.hasReachMax || state.commentList.isEmpty) {
      return;
    }
    try {
      final String _dateBoundary = state.commentList.last.dateCreate.toString();
      final PostCommentListRespone _respone = await _postRepository
          .getMoreComment(_dateBoundary, _commentPerPage, _post.postId!);
      final List<Comment>? _newComments = _respone.data;
      if (_respone.messageCode == MessageCode.noCommentToDisplay) {
        emit(state.copyWith(hasReachMax: true));
      } else if (_respone.statusCode == StatusCode.successStatus) {
        emit(
          state.copyWith(
            status: PostDetailStatus.success,
            commentList: [...state.commentList, ..._newComments ?? []],
            hasReachMax: false,
          ),
        );
      } else {
        throw Exception(_respone.messageCode);
      }
    } catch (_) {
      emit(state.copyWith(status: PostDetailStatus.failure));
    }
  }

  void _addComment(
      PostDetailAddComment event, Emitter<PostDetailState> emit) async {
    try {
      String _comment = event.comment;
      GetResponseMessage? _respone = await _postRepository.addComment(
        PostAddCommentRequest(
          content: _comment,
          postId: _post.postId,
        ),
      );
      if (_respone.statusCode == StatusCode.successStatus) {
        add(PostDetailInitEvent(_post));
        return;
      } else {
        throw Exception(_respone.messageCode);
      }
    } catch (_) {
      log(_.toString() + "add");
      emit(state.copyWith(status: PostDetailStatus.failure));
    }
  }
}
