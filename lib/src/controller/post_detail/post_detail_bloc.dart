import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:imagecaptioning/src/model/post/comment.dart';
import 'package:imagecaptioning/src/model/post/post.dart';
import 'package:imagecaptioning/src/model/post/post_comment_like_data.dart';
import 'package:imagecaptioning/src/repositories/post/post_repository.dart';
import 'package:stream_transform/stream_transform.dart';
part 'post_detail_event.dart';
part 'post_detail_state.dart';

const throttleDuration = Duration(milliseconds: 10);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  PostDetailBloc() : super(const PostDetailState()) {
    on<PostInitEvent>(_onPostDetailInitial);
  }

  final PostRepository _postRepository = PostRepository();
  void _onPostDetailInitial(
      PostInitEvent event, Emitter<PostDetailState> emit) async {
    try {
      if (state.status == PostDetailStatus.initial) {
        final PostCommentLikeData? data =
            await _postRepository.getInitLikeComment(5, event.post.postId!);
        state.post?.likecount = data?.totalLike;
        emit(state.copyWith(
            status: PostDetailStatus.success,
            post: event.post,
            commentList: data?.comments,
            commentCount: data?.totalComment,
            hasReachMax: false));
      }
    } on Exception catch (_) {
      if (_.toString() == "postID Empty") {
        log("post ID rỗng, post detail bloc dòng 23");
      }
    }
  }
}
