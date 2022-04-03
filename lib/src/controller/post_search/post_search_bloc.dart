import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/model/post/post.dart';
import 'package:imagecaptioning/src/model/search/search_post.dart';
import 'package:imagecaptioning/src/repositories/post/post_repository.dart';

part 'post_search_event.dart';
part 'post_search_state.dart';

class PostSearchBloc extends Bloc<PostSearchEvent, PostSearchState> {
  PostSearchBloc()
      : _postRepository = PostRepository(),
        super(PostSearchState()) {
    on<PostSearch>(_onPostSearch);
  }
  final PostRepository _postRepository;
  final int _limitPost = 20;

  void _onPostSearch(
    PostSearch event,
    Emitter<PostSearchState> emit,
  ) async {
    try {
      String searchString = event.searchString;

      ListSearchPostResponseMessage? response =
          await _postRepository.searchPostByKey(searchString: searchString, limitPost: _limitPost);

      if (response == null) {
        throw Exception("");
      }
      if (response.statusCode == StatusCode.successStatus &&
          response.data != null) {
        emit(state.copyWith(
          searchResultPostList: response.data?.posts,
          searchResultWordList: response.data?.words,
            status: FinishInitializing()));
      } else {
        throw Exception(response.messageCode);
      }
    } on Exception catch (_) {
      
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }
}
