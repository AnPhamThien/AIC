import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import '../../model/contest/contest.dart';
import '../../repositories/contest/contest_repository.dart';
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
    on<InitContestFetched>(
      _onContestFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    //on<FetchMoreContest>(_fetchMorePost);
  }

  final ContestRepository _contestRepository = ContestRepository();
  void _onContestFetched(
      InitContestFetched event, Emitter<ContestListState> emit) async {
    try {
      if (state.status == ContestListStatus.initial) {
        final List<Contest>? _activeContestList =
            await _contestRepository.getActiveContestList(_limitContest);
        final List<Contest>? _inactiveContestList =
            await _contestRepository.getInactiveContestList(_limitContest);
        return emit(state.copyWith(
          status: ContestListStatus.success,
          activeContestList: _activeContestList,
          inactiveContestList: _inactiveContestList,
          hasReachedMax: false,
        ));
      }
    } catch (_) {
      emit(state.copyWith(status: ContestListStatus.failure));
    }
  }

  void _fetchMorePost(
      FetchMoreContest event, Emitter<ContestListState> emit) async {
    // if (state.hasReachedMax) {
    //   emit(state.copyWith(status: ContestListStatus.maxcontest));
    //   return;
    // }
    try {
      if (event.indexTab == 0) {
        //TODO fetch more contest active
      } else {
        //TODO fetch more contest inactive
      }
      // final Data? data = await _postRepository.getMorePost(PostListRequest(
      //     postPerPerson: _postPerPerson,
      //     limitDay: _postDate,
      //     listFollowees: _listFollowee));
      // final List<Post>? posts = data?.posts ?? [];
      // if (posts!.isEmpty) {
      //   emit(state.copyWith(hasReachedMax: true));
      // } else {
      //   _listFollowee = data?.followees ?? [];
      //   emit(state.copyWith(
      //     status: ContestListStatus.success,
      //     contestsList: List.of(state.contestList)..addAll(posts),
      //     hasReachedMax: false,
      //   ));
      // }
    } catch (_) {
      emit(state.copyWith(status: ContestListStatus.failure));
    }
  }
}
