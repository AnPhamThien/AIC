import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import '../../constanct/status_code.dart';
import '../../model/post/comment.dart';
import '../../model/post/post.dart';
import '../../model/post/post_add_comment_request.dart';
import '../../model/post/post_add_comment_respone.dart';
import '../../model/post/post_comment_like_data.dart';
import '../../model/post/post_comment_list_respone.dart';
import '../../repositories/post/post_repository.dart';
import 'package:stream_transform/stream_transform.dart';
part 'post_detail_event.dart';
part 'post_detail_state.dart';

const throttleDuration = Duration(milliseconds: 10);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

const _commentPerPage = 10;

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
  }

  final PostRepository _postRepository = PostRepository();
  void _onPostDetailInitial(
      PostDetailInitEvent event, Emitter<PostDetailState> emit) async {
    try {
      final PostCommentLikeData? data = await _postRepository
          .getInitLikeComment(_commentPerPage, event.post.postId!);
      state.post?.likecount = data?.totalLike;
      emit(state.copyWith(
        status: PostDetailStatus.success,
        post: event.post,
        commentList: data?.comments,
        commentCount: data?.totalComment,
        hasReachMax: false,
        isReload: false,
      ));
    } on Exception catch (_) {
      emit(state.copyWith(status: PostDetailStatus.failure));
      if (_.toString() == "postID Empty") {
        log("post ID rỗng, post detail bloc dòng 23");
      }
    }
  }

  void _fetchMoreComment(
      PostDetailFetchMoreComment event, Emitter<PostDetailState> emit) async {
    if (state.hasReachMax) {
      emit(state.copyWith(status: PostDetailStatus.maxcomment));
      return;
    }
    try {
      final String _dateBoundary = state.commentList.last.dateCreate.toString();
      final String? _postId = state.post?.postId;
      final PostCommentListRespone? respone = await _postRepository
          .getMoreComment(_dateBoundary, _commentPerPage, _postId!);
      final List<Comment>? _newComments = respone?.data;

      if (_newComments == null) {
        emit(state.copyWith(hasReachMax: true));
      } else {
        emit(
          state.copyWith(
            status: PostDetailStatus.success,
            commentList: [...state.commentList, ..._newComments],
            hasReachMax: false,
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(status: PostDetailStatus.failure));
    }
  }

  void _addComment(
      PostDetailAddComment event, Emitter<PostDetailState> emit) async {
    try {
      String _comment = event.comment;
      String _postId = state.post!.postId!;
      PostAddCommentRespone? _respone = await _postRepository.addComment(
        PostAddCommentRequest(
          content: _comment,
          postId: _postId,
        ),
      );
      if (_respone == null) {
        throw Exception('respone null');
      }
      int _statusCode = _respone.statusCode ?? 0;
      if (_statusCode == StatusCode.successStatus) {
        emit(state.copyWith(
          status: PostDetailStatus.success,
          isReload: true,
        ));
      } else {
        emit(state.copyWith(status: PostDetailStatus.addcommentfailed));
      }
    } catch (_) {}
  }
}
