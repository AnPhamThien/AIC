
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

const _limitContest = 9;

class ContestListBloc extends Bloc<ContestListEvent, ContestListState> {
  ContestListBloc() : super(const ContestListState()) {
    on<InitContestFetched>(
      _onContestFetched,
      transformer: throttleDroppable(throttleDuration),
    );
    on<FetchMoreContest>(
      _fetchMorePost,
      transformer: throttleDroppable(throttleDuration),
    );
    on<InitSearchContestFetched>(
      _onSearchContestFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final ContestRepository _contestRepository = ContestRepository();
  void _onContestFetched(
      InitContestFetched event, Emitter<ContestListState> emit) async {
    try {
      final List<Contest>? _activeContestList = await _contestRepository
          .getActiveContestList('', _limitContest, '', '');
      final List<Contest>? _inactiveContestList = await _contestRepository
          .getInactiveContestList('', _limitContest, '', '');
      return emit(state.copyWith(
        status: ContestListStatus.success,
        activeContestList: _activeContestList,
        inactiveContestList: _inactiveContestList,
        hasReachMaxActive: false,
        hasReachMaxInactive: false,
      ));
    } catch (_) {
      emit(state.copyWith(status: ContestListStatus.failure));
    }
  }

  void _fetchMorePost(
      FetchMoreContest event, Emitter<ContestListState> emit) async {
    try {
      if (event.indexTab == 0) {
        if (state.hasReachMaxActive == true) {
          return;
        }
        final _dateBoundary =
            state.activeContestList.last.dateCreate.toString();
        final List<Contest>? _moreActiveContestList =
            await _contestRepository.getMoreActiveContestList(event.searchName,
                _limitContest, _dateBoundary, event.dateUp, event.dateDown);
        if (_moreActiveContestList == null) {
          emit(state.copyWith(hasReachMaxActive: true));
        } else {
          emit(state.copyWith(
              status: ContestListStatus.success,
              activeContestList: [
                ...state.activeContestList,
                ..._moreActiveContestList
              ],
              hasReachMaxActive: false));
        }
      } else {
        if (state.hasReachMaxInactive == true) {
          return;
        }
        final _dateBoundary =
            state.inactiveContestList.last.dateCreate.toString();
        final List<Contest>? _moreInactiveContestList =
            await _contestRepository.getMoreInactiveContestList(
                event.searchName,
                _limitContest,
                _dateBoundary,
                event.dateUp,
                event.dateDown);
        if (_moreInactiveContestList == null) {
          emit(state.copyWith(hasReachMaxInactive: true));
        } else {
          emit(state.copyWith(
              status: ContestListStatus.success,
              inactiveContestList: [
                ...state.inactiveContestList,
                ..._moreInactiveContestList
              ],
              hasReachMaxInactive: false));
        }
      }
    } catch (_) {
      emit(state.copyWith(status: ContestListStatus.failure));
    }
  }

  void _onSearchContestFetched(
      InitSearchContestFetched event, Emitter<ContestListState> emit) async {
    try {
      final _searchName = event.searchName;
      final _dateUp = event.dateUp;
      final _dateDown = event.dateDown;
      final List<Contest>? _activeContestList = await _contestRepository
          .getActiveContestList(_searchName, _limitContest, _dateUp, _dateDown);
      final List<Contest>? _inactiveContestList =
          await _contestRepository.getInactiveContestList(
              _searchName, _limitContest, _dateUp, _dateDown);

      return emit(state.copyWith(
        status: ContestListStatus.success,
        activeContestList: _activeContestList ?? [],
        inactiveContestList: _inactiveContestList ?? [],
        hasReachMaxActive: false,
        hasReachMaxInactive: false,
      ));
    } catch (_) {
      emit(state.copyWith(status: ContestListStatus.failure));
    }
  }
}
