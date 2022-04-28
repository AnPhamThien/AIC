import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
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
    on<ProfileFetchMoreGalleryPost>(_onFetchMoreGalleryPost,
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
          await _userRepository.getUserDetail(userID: userID, limitPost: 18);

      if (userRes == null) {
        throw Exception("");
      }
      if (userRes.statusCode == StatusCode.successStatus &&
          userRes.data != null) {
        if (state.userPostList != null) {
          state.userPostList?.clear();
        }

        List<Post>? galleryPostList;
        if (state.galleryPostList != null) {
              state.galleryPostList?.clear();
        }
        if (state.isCurrentUser) {
          GetListOfPostResponseMessage? savedPostResponse =
              await _postRepository.getPostStorage(limitPost: 20);
          if (savedPostResponse == null) {
            throw Exception("savedPostResponse is null");
          }
          if (savedPostResponse.statusCode == StatusCode.successStatus &&
              savedPostResponse.data != null) {
            galleryPostList = savedPostResponse.data;
          }
        } else {
          GetListOfPostResponseMessage? contestPostResponse =
              await _postRepository.getUserContestPost(
                  userID: userID, limitPost: 20);
          if (contestPostResponse == null) {
            throw Exception("contestPostResponse is null");
          }
          if (contestPostResponse.statusCode == StatusCode.successStatus &&
              contestPostResponse.data != null) {
            galleryPostList = contestPostResponse.data;
          }
        }
        emit(state.copyWith(
            user: userRes.data,
            galleryPostList: galleryPostList ?? [],
            isFollow: (userRes.data?.isFollow == 1),
            postListPage: 1,
            galleryPostListPage: 1,
            userPostList: userRes.data?.posts,
            status: FinishInitializing()));
      } else {
        throw Exception(userRes.messageCode);
      }
    } on Exception catch (_) {
      log("Init Profile failed: " + _.toString());
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }

  void _onFetchMorePost(
      ProfileFetchMorePost event, Emitter<ProfileState> emit) async {
    if (state.hasReachedMax) {
      return;
    }
    try {
      List<Post>? list = state.userPostList;
      if (list == null) {
        throw Exception();
      }
      final data = await _postRepository.getMoreUserPost(
          userID: state.user!.id!,
          limitPost: 6,
          dateBoundary: list.last.dateCreate.toString());
      if (data == null) {
        throw Exception();
      } else if (data.messageCode == MessageCode.noPostToDisplay) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        //data.data!.insertAll(0, list);
        // list.addAll(data.data!);
        emit(state.copyWith(
            status: FinishInitializing(), userPostList: [...state.userPostList!, ...data.data!], hasReachedMax: false));
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }

  void _onFetchMoreGalleryPost(
      ProfileFetchMoreGalleryPost event, Emitter<ProfileState> emit) async {
    if (state.galleryPostHasReachedMax) {
      return;
    }
    try {
      int page = 0;
      if (state.galleryPostList == null) {
        throw Exception();
      }
      GetListOfPostResponseMessage? data;

      if (state.isCurrentUser) {
        page = state.galleryPostListPage;
        data = await _postRepository.getMorePostStorage(
            limitPost: 6, currentPage: page + 1);
      } else {
        if (state.user?.id == null) {
          throw Exception("");
        }
        if (state.galleryPostList!.isEmpty) {
          emit(state.copyWith(galleryPostHasReachedMax: true));
          return;
        }
        data = await _postRepository.getMoreUserContestPost(
            userID: state.user!.id!,
            limitPost: 6,
            dateBoundary: state.galleryPostList!.last.dateCreate.toString());
      }

      if (data == null) {
        throw Exception();
      }

      if (data.messageCode == MessageCode.noPostToDisplay) {
        emit(state.copyWith(hasReachedMax: true));
      } else {
        emit(state.copyWith(
            status: FinishInitializing(),
            galleryPostList: [...state.galleryPostList!, ...data.data!],
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
            add(ProfileInitializing(followeeId));
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
