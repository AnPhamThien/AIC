import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:imagecaptioning/src/model/post/post.dart';

part 'post_detail_event.dart';
part 'post_detail_state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  PostDetailBloc() : super(const PostDetailState()) {
    on<PostInitEvent>(_onPostDetailInitial);
  }

  void _onPostDetailInitial(
      PostInitEvent event, Emitter<PostDetailState> emit) async {
    try {
      if (state.status == PostDetailStatus.initial) {
        // if (event.post!.postId == '') {
        //   throw Exception("no post");
        // }
        log(event.post.postId.toString());
        emit(state.copyWith(
            status: PostDetailStatus.success,
            post: event.post,
            hasReachMax: false));
      }
    } on Exception catch (_) {
      if (_.toString() == "postID Empty") {
        log("post ID rỗng, post detail bloc dòng 23");
      }
    }
  }
}
