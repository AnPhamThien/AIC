import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/controller/album/album_bloc.dart';
import 'package:imagecaptioning/src/controller/album_list/album_list_bloc.dart';
import 'package:imagecaptioning/src/controller/contest/contest_bloc.dart';
import 'package:imagecaptioning/src/controller/contest_list/contest_list_bloc.dart';
import 'package:imagecaptioning/src/controller/contest_user/contest_user_bloc.dart';
import 'package:imagecaptioning/src/controller/conversation/conversation_bloc.dart';
import 'package:imagecaptioning/src/controller/edit_profile/edit_profile_bloc.dart';
import 'package:imagecaptioning/src/controller/email_confirmation/email_confirmation_bloc.dart';
import 'package:imagecaptioning/src/controller/forgot_password/forgot_password_bloc.dart';
import 'package:imagecaptioning/src/controller/home/home_bloc.dart';
import 'package:imagecaptioning/src/controller/leaderboard/leaderboard_bloc.dart';
import 'package:imagecaptioning/src/controller/login/login_bloc.dart';
import 'package:imagecaptioning/src/controller/message/message_bloc.dart';
import 'package:imagecaptioning/src/controller/notification/notification_bloc.dart';
import 'package:imagecaptioning/src/controller/post/post_bloc.dart';
import 'package:imagecaptioning/src/controller/post_search/post_search_bloc.dart';
import 'package:imagecaptioning/src/controller/registration/registration_bloc.dart';
import 'package:imagecaptioning/src/controller/reset_password/reset_password_bloc.dart';
import 'package:imagecaptioning/src/controller/search/search_bloc.dart';
import 'package:imagecaptioning/src/controller/upload/upload_bloc.dart';
import 'package:imagecaptioning/src/controller/verification/verification_bloc.dart';
import 'package:imagecaptioning/src/controller/profile/profile_bloc.dart';
import 'package:imagecaptioning/src/presentation/views/album_list_screen.dart';
import 'package:imagecaptioning/src/presentation/views/album_screen.dart';
import 'package:imagecaptioning/src/presentation/views/contest_screen.dart';
import 'package:imagecaptioning/src/presentation/views/contest_user_screen.dart';
import 'package:imagecaptioning/src/presentation/views/conversation_screen.dart';
import 'package:imagecaptioning/src/controller/post_detail/post_detail_bloc.dart';
import 'package:imagecaptioning/src/presentation/views/contest_list_screen.dart';
import 'package:imagecaptioning/src/presentation/views/edit_profile_screen.dart';
import 'package:imagecaptioning/src/presentation/views/email_confirmation_screen.dart';
import 'package:imagecaptioning/src/presentation/views/forgot_password_screen.dart';
import 'package:imagecaptioning/src/presentation/views/leaderboard_screen.dart';
import 'package:imagecaptioning/src/presentation/views/login_screen.dart';
import 'package:imagecaptioning/src/presentation/views/message_screen.dart';
import 'package:imagecaptioning/src/presentation/views/notification_page.dart';
import 'package:imagecaptioning/src/presentation/views/post_detail_screen.dart';
import 'package:imagecaptioning/src/presentation/views/post_search_screen.dart';
import 'package:imagecaptioning/src/presentation/views/profile_page.dart';
import 'package:imagecaptioning/src/presentation/views/registration_screen.dart';
import 'package:imagecaptioning/src/presentation/views/reset_password_screen.dart';
import 'package:imagecaptioning/src/presentation/views/root_screen.dart';
import 'package:imagecaptioning/src/presentation/views/search_page.dart';
import 'package:imagecaptioning/src/presentation/views/upload_page.dart';
import 'package:imagecaptioning/src/presentation/views/verification_screen.dart';

class AppRouter {
  static const String loginScreen = '/';
  static const String albumListScreen = '/albumlist';
  static const String albumScreen = '/album';
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
  static const String uploadScreen = '/uploadscreen';
  static const String leaderboardScreen = '/leaderboardScreen';
  static const String userSearchScreen = '/userSearchScreen';
    static const String postSearchScreen = '/postSearchScreen';

  static const List<String> noAuthNeededScreens = [
    loginScreen,
    registrationScreen,
    verificationScreen,
    forgotPasswordScreen,
    emailConfirmScreen,
    resetPasswordScreen
  ];

  Route? onGenerateRoute(RouteSettings routeSettings) {
    PostBloc _postBloc = PostBloc();
    switch (routeSettings.name) {
      case albumListScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => AlbumListBloc()..add(FetchAlbum()),
            child: const AlbumListScreen(),
          ),
        );
      case albumScreen:
        final args = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) =>
                AlbumBloc()..add(FetchAlbumPosts(args['album'])),
            child: const AlbumScreen(),
          ),
        );
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
      String userID = routeSettings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => VerificationBloc(userID),
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
        final args = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => EmailConfirmationBloc(args['userId'], args['email']),
            child: const EmailConfirmationScreen(),
          ),
        );
      case rootScreen:
        return MaterialPageRoute(
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) {
                return NotificationBloc()..add(FetchNotification());
              }),
              BlocProvider(
                  create: (context) =>
                      ProfileBloc(true, false)..add(ProfileInitializing(''))),
              BlocProvider(
                  create: (context) => HomeBloc()..add(InitPostFetched())),
              BlocProvider.value(value: _postBloc),
            ],
            child: const RootScreen(),
          ),
        );

      case resetPasswordScreen:
        final args = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => ResetPasswordBloc(args['userId']),
                  child: const ResetPasswordScreen(),
                ));
      case currentUserProfileScreen:
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) =>
                ProfileBloc(true, true)..add(ProfileInitializing('')),
            child: const ProfilePage(),
          ),
        );
      case otherUserProfileScreen:
        final args = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => ProfileBloc(false, true)
              ..add(ProfileInitializing(args['userId'])),
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
                    ..add(
                      FetchMessage(
                          args['conversationId'],
                          args['avatar'],
                          args['username'],
                          args['userRealName'],
                          args['otherUserId']),
                    ),
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
          builder: (context) => MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                    PostDetailBloc()..add(PostDetailInitEvent(arg['post'])),
              ),
              BlocProvider.value(value: _postBloc),
              BlocProvider(
                create: (context) => HomeBloc(),
              ),
            ],
            child: PostDetailScreen(
              post: arg['post'],
              isInContest: arg['isInContest'] ?? false,
            ),
          ),
        );
      case contestScreen:
        final arg = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) => ContestBloc()
                        ..add(InitContestFetched(arg['contest'])),
                    ),
                    BlocProvider.value(value: _postBloc),
                  ],
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
      case uploadScreen:
        final arg = routeSettings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) =>
                      UploadBloc()..add(UploadInitializing(arg['imgPath'], arg['contestId'], arg['oringinalImg'])),
                  child: const UploadScreen(),
                ));
      case leaderboardScreen:
      final arg = routeSettings.arguments as String;
        return MaterialPageRoute(
          builder: (context) => BlocProvider(
                  create: (context) =>
                      LeaderboardBloc()..add(LeaderboardInitializing(arg)),
                  child: const LeaderBoardScreen(),
                )
        );
      case userSearchScreen:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) =>
                      SearchBloc()..add(InitSearchHistoryFetched()),
                  child: const SearchPage(),
                ));
      case postSearchScreen:
      //final arg = routeSettings.arguments as String;
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) =>
                      PostSearchBloc(),
                  child: const PostSearchScreen(),
                ));
      default:
        return null;
    }
  }
}
