import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:imagecaptioning/src/constant/error_message.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/model/category/category.dart';
import 'package:imagecaptioning/src/model/generic/generic.dart';
import 'package:imagecaptioning/src/model/post/list_of_post_respone.dart';
import 'package:imagecaptioning/src/model/post/list_post_data.dart';
import 'package:imagecaptioning/src/model/post/followee.dart';
import 'package:imagecaptioning/src/model/post/post.dart';
import 'package:imagecaptioning/src/model/post/post_list_request.dart';
import 'package:imagecaptioning/src/repositories/post/post_repository.dart';

import 'package:stream_transform/stream_transform.dart';

part 'home_event.dart';
part 'home_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

const _postPerPerson = 5;
const _postDate = 3;

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState()) {
    on<InitPostFetched>(_onInitPostFetched,
        transformer: throttleDroppable(throttleDuration));
    on<FetchMorePost>(_fetchMorePost,
        transformer: throttleDroppable(throttleDuration));

    on<PostAdded>(_postAdded, transformer: throttleDroppable(throttleDuration));
    on<DeletePost>(_onDeletePost,
        transformer: throttleDroppable(throttleDuration));
    on<PostListReset>(_onReset,
        transformer: throttleDroppable(throttleDuration));
    on<PostUpdated>(_postUpdated,
        transformer: throttleDroppable(throttleDuration));
  }

  List<Followee> _listFollowee = [];
  final PostRepository _postRepository = PostRepository();

  void _onDeletePost(
    DeletePost event,
    Emitter<HomeState> emit,
  ) async {
    try {
      GetResponseMessage _respone =
          await _postRepository.deletePost(event.postId);
      if (_respone.statusCode == StatusCode.successStatus) {
        emit(state.copyWith(
            status: HomeStatus.success, deletedPostId: event.postId));
      } else {
        throw Exception(_respone.messageCode);
      }
    } catch (e) {
      emit(state.copyWith(status: HomeStatus.failure, error: e.toString()));
      log(e.toString());
    }
  }

  void _onReset(
    PostListReset event,
    Emitter<HomeState> emit,
  ) async {
    try {
      emit(state.copyWith(deletedPostId: '', status: HomeStatus.success));
    } catch (e) {
      log(e.toString());
    }
  }

  void _onInitPostFetched(
      InitPostFetched event, Emitter<HomeState> emit) async {
    try {
      if (state.postsList.isNotEmpty) {
        state.postsList.clear();
      }
      final ListPostData? data =
          await _postRepository.getPost(_postPerPerson, _postDate);
      _listFollowee = data?.followees ?? [];
      if (data == null) {
        final GetListOfPostResponseMessage? data =
            await _postRepository.getRandomPost(10, 100);
        emit(state.copyWith(
            status: HomeStatus.success,
            hasReachedMax: true,
            postsList: data?.data ?? []));
      }
      // if (data!.posts.isEmpty) {
      //   final GetListOfPostResponseMessage? data =
      //       await _postRepository.getRandomPost(10, 100);
      //   emit(state.copyWith(
      //       status: HomeStatus.success,
      //       hasReachedMax: true,
      //       postsList: data?.data ?? []));
      // }
      else {
        emit(state.copyWith(
            status: HomeStatus.success,
            postsList: data.posts,
            hasReachedMax: false));
      }
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.failure, error: _.toString()));
    }
  }

  void _fetchMorePost(FetchMorePost event, Emitter<HomeState> emit) async {
    if (state.hasReachedMax && state.hasReachMaxRandom) {
      return;
    }
    if (state.hasReachedMax && !state.hasReachMaxRandom) {
      try {
        final GetListOfPostResponseMessage? data =
            await _postRepository.getMoreRandomPost(
                10, 100, state.postsList.last.dateCreate.toString());

        if (data!.statusCode == StatusCode.failStatus &&
            data.messageCode == MessageCode.noPostToDisplay) {
          emit(state.copyWith(hasReachMaxRandom: true, hasReachedMax: true));
        } else {
          final List<Post>? _newPosts = data.data;
          emit(state.copyWith(
              status: HomeStatus.success,
              hasReachedMax: true,
              postsList: [...state.postsList, ..._newPosts!],
              hasReachMaxRandom: false));
        }
      } catch (e) {
        emit(state.copyWith(status: HomeStatus.failure, error: e.toString()));
      }
    } else {
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
              hasReachedMax: false));
        }
      } catch (_) {
        emit(state.copyWith(status: HomeStatus.failure, error: _.toString()));
      }
    }
  }

  void _postAdded(PostAdded event, Emitter<HomeState> emit) async {
    try {
      List<Post> list = state.postsList;
      list.insert(0, event.post);

      emit(state.copyWith(
          status: HomeStatus.success, postsList: list, hasReachedMax: false));
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.failure, error: _.toString()));
    }
  }

  void _postUpdated(PostUpdated event, Emitter<HomeState> emit) async {
    try {
      String postId = event.postId;
      String postCaption = event.postCaption;
      int index =
          state.postsList.indexWhere((element) => element.postId == postId);
      List<Post> list = state.postsList;
      list[index].userCaption = postCaption;

      emit(state.copyWith(
          status: HomeStatus.success, postsList: list, hasReachedMax: false));
    } catch (_) {
      emit(state.copyWith(status: HomeStatus.failure, error: _.toString()));
    }
  }
}
