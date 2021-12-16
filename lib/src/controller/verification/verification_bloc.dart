import 'package:bloc/bloc.dart';
import 'package:imagecaptioning/src/constanct/status_code.dart';
import 'package:imagecaptioning/src/controller/auth/form_submission_status.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:imagecaptioning/src/repositories/user/user_repository.dart';

part 'verification_event.dart';
part 'verification_state.dart';

class VerificationBloc extends Bloc<VerificationEvent, VerificationState> {
  VerificationBloc()
      : _userRepository = UserRepository(),
        super(const VerificationState()) {
    on<VerificationSubmitted>(_onSubmitted);
    on<VerificationResendButtonPushed>(_onResendButtonPushed);
  }

  final UserRepository _userRepository;

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
          emit(state.copyWith(formStatus: FormSubmissionSuccess()));
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
}
