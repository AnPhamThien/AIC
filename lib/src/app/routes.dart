import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/controller/contest_user/contest_user_bloc.dart';
import 'package:imagecaptioning/src/controller/search/search_bloc.dart';
import 'package:imagecaptioning/src/presentation/views/contest_user_screen.dart';
import '../controller/contest/contest_bloc.dart';
import '../controller/contest_list/contest_list_bloc.dart';
import '../controller/conversation/conversation_bloc.dart';
import '../controller/edit_profile/edit_profile_bloc.dart';
import '../controller/forgot_password/forgot_password_bloc.dart';
import '../controller/home/home_bloc.dart';
import '../controller/login/login_bloc.dart';
import '../controller/message/message_bloc.dart';
import '../controller/notification/notification_bloc.dart';
import '../controller/registration/registration_bloc.dart';
import '../controller/verification/verification_bloc.dart';
import '../controller/profile/profile_bloc.dart';
import '../presentation/views/contest_screen.dart';
import '../presentation/views/conversation_screen.dart';
import '../controller/post_detail/post_detail_bloc.dart';
import '../presentation/views/contest_list_screen.dart';
import '../presentation/views/edit_profile_screen.dart';
import '../presentation/views/email_confirmation_screen.dart';
import '../presentation/views/forgot_password_screen.dart';
import '../presentation/views/login_screen.dart';
import '../presentation/views/message_screen.dart';
import '../presentation/views/notification_page.dart';
import '../presentation/views/post_detail_screen.dart';
import '../presentation/views/profile_page.dart';
import '../presentation/views/registration_screen.dart';
import '../presentation/views/reset_password_screen.dart';
import '../presentation/views/root_screen.dart';
import '../presentation/views/verification_screen.dart';

class AppRouter {
  static const String loginScreen = '/';
  static const String registrationScreen = '/registration';
  static const String verificationScreen = '/verification';
  static const String forgotPasswordScreen = '/forgotpassword';
  static const String emailConfirmScreen = '/emailconfirm';
  static const String resetPasswordScreen = '/resetpassword';
  static const String rootScreen = '/home';
  static const String currentUserProfileScreen = '/profile';
  static const String otherUserProfileScreen = '/otherprofile';
  static const String editProfileScreen = '/editprofile';
  static const String notificationScreen = '/notification';
  static const String conversationScreen = '/conversation';
  static const String messageScreen = '/message';
  static const String contestListScreen = '/contestlistscreen';
  static const String postDetailScreen = '/postdetailscreen';
  static const String contestScreen = '/contestscreen';
  static const String contestUserScreen = '/contestuserscreen';
  // final ProfileBloc currentUSerProfileBloc = ProfileBloc(true)
  //   ..add(ProfileInitializing(''));

  static const List<String> noAuthNeededScreens = [
    loginScreen,
    registrationScreen,
    verificationScreen,
    forgotPasswordScreen,
    emailConfirmScreen,
    resetPasswordScreen
  ];

  Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case loginScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => LoginBloc(),
            child: const LoginScreen(),
          ),
        );
      case registrationScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => RegistrationBloc(),
                  child: const RegistrationScreen(),
                ));
      case verificationScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => VerificationBloc(),
                  child: const VerificationScreen(),
                ));
      case forgotPasswordScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ForgotPasswordBloc(),
            child: const ForgotPasswordScreen(),
          ),
        );
      case emailConfirmScreen:
        return MaterialPageRoute(
          builder: (context) => const EmailConfirmationScreen(),
        );
      case rootScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              //BlocProvider(create: (context) => ProfileBloc()),
              BlocProvider(create: (context) {
                return NotificationBloc()..add(FetchNotification());
              }),

              BlocProvider(
                  create: (context) =>
                      ProfileBloc(true)..add(ProfileInitializing(''))),
              BlocProvider(
                  create: (context) => HomeBloc()..add(InitPostFetched())),
              BlocProvider(
                  create: (context) =>
                      SearchBloc()..add(InitSearchHistoryFetched())),
            ],
            child: const RootScreen(),
          ),
        );
      case resetPasswordScreen:
        return MaterialPageRoute(
          builder: (context) => const ResetPasswordScreen(),
        );
      case currentUserProfileScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) =>
                ProfileBloc(false)..add(ProfileInitializing('')),
            child: const ProfilePage(),
          ),
        );
      case otherUserProfileScreen:
        final userId = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) =>
                ProfileBloc(false)..add(ProfileInitializing(userId['userId'])),
            child: const ProfilePage(),
          ),
        );
      case editProfileScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) =>
                EditProfileBloc()..add(EditProfileInitializing()),
            child: const EditProfileScreen(),
          ),
        );
      case notificationScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => NotificationBloc(),
                  child: const NotificationPage(),
                ));
      case conversationScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) =>
                      ConversationBloc()..add(FetchConversation()),
                  child: const ConversationScreen(),
                ));
      case messageScreen:
        final args = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => MessageBloc()
                    ..add(FetchMessage(
                        args['conversationId'],
                        args['avatar'],
                        args['username'],
                        args['userRealName'],
                        args['otherUserId'])),
                  child: const MessageScreen(),
                ));
      case contestListScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) =>
                ContestListBloc()..add(InitContestListFetched()),
            child: const ContestListScreen(),
          ),
        );
      case postDetailScreen:
        final arg = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) =>
                PostDetailBloc()..add(PostDetailInitEvent(arg['post'])),
            child: const PostDetailScreen(),
          ),
        );
      case contestScreen:
        final arg = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) =>
                      ContestBloc()..add(InitContestFetched(arg['contest'])),
                  child: ContestScreen(
                    contest: arg['contest'],
                  ),
                ));
      case contestUserScreen:
        final arg = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => ContestUserBloc()
                    ..add(InitContestUserFetched(arg['contestId'])),
                  child: ContestUserScreen(
                    contestId: arg['contestId'],
                  ),
                ));
      default:
        return null;
    }
  }
}
