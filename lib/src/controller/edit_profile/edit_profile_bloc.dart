import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/model/user/user_details.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:imagecaptioning/src/repositories/user/user_repository.dart';

part 'edit_profile_event.dart';
part 'edit_profile_state.dart';

class EditProfileBloc extends Bloc<EditProfileEvent, EditProfileState> {
  EditProfileBloc()
      : _userRepository = UserRepository(),
        super(EditProfileState()) {
    on<EditProfileInitializing>(_onInitial);
    on<ChangeAvatar>(_onChangeAvatar);
    on<SaveProfileChanges>(_onSaveProfileChanges);
  }
  final UserRepository _userRepository;

  void _onInitial(
    EditProfileInitializing event,
    Emitter<EditProfileState> emit,
  ) async {
    try {
      String userID = getIt<AppPref>().getUserID;

      GetUserDetailsResponseMessage? userRes =
          await _userRepository.getUserDetail(userID: userID, limitPost: 1);

      if (userRes == null) {
        throw Exception("");
      }
      if (userRes.statusCode == StatusCode.successStatus &&
          userRes.data != null) {
        final avatar = userRes.data?.avataUrl ?? '';
        emit(state.copyWith(
            user: userRes.data,
            avatarPath: avatar,
            status: FinishInitializing()));
      } else {
        throw Exception(userRes.messageCode);
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }

  // void _onOpenImagePicker(
  //     OpenImagePicker event, Emitter<ProfileState> emit) async {
  //   try {
  //     emit(state.copyWith(imageSourceActionSheetIsVisible: false));
  //     final pickedImage = await _picker.pickImage(source: event.imageSource);
  //     if (pickedImage == null) return;

  //     //final imageKey = await storageRepo.uploadFile(File(pickedImage.path));

  //     final updatedUser =
  //         state.user!.copyWith(avataUrl: File(pickedImage.path));

  //     emit(state.copyWith(user: updatedUser));
  //   } on Exception catch (_) {
  //     emit(state.copyWith(status: ErrorStatus(_)));
  //   }
  // }

  void _onChangeAvatar(
      ChangeAvatar event, Emitter<EditProfileState> emit) async {
    try {
      String avatarImg = event.avatarPath;

      if (avatarImg.isNotEmpty) {
        emit(state.copyWith(avatarPath: avatarImg, avatarChanged: true));
      } else {
        throw Exception();
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }

  void _onSaveProfileChanges(
      SaveProfileChanges event, Emitter<EditProfileState> emit) async {
    try {
      String username = event.username.trim();
      String email = event.email.trim();
      String phone = event.phone.trim();
      String desc = event.desc.trim();
      String userRealName = event.userRealName.trim();
      String avatarImg = event.avatar;

      final response = await _userRepository.updateUserProfile(
          username: username,
          email: email,
          phone: phone.isNotEmpty ? phone : null,
          desc: desc.isNotEmpty ? desc : null,
          userRealName: userRealName.isNotEmpty ? userRealName : null,
          avatarImg: state.avatarChanged ? File(avatarImg) : null);
      if (response == null) {
        throw Exception("");
      }
      if (response is int) {
        if (response == StatusCode.successStatus) {
          emit(state.copyWith(status: EditProfileSuccess()));
        } else {
          throw Exception("");
        }
      } else {
        throw Exception(response);
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }
}
