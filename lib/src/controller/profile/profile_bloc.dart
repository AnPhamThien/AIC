import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/animation.dart';
import 'package:imagecaptioning/src/constant/error_message.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/model/post/list_of_post_respone.dart';
import 'package:imagecaptioning/src/model/post/post.dart';
import 'package:imagecaptioning/src/model/user/user_details.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:imagecaptioning/src/repositories/follow/follow_repository.dart';
import 'package:imagecaptioning/src/repositories/post/post_repository.dart';
import 'package:imagecaptioning/src/repositories/user/user_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part "profile_event.dart";
part "profile_state.dart";

const throttleDuration = Duration(milliseconds: 10);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(bool isCurrentUser, bool needLeadBack)
      : _userRepository = UserRepository(),
        _followRepository = FollowRepository(),
        _postRepository = PostRepository(),
        super(ProfileState(
            isCurrentUser: isCurrentUser, needLeadBack: needLeadBack)) {
    on<ProfileInitializing>(_onInitial,
        transformer: throttleDroppable(throttleDuration));
    on<ProfileChangeFollowUser>(_onChangeFollowStatusUser);
    on<ProfileFetchMorePost>(_onFetchMorePost,
        transformer: throttleDroppable(throttleDuration));
    on<ProfileFetchMoreSavedPost>(_onFetchMoreSavedPost,
        transformer: throttleDroppable(throttleDuration));
  }
  final UserRepository _userRepository;
  final PostRepository _postRepository;
  final FollowRepository _followRepository;

  void _onInitial(
    ProfileInitializing event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      String userID = event.userID;
      if (userID.isEmpty) {
        if (state.isCurrentUser) {
          userID = getIt<AppPref>().getUserID;
        } else {
          throw Exception("");
        }
      }

      GetUserDetailsResponseMessage? userRes =
          await _userRepository.getUserDetail(userID: userID, limitPost: 9);

      if (userRes == null) {
        throw Exception("");
      }
      if (userRes.statusCode == StatusCode.successStatus &&
          userRes.data != null) {
        if (state.user?.posts != null) {
          state.user?.posts?.clear();
        }

        List<Post>? galleryPostList;

        if (state.isCurrentUser) {
          GetListOfPostResponseMessage? savedPostResponse =
              await _postRepository.getPostStorage(limitPost: 9);
          if (savedPostResponse == null) {
            throw Exception("");
          }
          if (savedPostResponse.statusCode == StatusCode.successStatus &&
              savedPostResponse.data != null) {
            if (state.galleryPostList != null) {
              state.galleryPostList?.clear();
            }
            galleryPostList = savedPostResponse.data;
          }
        }
        emit(state.copyWith(
            user: userRes.data,
            galleryPostList: galleryPostList,
            isFollow: (userRes.data?.isFollow == 1),
            postListPage: 1,
            galleryPostListPage: 1,
            status: FinishInitializing()));
      } else {
        throw Exception(userRes.messageCode);
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }

  void _onFetchMorePost(
      ProfileFetchMorePost event, Emitter<ProfileState> emit) async {
    if (state.hasReachedMax) {
      return;
    }
    try {
      if (state.user?.posts == null) {
        throw Exception();
      }
      final data = await _postRepository.getMoreUserPost(
          userID: getIt<AppPref>().getUserID,
          limitPost: 9,
          dateBoundary: state.user!.posts!.last.dateCreate.toString());
      if (data == null) {
        throw Exception();
      } else if (data.messageCode == MessageCode.noPostToDisplay) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        UserDetails? user = state.user;
        user?.posts?.addAll(data.data!);
        emit(state.copyWith(
            status: FinishInitializing(), user: user, hasReachedMax: false));
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }

  void _onFetchMoreSavedPost(
      ProfileFetchMoreSavedPost event, Emitter<ProfileState> emit) async {
    if (state.hasReachedMax) {
      return;
    }
    try {
      int page = state.galleryPostListPage;
      if (state.user?.posts == null) {
        throw Exception();
      }
      final data = await _postRepository.getMorePostStorage(
          limitPost: 9, currentPage: page + 1);
      if (data == null) {
        throw Exception();
      }

      if (data.messageCode == MessageCode.noPostToDisplay) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        List<Post> savedPostList = state.galleryPostList ?? [];
        savedPostList.addAll(data.data!);
        emit(state.copyWith(
            status: FinishInitializing(),
            galleryPostList: savedPostList,
            hasReachedMax: false,
            galleryPostListPage: page + 1));
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }

  void _onChangeFollowStatusUser(
    ProfileChangeFollowUser event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      String followeeId = event.followeeID;

      if (!state.isCurrentUser) {
        dynamic resMessage;
        if (!state.isFollow) {
          resMessage =
              await _followRepository.addFollow(followeeId: followeeId);
        } else {
          resMessage =
              await _followRepository.deleteFollow(followeeId: followeeId);
        }

        if (resMessage == null) {
          throw Exception("");
        }
        if (resMessage is int) {
          if (resMessage == StatusCode.successStatus) {
            emit(state.copyWith(
                isFollow: !state.isFollow, status: FinishInitializing()));
          } else {
            throw Exception("");
          }
        } else {
          throw Exception(resMessage);
        }
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }
}
