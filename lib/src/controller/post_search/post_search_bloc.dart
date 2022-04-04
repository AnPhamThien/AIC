import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:imagecaptioning/src/constant/error_message.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/model/post/post.dart';
import 'package:imagecaptioning/src/model/search/search_post.dart';
import 'package:imagecaptioning/src/repositories/post/post_repository.dart';
import 'package:stream_transform/stream_transform.dart';
part 'post_search_event.dart';
part 'post_search_state.dart';

const throttleDuration = Duration(milliseconds: 10);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PostSearchBloc extends Bloc<PostSearchEvent, PostSearchState> {
  PostSearchBloc()
      : _postRepository = PostRepository(),
        super(PostSearchState()) {
    on<PostSearch>(_onPostSearch, transformer: throttleDroppable(throttleDuration));
    on<PostSearchMore>(_onPostSearchMore, transformer: throttleDroppable(throttleDuration));

  }
  
  final PostRepository _postRepository;
  final int _limitPost = 15;

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
      final status = response.statusCode;
      final message = response.messageCode;
      final data = response.data;
      if (status == StatusCode.successStatus &&
          response.data != null) {

        emit(state.copyWith(
          searchResultPostList: data,
          searchString: searchString,
            status: FinishInitializing(), hasReachedMax: false));
      } else if(message == MessageCode.noPostToDisplay) {
        emit(state.copyWith(
          searchResultPostList: [],
          searchString: searchString,
            status: FinishInitializing(), hasReachedMax: true));
            } else {
        throw Exception(message);
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }

  void _onPostSearchMore(
    PostSearchMore event,
    Emitter<PostSearchState> emit,
  ) async {
    try {
      if (state.hasReachedMax) {
        return;
      }

      String searchString = state.searchString ?? '';
      String dateBoundary = state.searchResultPostList?.last.dateCreate.toString() ?? '';

      ListSearchPostResponseMessage? response =
          await _postRepository.searchMorePostByKey(searchString: searchString, limitPost: _limitPost, dateBoundary: dateBoundary);

      if (response == null) {
        throw Exception("");
      }
      final status = response.statusCode;
      final message = response.messageCode;
      final data = response.data;

      if (status == StatusCode.successStatus &&
          data != null) {
            List<Post> searchResultPostList= state.searchResultPostList ?? [];
            searchResultPostList.addAll(data);
        emit(state.copyWith(
          searchResultPostList: searchResultPostList,
          searchString: searchString,
            status: FinishInitializing(), hasReachedMax: false));
      } else if(message == MessageCode.noPostToDisplay) {
        emit(state.copyWith(
          searchString: searchString,
            status: FinishInitializing(), hasReachedMax: true));
            } else {
        throw Exception(message);
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }
}
