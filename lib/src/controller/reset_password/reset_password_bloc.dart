import 'package:bloc/bloc.dart';
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
      final response = await _userRepository.resetPassword(
          userId: userId, password: password);
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
