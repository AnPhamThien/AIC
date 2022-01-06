import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:imagecaptioning/src/constanct/status_code.dart';
import 'package:imagecaptioning/src/model/contest/contest.dart';
import 'package:imagecaptioning/src/model/contest/contest_data.dart';
import 'package:imagecaptioning/src/model/contest/contest_respone.dart';
import 'package:imagecaptioning/src/model/post/post.dart';
import 'package:imagecaptioning/src/repositories/contest/contest_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'contest_event.dart';
part 'contest_state.dart';

const _limitPost = 2;

const throttleDuration = Duration(milliseconds: 10);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class ContestBloc extends Bloc<ContestEvent, ContestState> {
  ContestBloc() : super(const ContestState()) {
    on<InitContestFetched>(_onContestInitial);
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
        throw Exception();
      }
    } catch (_) {
      emit(state.copyWith(
          status: ContestStatus.failure, contest: event.contest));
    }
  }
}
