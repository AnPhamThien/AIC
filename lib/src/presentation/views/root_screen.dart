import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';
import 'package:imagecaptioning/src/presentation/views/home_page.dart';
import 'package:imagecaptioning/src/presentation/views/notification_page.dart';
import 'package:imagecaptioning/src/presentation/views/profile_page.dart';
import 'package:imagecaptioning/src/presentation/views/search_page.dart';
import 'package:imagecaptioning/src/presentation/views/upload_page.dart';
import 'package:imagecaptioning/src/utils/bottom_nav_bar_json.dart';

class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int indexPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: getBody(),
      bottomNavigationBar: getBottomNavigationBar(),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: indexPage,
      children: const [
        HomePage(),
        SearchPage(),
        UploadPage(),
        NotificationPage(),
        ProfilePage(),
      ],
    );
  }

  Widget getBottomNavigationBar() {
    return Container(
      height: 70.h,
      decoration: BoxDecoration(
        color: bgLightGrey,
        border: Border(
          top: BorderSide(
            width: 0.5,
            color: bgDark.withOpacity(0.1),
          ),
        ),
      ),
      child: Material(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            icons.length,
            (index) {
              return IconButton(
                splashRadius: 45,
                onPressed: () {
                  setState(
                    () {
                      indexPage = index;
                    },
                  );
                },
                icon: SvgPicture.asset(
                  indexPage == index
                      ? icons[index]['active']!
                      : icons[index]['inactive']!,
                  width: 27,
                  height: 27,
                  color: Colors.black,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
