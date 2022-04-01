import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import '../../repositories/user/user_repository.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc(String userId)
      : _userRepository = UserRepository(),
        super(ResetPasswordState(userId: userId)) {
    on<ResetPasswordSubmitted>(_onSubmitted);
  }

  final UserRepository _userRepository;

  void _onSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    try {
      String userId = state.userId;
      String password = event.password;

      var bytes = utf8.encode(password);
      var encodedPassword = sha256.convert(bytes).toString();

      final response = await _userRepository.resetPassword(
          userId: userId, password: encodedPassword);
      if (response == null) {
        throw Exception("");
      }

      if (response is int) {
        if (response == StatusCode.successStatus) {
          emit(state.copyWith(formStatus: FormSubmissionSuccess()));
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
}
