import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/controller/auth/auth_bloc.dart';

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final AppRouter _appRouter = AppRouter();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(_navigatorKey),
      child: ScreenUtilInit(
        designSize: const Size(411.5, 775),
        builder: () => MaterialApp(
          navigatorKey: _navigatorKey,
          theme: ThemeData(
            //glow khi kéo
            //colorScheme: const ColorScheme.light(secondary: Colors.black54,),
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 1,
            ),
          ),
          title: 'ImageCaptioning',
          debugShowCheckedModeBanner: false,
          //home: const LoginScreen(),
          onGenerateRoute: _appRouter.onGenerateRoute,
        ),
      ),
    );
  }
}
