import 'package:bloc/bloc.dart';
import 'package:imagecaptioning/src/constanct/error_message.dart';
import 'package:imagecaptioning/src/constanct/status_code.dart';
import 'package:imagecaptioning/src/controller/auth/form_submission_status.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/model/user/user.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:imagecaptioning/src/repositories/user/user_repository.dart';

part 'registration_event.dart';
part 'registration_state.dart';

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc()
      : _userRepository = UserRepository(),
        super(RegistrationState()) {
    on<RegistrationSubmitted>(_onSubmitted);
  }

  final UserRepository _userRepository;

  void _onSubmitted(
    RegistrationSubmitted event,
    Emitter<RegistrationState> emit,
  ) async {
    try {
      String username = event.username;
      String password = event.password;
      String email = event.email;
      RegisterDefaultResponseMessage? response =
          await _userRepository.registerDefault(
              username: username, password: password, email: email);
      if (response == null) {
        throw Exception("");
      }
      int status = response.statusCode ?? 0;
      String userID = response.data ?? "";
      if (status == StatusCode.successStatus && userID.isNotEmpty) {
        getIt<AppPref>().setUserID(userID);
        emit(state.copyWith(formStatus: FormSubmissionSuccess()));
      } else {
        String message = response.messageCode ?? "";
        throw Exception(message);
      }
    } on Exception catch (_) {
      emit(state.copyWith(formStatus: FormSubmissionFailed(_)));
    }
  }
}
