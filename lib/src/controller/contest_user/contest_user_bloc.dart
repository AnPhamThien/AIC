import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:imagecaptioning/src/constant/error_message.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/model/contest/user_in_contest_respone.dart';
import 'package:imagecaptioning/src/model/post/post.dart';
import 'package:imagecaptioning/src/model/post/post_detail_respone.dart';
import 'package:imagecaptioning/src/repositories/contest/contest_repository.dart';
import '../../model/contest/user_in_contest_data.dart';
import 'package:stream_transform/stream_transform.dart';
part 'contest_user_event.dart';
part 'contest_user_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

const _paging = 10;

class ContestUserBloc extends Bloc<ContestUserEvent, ContestUserState> {
  ContestUserBloc() : super(const ContestUserState()) {
    on<InitContestUserFetched>(_onInitContestUserFetched,
        transformer: throttleDroppable(throttleDuration));
    on<PostFromUserFetched>(_onPostFetchedFromUser);
    on<SearchContestUserFetched>(_onSearchContestUserFetched);
    on<NavigatedToPost>(_navigatedToPost);
  }

  final ContestRepository _contestRepository = ContestRepository();
  late String _contestId;

  void _onInitContestUserFetched(
      InitContestUserFetched event, Emitter<ContestUserState> emit) async {
    try {
      _contestId = event.contestId;
      final UserInContestRespone _respone =
          await _contestRepository.getUserInContest(_contestId, _paging);
      final List<UserInContestData>? _userInContestData = _respone.data;
      if (_respone.statusCode == StatusCode.successStatus &&
          _userInContestData != null) {
        emit(state.copyWith(
            status: ContestUserStatus.success,
            userInContest: _userInContestData,
            hasReachMax: false));
      } else {
        throw Exception(_respone.messageCode);
      }
    } catch (_) {
      log(_.toString());
      emit(state.copyWith(status: ContestUserStatus.failure));
    }
  }

  void _onSearchContestUserFetched(
      SearchContestUserFetched event, Emitter<ContestUserState> emit) async {
    try {
      final _searchName = event.searchName;
      if (_searchName == '') {
        emit(state.copyWith(
            status: ContestUserStatus.success, searchUserInContest: []));
      } else {
        final UserInContestRespone _respone = await _contestRepository
            .getSearchUserInContest(_contestId, _paging, _searchName);
        final List<UserInContestData>? _searchedUserInContest = _respone.data;
        if (_respone.statusCode == StatusCode.successStatus &&
            _searchedUserInContest != null) {
          emit(state.copyWith(
              status: ContestUserStatus.success,
              searchUserInContest: _searchedUserInContest,
              searchName: _searchName,
              hasReachMax: false));
        } else if (_respone.messageCode ==
            MessageCode.contestHasNoParticipater) {
          emit(state.copyWith(
              status: ContestUserStatus.success, searchUserInContest: []));
        } else {
          throw Exception(_respone.messageCode);
        }
      }
    } catch (_) {
      log(_.toString());
      emit(state.copyWith(status: ContestUserStatus.failure));
    }
  }

  void _onPostFetchedFromUser(
      PostFromUserFetched event, Emitter<ContestUserState> emit) async {
    try {
      final _postId = event.postId;
      final PostDetailRespone _respone =
          await _contestRepository.getPostDetail(_postId, _contestId);
      if (_respone.statusCode == StatusCode.successStatus &&
          _respone.data != null) {
        emit(state.copyWith(
            status: ContestUserStatus.postfetched, post: _respone.data));
      }
    } catch (_) {
      log(_.toString());
      emit(state.copyWith(status: ContestUserStatus.failure));
    }
  }

  void _navigatedToPost(
      NavigatedToPost event, Emitter<ContestUserState> emit) async {
    try {
      if (state.status == ContestUserStatus.success) {
        return;
      }
      emit(state.copyWith(status: ContestUserStatus.success));
    } catch (_) {
      log(_.toString());
      emit(state.copyWith(status: ContestUserStatus.failure));
    }
  }
}
