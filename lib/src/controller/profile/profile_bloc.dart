import 'package:bloc/bloc.dart';
import 'package:imagecaptioning/src/constant/status_code.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/model/user/user_details.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:imagecaptioning/src/repositories/follow/follow_repository.dart';
import 'package:imagecaptioning/src/repositories/user/user_repository.dart';

part "profile_event.dart";
part "profile_state.dart";

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc(bool isCurrentUser)
      : _userRepository = UserRepository(),
        _followRepository = FollowRepository(),
        super(ProfileState(isCurrentUser: isCurrentUser)) {
    on<ProfileInitializing>(_onInitial);
    on<ProfileChangeFollowUser>(_onChangeFollowStatusUser);
  }
  final UserRepository _userRepository;
  final FollowRepository _followRepository;

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
        emit(state.copyWith(
            user: userRes.data,
            isFollow: (userRes.data?.isFollow == 1),
            status: FinishInitializing()));
      } else {
        throw Exception(userRes.messageCode);
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }

  void _onChangeFollowStatusUser(
    ProfileChangeFollowUser event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      String followeeId = event.followeeID;

      if (!state.isCurrentUser) {
        final resMessage;
        if (!state.isFollow) {
          resMessage =
              await _followRepository.addFollow(followeeId: followeeId);
        } else {
          resMessage =
              await _followRepository.deleteFollow(followeeId: followeeId);
        }

        if (resMessage == null) {
          throw Exception("");
        }
        if (resMessage is int) {
          if (resMessage == StatusCode.successStatus) {
            emit(state.copyWith(
                isFollow: !state.isFollow, status: FinishInitializing()));
          } else {
            throw Exception("");
          }
        } else {
          throw Exception(resMessage);
        }
      }
    } on Exception catch (_) {
      emit(state.copyWith(status: ErrorStatus(_)));
    }
  }
}
