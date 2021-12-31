import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:imagecaptioning/src/model/post/list_post_data.dart';
import 'package:imagecaptioning/src/model/post/followee.dart';
import 'package:imagecaptioning/src/model/post/post.dart';
import 'package:imagecaptioning/src/model/post/post_list_request.dart';
import 'package:imagecaptioning/src/repositories/post/post_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'home_event.dart';
part 'home_state.dart';

const throttleDuration = Duration(milliseconds: 10);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

const _postPerPerson = 1;
const _postDate = 100;

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<InitPostFetched>(
      _onInitPostFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<FetchMorePost>(
      _fetchMorePost,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  List<Followee> _listFollowee = [];

  final PostRepository _postRepository = PostRepository();

  void _onInitPostFetched(
      InitPostFetched event, Emitter<HomeState> emit) async {
    try {
      if (state.status == HomeStatus.initial) {
        final ListPostData? data =
            await _postRepository.getPost(_postPerPerson, _postDate);
        _listFollowee = data?.followees ?? [];

        emit(state.copyWith(
          status: HomeStatus.success,
          postsList: data?.posts ?? [],
          hasReachedMax: false,
        ));
      }
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }

  void _fetchMorePost(FetchMorePost event, Emitter<HomeState> emit) async {
    if (state.hasReachedMax) {
      emit(state.copyWith(status: HomeStatus.maxpost));
      return;
    }
    try {
      final ListPostData? data = await _postRepository.getMorePost(
          PostListRequest(
              postPerPerson: _postPerPerson,
              limitDay: _postDate,
              listFollowees: _listFollowee));
      final List<Post>? _newPosts = data?.posts;
      if (_newPosts == null) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        _listFollowee = data?.followees ?? [];
        emit(state.copyWith(
          status: HomeStatus.success,
          postsList: [...state.postsList, ..._newPosts],
          hasReachedMax: false,
        ));
      }
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.failure));
    }
  }
}
