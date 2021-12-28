import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagecaptioning/src/constanct/status_code.dart';
import 'package:imagecaptioning/src/controller/auth/form_submission_status.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/model/user/user_details.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:imagecaptioning/src/repositories/user/user_repository.dart';
import 'package:imagecaptioning/src/utils/func.dart';

part "profile_event.dart";
part "profile_state.dart";

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(bool isCurrentUser)
      : _userRepository = UserRepository(),
        super(ProfileState(isCurrentUser: isCurrentUser)) {
    on<ProfileInitializing>(_onInitial);
    on<OpenImagePicker>(_onOpenImagePicker);
    on<SaveProfileChanges>(_onSaveProfileChanges);
  }
  final UserRepository _userRepository;
  final _picker = ImagePicker();

  void _onInitial(
    ProfileInitializing event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      String userID = event.userID;
      if (userID.isEmpty) {
        if (state.isCurrentUser) {
          String token = getIt<AppPref>().getToken;
          userID = parseJwt(token)[
              "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"];
        } else {
          throw Exception("");
        }
      } else {}

      GetUserDetailsResponseMessage? userRes =
          await _userRepository.getUserDetail(userID: userID, limitPost: 5);

      if (userRes == null) {
        throw Exception("");
      }
      if (userRes.statusCode == StatusCode.successStatus &&
          userRes.data != null) {
        emit(state.copyWith(
            user: userRes.data, formStatus: FinishInitializing()));
      } else {
        throw Exception(userRes.messageCode);
      }
    } on Exception catch (_) {
      emit(state.copyWith(formStatus: FormSubmissionFailed(_)));
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
    } on Exception catch (_) {
      emit(state.copyWith(formStatus: FormSubmissionFailed(_)));
    }
  }

  void _onSaveProfileChanges(
      SaveProfileChanges event, Emitter<ProfileState> emit) async {
    try {
      String username = event.username;
      String email = event.email;
      String phone = event.phone;
      String desc = event.desc;
      String userRealName = event.userRealName;
      String avatarImg = event.avatar;

      final response = await _userRepository.updateUserProfile(
          username: username,
          email: email,
          phone: phone,
          desc: desc,
          userRealName: userRealName,
          avatarImg: avatarImg);
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
      emit(state.copyWith(formStatus: FormSubmissionFailed(_)));
    }
  }
}
