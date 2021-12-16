import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagecaptioning/src/controller/auth/form_submission_status.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/model/user/user_details.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:imagecaptioning/src/repositories/user/user_repository.dart';
import 'package:imagecaptioning/src/utils/func.dart';

part "profile_event.dart";
part "profile_state.dart";

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc()
      : _userRepository = UserRepository(),
        super(ProfileState()) {
    on<Initializing>(_onInitial);
    on<OpenImagePicker>(_onOpenImagePicker);
  }
  final UserRepository _userRepository;
  final _picker = ImagePicker();

  void _onInitial(
    Initializing event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      String token = getIt<AppPref>().getToken;
      print(token);
      print(parseJwt(token));
      String userID = parseJwt(token)[
          "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"];
      print(userID);

      UserDetails? user =
          await _userRepository.getUserDetail(userID: userID, limitPost: 5);

      emit(state.copyWith(
          user: user, isCurrentUser: true, formStatus: FinishInitializing()));
    } on Exception catch (_) {
      emit(state.copyWith(formStatus: FormSubmissionFailed(_)));
    } catch (_) {
      print(_);
    }
  }

  void _onOpenImagePicker(
      OpenImagePicker event, Emitter<ProfileState> emit) async {
    try {
      emit(state.copyWith(imageSourceActionSheetIsVisible: false));
      final pickedImage = await _picker.pickImage(source: event.imageSource);
      if (pickedImage == null) return;

      //final imageKey = await storageRepo.uploadFile(File(pickedImage.path));

      final updatedUser =
          state.user!.copyWith(avataUrl: File(pickedImage.path));

      emit(state.copyWith(user: updatedUser));
    } on Exception catch (_) {}
  }
}
