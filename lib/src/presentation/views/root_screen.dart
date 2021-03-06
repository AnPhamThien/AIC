import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';
import 'package:imagecaptioning/src/presentation/views/home_page.dart';
import 'package:imagecaptioning/src/presentation/views/notification_page.dart';
import 'package:imagecaptioning/src/presentation/views/profile_page.dart';
import 'package:imagecaptioning/src/presentation/views/search_screen.dart';
import 'package:imagecaptioning/src/utils/bottom_nav_bar_json.dart';
import 'package:imagecaptioning/src/utils/func.dart';

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
      body: Theme(
        child: getBody(),
        data: Theme.of(context).copyWith(
          dividerTheme:
              const DividerThemeData(color: Colors.grey, thickness: 0.65),
        ),
      ),
      bottomNavigationBar: getBottomNavigationBar(),
    );
  }

  Widget getBody() {
    return IndexedStack(
      index: indexPage,
      children: const [
        HomePage(),
        SearchScreen(),
        SizedBox(),
        NotificationPage(),
        ProfilePage(),
      ],
    );
  }

  Widget getBottomNavigationBar() {
    return Container(
      height: 55.h,
      decoration: BoxDecoration(
        color: bgGrey,
        border: Border(
          top: BorderSide(
            width: 0.5,
            color: bgDark.withOpacity(0.1),
          ),
        ),
      ),
      child: Material(
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            icons.length,
            (index) {
              if (index != 2) {
                return IconButton(
                  splashRadius: 45,
                  onPressed: () {
                    setState(() {
                      indexPage = index;
                    });
                  },
                  icon: SvgPicture.asset(
                    indexPage == index
                        ? icons[index]['active']!
                        : icons[index]['inactive']!,
                    width: 27,
                    height: 27,
                    color: Colors.black87,
                  ),
                );
              }
              return getUploadButton();
            },
          ),
        ),
      ),
    );
  }

  Theme getUploadButton() {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme:
            const DividerThemeData(color: Colors.grey, thickness: 0.5),
      ),
      child: PopupMenuButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        offset: const Offset(65, -150),
        elevation: 10,
        itemBuilder: (context) {
          final list = <PopupMenuEntry<int>>[];
          list.add(
            getUploadMenuItem(
                ImageSource.gallery, "Gallery", Icons.grid_on_rounded),
          );
          list.add(
            const PopupMenuDivider(),
          );
          list.add(
            getUploadMenuItem(
                ImageSource.camera, "Camera", Icons.camera_enhance_outlined),
          );
          return list;
        },
        icon: SvgPicture.asset(
          "assets/icons/upload_icon.svg",
          width: 27,
          height: 27,
          color: Colors.black87,
        ),
      ),
    );
  }

  PopupMenuItem<int> getUploadMenuItem(
      ImageSource source, String label, IconData iconData) {
    return PopupMenuItem(
      onTap: () {
        pickImage(source, context);
      },
      textStyle: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Icon(
            iconData,
            color: Colors.black87,
            size: 30,
          ),
        ],
      ),
    );
  }
}
