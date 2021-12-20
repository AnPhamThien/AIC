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
      getIt<AppPref>().setToken("");
      getIt<AppPref>().setRefreshToken("");
      getIt<AppPref>().setUserID("");
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
        //getIt<AppPref>().setToken(
        //    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9uYW1laWRlbnRpZmllciI6ImZjOWFlMDQzLTllMzItNGM4Ni05NzVmLTE2ZGQzNGMzZGFlMCIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL25hbWUiOiJzYXRrZW4yNTA5IiwiaHR0cDovL3NjaGVtYXMubWljcm9zb2Z0LmNvbS93cy8yMDA4LzA2L2lkZW50aXR5L2NsYWltcy9yb2xlIjoiVXNlciIsImh0dHA6Ly9zY2hlbWFzLnhtbHNvYXAub3JnL3dzLzIwMDUvMDUvaWRlbnRpdHkvY2xhaW1zL2VtYWlsYWRkcmVzcyI6InNhdGtlbjI1MDlAZ21haWwuY29tIiwiand0SWQiOiI0ZjBlZGRlZC0xMzljLTRmZjEtYWFiOS05NmYwOTM3ODc2YWMiLCJibG9jayI6InRydWUiLCJleHAiOjE2Mzk3MjA2OTQsImlzcyI6ImxvY2FsaG9zdDo1MDAxIiwiYXVkIjoibG9jYWxob3N0OjUwMDEifQ.r3pRVyTHV5tCzJffy6QiTtrf8GbbIUWtZoRe6zRBe74");
        getIt<AppPref>().setToken(data);
        getIt<AppPref>().setRefreshToken(refreshToken);
        //getIt<AppPref>()
        //    .setRefreshToken("4f0edded-139c-4ff1-aab9-96f0937876ac");

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
