import 'package:bloc/bloc.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/model/contest/list_top_post_in_contest.dart';
import 'package:imagecaptioning/src/repositories/contest/contest_repository.dart';

part 'leaderboard_event.dart';
part 'leaderboard_state.dart';

class LeaderboardBloc extends Bloc<LeaderboardEvent, LeaderboardState> {
  LeaderboardBloc()
      : _contestRepository = ContestRepository(),
        super(LeaderboardState()) {
    on<LeaderboardInitializing>(_onInitial);
  }
  final ContestRepository _contestRepository;
  final int _limitPost = 20;

  void _onInitial(
    LeaderboardInitializing event,
    Emitter<LeaderboardState> emit,
  ) async {
    try {
      String contestId = event.contestId;

      ListTopPostInContestResponseMessage? response =
          await _contestRepository.getListTopPostInContest(contestId, _limitPost);

      if (response == null) {
        throw Exception("");
      }
      if (response.statusCode == StatusCode.successStatus &&
          response.data != null) {
        emit(state.copyWith(
            topPostInContestList: response.data,
            status: FinishInitializing()));
      } else {
        throw Exception(response.messageCode);
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }
}
