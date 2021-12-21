import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:imagecaptioning/src/model/post/post.dart';
import 'package:imagecaptioning/src/repositories/post/post_repository.dart';

part 'home_event.dart';
part 'home_state.dart';

// const throttleDuration = Duration(milliseconds: 100);

// EventTransformer<E> throttleDroppable<E>(Duration duration) {
//   return (events, mapper) {
//     return droppable<E>().call(events.throttle(duration), mapper);
//   };
// }

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._postRepository) : super(const HomeState()) {
    on<HomeEvent>((event, emit) {
      on<PostFetched>(_onPostFetched);
    });
  }

  final PostRepository _postRepository;

  Future<void> _onPostFetched(
      PostFetched event, Emitter<HomeState> emit) async {
    if (state.hasReachedMax) return;
    try {
      if (state.status == HomeStatus.initial) {
        final data = await _postRepository.getPost(10, 100);
        return emit(state.copyWith(
          status: HomeStatus.success,
          posts: data?.posts,
          hasReachedMax: false,
        ));
      }
      // final posts = await _fetchPosts(state.posts.length);
      // emit(posts.isEmpty
      //     ? state.copyWith(hasReachedMax: true)
      //     : state.copyWith(
      //         status: PostStatus.success,
      //         posts: List.of(state.posts)..addAll(posts),
      //         hasReachedMax: false,
      //       ));
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }
}
