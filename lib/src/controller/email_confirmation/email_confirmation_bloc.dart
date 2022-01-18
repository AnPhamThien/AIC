import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/utils/ticker.dart';
import '../get_it/get_it.dart';
import '../../prefs/app_prefs.dart';
import '../../repositories/user/user_repository.dart';

part 'email_confirmation_event.dart';
part 'email_confirmation_state.dart';

class EmailConfirmationBloc
    extends Bloc<EmailConfirmationEvent, EmailConfirmationState> {
  EmailConfirmationBloc(String userId)
      : _userRepository = UserRepository(),
        _ticker = null,
        super(EmailConfirmationState(userId: userId)) {
    on<EmailConfirmationSubmitted>(_onSubmitted);
    on<EmailConfirmationResendButtonPushed>(_onResendButtonPushed);
  }

  final UserRepository _userRepository;
  Ticker? _ticker;
  static const int _duration = 10;

  StreamSubscription<int>? _tickerSubscription;

  void _onSubmitted(
    EmailConfirmationSubmitted event,
    Emitter<EmailConfirmationState> emit,
  ) async {
    try {
      String code = event.code;
      String userID = state.userId;
      final response = await _userRepository.validateResetPasswordCode(
          code: code, userId: userID);
      if (response == null) {
        throw Exception("");
      }
      if (response == StatusCode.successStatus) {
        emit(state.copyWith(formStatus: FormSubmissionSuccess()));
      } else {
        throw Exception(response);
      }
    } on Exception catch (_) {
      emit(state.copyWith(formStatus: ErrorStatus(_)));
    }
  }

  void _onResendButtonPushed(
    EmailConfirmationResendButtonPushed event,
    Emitter<EmailConfirmationState> emit,
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
      emit(state.copyWith(formStatus: ErrorStatus(_)));
    }
  }

  void _onStarted(TimerStarted event, Emitter<EmailConfirmationState> emit) {
    _tickerSubscription?.cancel();

    _tickerSubscription = _ticker
        ?.tick(ticks: event.duration)
        .listen((duration) => add(TimerTicked(duration: duration)));
  }

  void _onTicked(TimerTicked event, Emitter<EmailConfirmationState> emit) {}

  void _onTick(Duration duration) {}
}
