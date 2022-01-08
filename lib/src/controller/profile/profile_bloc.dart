import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import '../get_it/get_it.dart';
import '../../model/user/user_details.dart';
import '../../prefs/app_prefs.dart';
import '../../repositories/user/user_repository.dart';

part "profile_event.dart";
part "profile_state.dart";

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(bool isCurrentUser)
      : _userRepository = UserRepository(),
        super(ProfileState(isCurrentUser: isCurrentUser)) {
    on<ProfileInitializing>(_onInitial);
  }
  final UserRepository _userRepository;

  void _onInitial(
    ProfileInitializing event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      String userID = event.userID;
      if (userID.isEmpty) {
        if (state.isCurrentUser) {
          userID = getIt<AppPref>().getUserID;
        } else {
          throw Exception("");
        }
      }

      GetUserDetailsResponseMessage? userRes =
          await _userRepository.getUserDetail(userID: userID, limitPost: 5);

      if (userRes == null) {
        throw Exception("");
      }
      if (userRes.statusCode == StatusCode.successStatus &&
          userRes.data != null) {
        emit(state.copyWith(user: userRes.data, status: FinishInitializing()));
      } else {
        throw Exception(userRes.messageCode);
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }
}
