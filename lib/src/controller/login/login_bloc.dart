import 'package:bloc/bloc.dart';
import '../../constanct/status_code.dart';
import '../auth/form_submission_status.dart';
import '../get_it/get_it.dart';
import '../../model/user/user.dart';
import '../../prefs/app_prefs.dart';
import '../../repositories/user/user_repository.dart';
import '../../utils/func.dart';

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
      emit(state.copyWith(formStatus: FormSubmitting()));
      // await Future.delayed(const Duration(seconds: 3));
      String username = event.username;
      String password = event.password;

      AuthenticationResponseMessage? response =
          await _userRepository.login(username: username, password: password);

      if (response == null) {
        throw Exception("");
      }
      String data = response.data ?? "";
      User? user = response.user;
      String refreshToken = response.refreshToken ?? "";
      int statusCode = response.statusCode ?? 0;

      if (statusCode == StatusCode.successStatus &&
          data.isNotEmpty &&
          refreshToken.isNotEmpty &&
          user != null) {
        getIt<AppPref>().setToken(data);
        getIt<AppPref>().setRefreshToken(refreshToken);
        getIt<AppPref>().setUsername(parseJwt(data)[
            "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"]);
        getIt<AppPref>().setUserID(parseJwt(data)[
            "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"]);

        emit(state.copyWith(formStatus: FormSubmissionSuccess(), user: user));
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
