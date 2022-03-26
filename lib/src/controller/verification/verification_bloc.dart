import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import '../../repositories/user/user_repository.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc(String userId)
      : _userRepository = UserRepository(),
        super(VerificationState(userId: userId)) {
    on<VerificationSubmitted>(_onSubmitted);
    on<VerificationResendButtonPushed>(_onResendButtonPushed);
    on<VerificationResendButtonRestart>(_onResendButtonRestart);
  }

  final UserRepository _userRepository;
  final timeout = const Duration(seconds: 10);

  void _onSubmitted(
    VerificationSubmitted event,
    Emitter<VerificationState> emit,
  ) async {
    try {
      String code = event.code;
      String userID = state.userId;
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
      emit(state.copyWith(formStatus: ErrorStatus(_)));
    }
  }

  void _onResendButtonPushed(
    VerificationResendButtonPushed event,
    Emitter<VerificationState> emit,
  ) async {
    try {
      emit(state.copyWith(absorbing: true));
      startTimeout();
      String userID = state.userId;
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

  Timer startTimeout() {
  var duration = timeout;
  return Timer(duration, handleTimeout);
}

void handleTimeout() { 
  add(const VerificationResendButtonRestart());
}

void _onResendButtonRestart(
    VerificationResendButtonRestart event,
    Emitter<VerificationState> emit,
  ) async {
    try {
      emit(state.copyWith(absorbing: false));
    } on Exception catch (_) {
      emit(state.copyWith(formStatus: ErrorStatus(_)));
    }
  }

}
