import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:imagecaptioning/src/constant/error_message.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:stream_transform/stream_transform.dart';

import '../../model/contest/contest.dart';
import '../../model/contest/contest_data.dart';
import '../../model/contest/contest_post_respone.dart';
import '../../model/contest/contest_respone.dart';
import '../../model/post/post.dart';
import '../../repositories/contest/contest_repository.dart';

part 'contest_event.dart';
part 'contest_state.dart';

const _limitPost = 2;

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ContestBloc extends Bloc<ContestEvent, ContestState> {
  ContestBloc() : super(const ContestState()) {
    on<InitContestFetched>(_onContestInitial,
        transformer: throttleDroppable(throttleDuration));
    on<MoreContestPostFetched>(_fetchMorePost,
        transformer: throttleDroppable(throttleDuration));
  }

  final ContestRepository _contestRepository = ContestRepository();

  void _onContestInitial(
      InitContestFetched event, Emitter<ContestState> emit) async {
    try {
      final _contest = event.contest;
      final ContestRespone _respone =
          await _contestRepository.getInitContest(_contest.id, _limitPost);
      final ContestData? _contestData = _respone.data;
      if (_respone.statusCode == StatusCode.successStatus &&
          _contestData != null) {
        emit(state.copyWith(
          status: ContestStatus.success,
          contest: _contest,
          topThreePost: _contestData.topThreePosts,
          totalParticipaters: _contestData.totalParticipaters,
          contestPrizes: _contestData.prizes,
          post: _contestData.posts,
          hasReachMax: false,
        ));
      } else {
        throw Exception(_respone.messageCode);
      }
    } catch (_) {
      emit(state.copyWith(
          status: ContestStatus.failure, contest: event.contest));
    }
  }

  void _fetchMorePost(
      MoreContestPostFetched event, Emitter<ContestState> emit) async {
    try {
      if (state.hasReachMax == true) {
        return;
      }
      if (state.post.isNotEmpty) {
        final _dateBoundary = state.post.last.dateCreate.toString();
        final _contestId = state.contest!.id;
        final ContestPostRespone _respone = await _contestRepository
            .getMoreContestPost(_contestId, _limitPost, _dateBoundary);
        final List<Post>? _morePost = _respone.data;
        if (_respone.messageCode == MessageCode.noPostToDisplay &&
            _respone.statusCode == StatusCode.failStatus) {
          emit(state.copyWith(hasReachMax: true));
        } else if (_respone.statusCode == StatusCode.successStatus &&
            _morePost != null) {
          emit(state.copyWith(
            status: ContestStatus.success,
            post: [...state.post, ..._morePost],
            hasReachMax: false,
          ));
        } else {
          throw Exception(_respone.messageCode);
        }
      }
    } catch (_) {
      log(_.toString());
      emit(state.copyWith(status: ContestStatus.failure));
    }
  }
}
