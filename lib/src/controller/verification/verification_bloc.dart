import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../constanct/status_code.dart';
import '../auth/form_submission_status.dart';
import '../get_it/get_it.dart';
import '../../prefs/app_prefs.dart';
import '../../repositories/user/user_repository.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc()
      : _userRepository = UserRepository(),
        //_ticker = Ticker(_onTick);
        super(VerificationState()) {
    on<VerificationSubmitted>(_onSubmitted);
    on<VerificationResendButtonPushed>(_onResendButtonPushed);
  }

  final UserRepository _userRepository;
  //final Ticker _ticker ;
  static const int _duration = 10;

  StreamSubscription<int>? _tickerSubscription;

  void _onSubmitted(
    VerificationSubmitted event,
    Emitter<VerificationState> emit,
  ) async {
    try {
      String code = event.code;
      String userID = getIt<AppPref>().getUserID;
      final response =
          await _userRepository.activateAccount(code: code, userID: userID);
      if (response == null) {
        throw Exception("");
      }
      if (response == StatusCode.successStatus) {
        emit(state.copyWith(formStatus: FormSubmissionSuccess()));
      } else {
        throw Exception(response);
      }
    } on Exception catch (_) {
      emit(state.copyWith(formStatus: FormSubmissionFailed(_)));
    }
  }

  void _onResendButtonPushed(
    VerificationResendButtonPushed event,
    Emitter<VerificationState> emit,
  ) async {
    try {
      String userID = getIt<AppPref>().getUserID;
      final response =
          await _userRepository.regenerateCodeForRegister(userID: userID);
      if (response == null) {
        throw Exception("");
      }
      if (response is int) {
        if (response == StatusCode.successStatus) {
          //emit(state.copyWith(absorbing: true));
        } else {
          throw Exception("");
        }
      } else {
        throw Exception(response);
      }
    } on Exception catch (_) {
      emit(state.copyWith(formStatus: FormSubmissionFailed(_)));
    }
  }

  void _onStarted(TimerStarted event, Emitter<VerificationState> emit) {
    _tickerSubscription?.cancel();
    //_ticker.start();

    //_tickerSubscription = _ticker.tick(ticks: event.duration)
    //   .listen((duration) => add(TimerTicked(duration: duration)));
  }

  void _onTicked(TimerTicked event, Emitter<VerificationState> emit) {}

  void _onTick(Duration duration) {}
}
