import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/controller/conversation/conversation_bloc.dart';
import 'package:imagecaptioning/src/controller/contest/contest_list_bloc.dart';
import 'package:imagecaptioning/src/controller/forgot_password/forgot_password_bloc.dart';
import 'package:imagecaptioning/src/controller/home/home_bloc.dart';
import 'package:imagecaptioning/src/controller/login/login_bloc.dart';
import 'package:imagecaptioning/src/controller/notification/notification_bloc.dart';
import 'package:imagecaptioning/src/controller/registration/registration_bloc.dart';
import 'package:imagecaptioning/src/controller/verification/verification_bloc.dart';
import 'package:imagecaptioning/src/controller/profile/profile_bloc.dart';
import 'package:imagecaptioning/src/presentation/views/conversation_screen.dart';
import 'package:imagecaptioning/src/controller/post_detail/post_detail_bloc.dart';
import 'package:imagecaptioning/src/presentation/views/contest_list_screen.dart';
import 'package:imagecaptioning/src/presentation/views/edit_profile_screen.dart';
import 'package:imagecaptioning/src/presentation/views/email_confirmation_screen.dart';
import 'package:imagecaptioning/src/presentation/views/forgot_password_screen.dart';
import 'package:imagecaptioning/src/presentation/views/login_screen.dart';
import 'package:imagecaptioning/src/presentation/views/notification_page.dart';
import 'package:imagecaptioning/src/presentation/views/post_detail_screen.dart';
import 'package:imagecaptioning/src/presentation/views/profile_page.dart';
import 'package:imagecaptioning/src/presentation/views/registration_screen.dart';
import 'package:imagecaptioning/src/presentation/views/reset_password_screen.dart';
import 'package:imagecaptioning/src/presentation/views/root_screen.dart';
import 'package:imagecaptioning/src/presentation/views/verification_screen.dart';

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

  static const String contestListScreen = '/contestlistscreen';
  static const String postDetailScreen = '/postdetailscreen';
  final ProfileBloc profileBloc = ProfileBloc(true);

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
              BlocProvider(
                  create: (context) =>
                      NotificationBloc()..add(FetchNotification())),
              BlocProvider.value(value: profileBloc),
              BlocProvider(
                  create: (context) => HomeBloc()..add(InitPostFetched()))
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
          builder: (context) => BlocProvider.value(
            value: profileBloc,
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
          builder: (context) => BlocProvider.value(
            value: profileBloc,
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
      case contestListScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ContestListBloc()..add(InitContestFetched()),
            child: const ContestListScreen(),
          ),
        );
      case postDetailScreen:
        final post = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) =>
                PostDetailBloc()..add(PostDetailInitEvent(post['post'])),
            child: const PostDetailScreen(),
          ),
        );
      default:
        return null;
    }
  }
}
