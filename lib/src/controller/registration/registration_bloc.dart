import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:crypto/crypto.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import '../get_it/get_it.dart';
import '../../model/user/user.dart';
import '../../prefs/app_prefs.dart';
import '../../repositories/user/user_repository.dart';

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

      var bytes = utf8.encode(password);
      var encodedPassword = sha256.convert(bytes).toString();
      
      String email = event.email;
      RegisterDefaultResponseMessage? response =
          await _userRepository.registerDefault(
              username: username, password: encodedPassword, email: email);
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
      emit(state.copyWith(formStatus: ErrorStatus(_)));
    }
  }
}
