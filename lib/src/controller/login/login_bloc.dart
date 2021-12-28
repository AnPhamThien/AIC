import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:imagecaptioning/src/constanct/status_code.dart';
import 'package:imagecaptioning/src/controller/auth/form_submission_status.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/model/user/user.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:imagecaptioning/src/repositories/user/user_repository.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc()
      : _userRepository = UserRepository(),
        super(const LoginState()) {
    on<LoginSubmitted>(_onSubmitted);
  }

  final UserRepository _userRepository;

  void _onSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    try {
      String username = event.username;
      String password = event.password;

      AuthenticationResponseMessage? response =
          await _userRepository.login(username: username, password: password);

      if (response == null) {
        throw Exception("");
      }
      String data = response.data ?? "";
      String refreshToken = response.refreshToken ?? "";
      int statusCode = response.statusCode ?? 0;

      if (statusCode == StatusCode.successStatus &&
          data.isNotEmpty &&
          refreshToken.isNotEmpty) {
        getIt<AppPref>().setToken(data);
        getIt<AppPref>().setRefreshToken(refreshToken);

        emit(state.copyWith(formStatus: FormSubmissionSuccess()));
      } else {
        String messageCode = response.messageCode ?? "";
        if (data.isNotEmpty) {
          getIt<AppPref>().setUserID(data);
        }
        throw Exception(messageCode);
      }
    } on Exception catch (_) {
      emit(state.copyWith(formStatus: FormSubmissionFailed(_)));
    }
  }
}
