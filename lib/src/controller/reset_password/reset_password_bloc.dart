import 'package:bloc/bloc.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import '../get_it/get_it.dart';
import '../../model/user/user.dart';
import '../../prefs/app_prefs.dart';
import '../../repositories/user/user_repository.dart';

part 'reset_password_event.dart';
part 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc()
      : _userRepository = UserRepository(),
        super(ResetPasswordState()) {
    on<ResetPasswordSubmitted>(_onSubmitted);
  }

  final UserRepository _userRepository;

  void _onSubmitted(
    ResetPasswordSubmitted event,
    Emitter<ResetPasswordState> emit,
  ) async {
    try {
      String userId = getIt<AppPref>().getUserID;
      String password = event.password;
      RegisterDefaultResponseMessage? response = await _userRepository
          .resetPassword(userId: userId, password: password);
      if (response == null) {
        throw Exception("");
      }
      int status = response.statusCode ?? 0;
      if (status == StatusCode.successStatus) {
        emit(state.copyWith(formStatus: FormSubmissionSuccess()));
      } else {
        String message = response.messageCode ?? "";
        throw Exception(message);
      }
    } on Exception catch (_) {
      emit(state.copyWith(formStatus: ErrorStatus(_)));
    }
  }
}
