import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:imagecaptioning/src/model/post/data.dart';
import 'package:imagecaptioning/src/model/post/post.dart';
import 'package:imagecaptioning/src/repositories/post/post_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'home_event.dart';
part 'home_state.dart';

// const throttleDuration = Duration(milliseconds: 100);

// EventTransformer<E> throttleDroppable<E>(Duration duration) {
//   return (events, mapper) {
//     return droppable<E>().call(events.throttle(duration), mapper);
//   };
// }

const _postPerPerson = 10;
const _postDate = 100;

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._postRepository) : super(const HomeState()) {
    on<HomeEvent>((event, emit) {
      on<PostFetched>(_onPostFetched);
    });
  }

  final PostRepository _postRepository;

  Future<void> _onPostFetched(
      PostFetched event, Emitter<HomeState> emit) async {
    log("Vo day 36");
    if (state.hasReachedMax) return;
    try {
      if (state.status == HomeStatus.initial) {
        log("Vo day 40");
        final Data? data =
            await _postRepository.getPost(_postPerPerson, _postDate);
            log("Vo day 43");
        return emit(state.copyWith(
          status: HomeStatus.success,
          postsList: data?.posts ?? [],
          hasReachedMax: false,
        ));
      }
      // final posts = await _postRepository.getPost(10, 100);
      // emit(posts!.posts.isEmpty
      //     ? state.copyWith(hasReachedMax: true)
      //     : state.copyWith(
      //         status: HomeStatus.success,
      //         posts: List.of(state.posts)..addAll(posts.posts),
      //         hasReachedMax: false,
      //       ));
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }
}
