import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imagecaptioning/src/presentation/views/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(411.5, 775),
      builder: () => MaterialApp(
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
        home: const LoginScreen(),
      ),
    );
  }
}
