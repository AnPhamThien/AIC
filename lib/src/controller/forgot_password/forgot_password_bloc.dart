import 'package:bloc/bloc.dart';
import 'package:imagecaptioning/src/constanct/error_message.dart';
import 'package:imagecaptioning/src/controller/auth/form_submission_status.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:imagecaptioning/src/repositories/user/user_repository.dart';

part 'forgot_password_event.dart';
part 'forgot_password_state.dart';

class ForgotPasswordBloc
    extends Bloc<ForgotPasswordEvent, ForgotPasswordState> {
  ForgotPasswordBloc()
      : _userRepository = UserRepository(),
        super(const ForgotPasswordState()) {
    on<ForgotPasswordSubmitted>(_onSubmitted);
  }

  final UserRepository _userRepository;

  void _onSubmitted(
    ForgotPasswordSubmitted event,
    Emitter<ForgotPasswordState> emit,
  ) async {
    try {
      String email = event.email;

      final response =
          await _userRepository.regenerateResetPasswordCode(email: email);
      if (response is String) {
        String error = MessageCode.errorMap[response] ?? "Something went wrong";
        throw Exception(error);
      }
      emit(state.copyWith(formStatus: FormSubmissionSuccess()));
    } on Exception catch (_) {
      emit(state.copyWith(formStatus: FormSubmissionFailed(_)));
    }
  }
}
