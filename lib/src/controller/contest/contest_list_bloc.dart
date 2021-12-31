import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:imagecaptioning/src/model/contest/contest.dart';
import 'package:imagecaptioning/src/repositories/contest/contest_repository.dart';
import 'package:stream_transform/stream_transform.dart';

part 'contest_list_event.dart';
part 'contest_list_state.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

const _limitContest = 5;

class ContestListBloc extends Bloc<ContestListEvent, ContestListState> {
  ContestListBloc() : super(const ContestListState()) {
    on<InitContestFetched>(_onContestFetched);
    //on<FetchMoreContest>(_fetchMorePost);
  }

  final ContestRepository _contestRepository = ContestRepository();
  void _onContestFetched(
      InitContestFetched event, Emitter<ContestListState> emit) async {
    try {
      if (state.status == ContestListStatus.initial) {
        final List<Contest>? contestList =
            await _contestRepository.getContest(_limitContest);
        return emit(state.copyWith(
          status: ContestListStatus.success,
          onGoingContestList: contestList,
          hasReachedMax: false,
        ));
      }
    } catch (_) {
      emit(state.copyWith(status: ContestListStatus.failure));
    }
  }

  // void _fetchMorePost(FetchMoreContest event, Emitter<ContestListState> emit) async {
  //   if (state.hasReachedMax) {
  //     emit(state.copyWith(status: ContestListStatus.maxcontest));
  //     return;
  //   }
  //   try {
  //     final Data? data = await _postRepository.getMorePost(PostListRequest(
  //         postPerPerson: _postPerPerson,
  //         limitDay: _postDate,
  //         listFollowees: _listFollowee));
  //     final List<Post>? posts = data?.posts ?? [];
  //     if (posts!.isEmpty) {
  //       emit(state.copyWith(hasReachedMax: true));
  //     } else {
  //       _listFollowee = data?.followees ?? [];
  //       emit(state.copyWith(
  //         status: ContestListStatus.success,
  //         contestsList: List.of(state.contestList)..addAll(posts),
  //         hasReachedMax: false,
  //       ));
  //     }
  //   } catch (_) {
  //     emit(state.copyWith(status: ContestListStatus.failure));
  //   }
  // }
}
