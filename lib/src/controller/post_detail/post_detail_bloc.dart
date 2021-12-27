import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'post_detail_event.dart';
part 'post_detail_state.dart';

class PostDetailBloc extends Bloc<PostDetailEvent, PostDetailState> {
  PostDetailBloc() : super(const PostDetailState()) {
    on<PostInitEvent>(_onPostDetailInitial);
  }
}

void _onPostDetailInitial(
    PostInitEvent event, Emitter<PostDetailState> emit) async {
  try {
    if (event.postId.isEmpty) {
      throw Exception("postID Empty");
    }
    //TODO fetch post detail ve
  } on Exception catch (_) {
    if (_.toString() == "postID Empty") {
      log("post ID rỗng, post detail bloc dòng 23");
    }
  }
}
