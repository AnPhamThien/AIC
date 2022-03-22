import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/model/contest/list_top_post_in_contest.dart';
import 'package:imagecaptioning/src/model/generic/generic.dart';
import 'package:imagecaptioning/src/repositories/post/post_repository.dart';

part 'post_search_event.dart';
part 'post_search_state.dart';

class PostSearchBloc extends Bloc<PostSearchEvent, PostSearchState> {
  PostSearchBloc()
      : _postRepository = PostRepository(),
        super(PostSearchState()) {
    on<PostSearchInitializing>(_onInitial);
  }
  final PostRepository _postRepository;
  final int _limitPost = 20;

  void _onInitial(
    PostSearchInitializing event,
    Emitter<PostSearchState> emit,
  ) async {
    try {
      String imgPath = event.imgPath;

      GetResponseMessage? response =
          await _postRepository.getCaption(img: File(imgPath));

      if (response == null) {
        throw Exception("");
      }
      if (response.statusCode == StatusCode.successStatus &&
          response.data != null) {
        emit(state.copyWith(
          imgPath: imgPath,
            status: FinishInitializing()));
      } else {
        throw Exception(response.messageCode);
      }
    } on Exception catch (_) {
      
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }
}
