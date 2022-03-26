import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import '../../repositories/user/user_repository.dart';

part 'email_confirmation_event.dart';
part 'email_confirmation_state.dart';

class EmailConfirmationBloc
    extends Bloc<EmailConfirmationEvent, EmailConfirmationState> {
  EmailConfirmationBloc(String userId, String email)
      : _userRepository = UserRepository(),
        super(EmailConfirmationState(userId: userId, email: email)) {
    on<EmailConfirmationSubmitted>(_onSubmitted);
    on<EmailConfirmationResendButtonPushed>(_onResendButtonPushed);
    on<EmailConfirmationResendButtonRestart>(_onResendButtonRestart);
  }

  final UserRepository _userRepository;
  final timeout = const Duration(seconds: 10);

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
      emit(state.copyWith(absorbing: true));
      startTimeout();
      String email = state.email;
      if (email.isEmpty) {
        throw Exception();
      }
      final response =
          await _userRepository.generateResetPasswordCode(email: email);
      if (response == null) {
        throw Exception("");
      }

      int status = response.statusCode ?? 0;
      String data = response.data ?? '';

        if (status == StatusCode.successStatus && data.isNotEmpty) {
          
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
  add(const EmailConfirmationResendButtonRestart());
}

void _onResendButtonRestart(
    EmailConfirmationResendButtonRestart event,
    Emitter<EmailConfirmationState> emit,
  ) async {
    try {
      emit(state.copyWith(absorbing: false));
    } on Exception catch (_) {
      emit(state.copyWith(formStatus: ErrorStatus(_)));
    }
  }
}
