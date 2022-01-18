import 'package:bloc/bloc.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import '../../repositories/user/user_repository.dart';

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
          await _userRepository.generateResetPasswordCode(email: email);
      if (response == null) {
        throw Exception('');
      }

      int status = response.statusCode ?? 0;
      String data = response.data ?? '';

      if (status == StatusCode.successStatus && data.isNotEmpty) {
        emit(state.copyWith(formStatus: FormSubmissionSuccess(), userId: data));
      } else {
        String message = response.messageCode ?? "";
        throw Exception(message);
      }
    } on Exception catch (_) {
      emit(state.copyWith(formStatus: ErrorStatus(_)));
    }
  }
}
