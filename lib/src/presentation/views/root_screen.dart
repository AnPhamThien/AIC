import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/controller/auth/auth_bloc.dart';
import 'package:imagecaptioning/src/controller/profile/profile_bloc.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';
import 'package:imagecaptioning/src/presentation/views/home_page.dart';
import 'package:imagecaptioning/src/presentation/views/notification_page.dart';
import 'package:imagecaptioning/src/presentation/views/profile_page.dart';
import 'package:imagecaptioning/src/utils/bottom_nav_bar_json.dart';
import 'package:imagecaptioning/src/utils/func.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RootScreen extends StatefulWidget {
  const RootScreen({Key? key}) : super(key: key);

  @override
  _RootScreenState createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  int indexPage = 0;
  bool isClicked = false;

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
        SizedBox(),
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
              switch (index) {
                case 1:
                  return getSearchButton();
                case 2:
                  return getUploadButton();
                case 3:
                  return BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      return IconButton(
                        splashRadius: 45,
                        onPressed: () {
                          setState(() {
                            indexPage = index;
                            context
                                .read<AuthBloc>()
                                .add(ChangeReadNotiStatus(false));
                          });
                        },
                        icon: SvgPicture.asset(
                          indexPage == index
                              ? icons[index]['active']!
                              : icons[index]['inactive']!,
                          width: 27,
                          height: 27,
                          color: state.newNoti
                              ? Colors.red
                              : Colors
                                  .black87, //nếu có noti và index page != noti thì màu đ
                        ),
                      );
                    },
                  );
                default:
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
                      color: Colors
                          .black87, //nếu có noti và index page != noti thì màu đ
                    ),
                  );
              }
            },
          ),
        ),
      ),
    );
  }

  Theme getSearchButton() {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme:
            const DividerThemeData(color: Colors.grey, thickness: 0.5),
      ),
      child: PopupMenuButton(
        onSelected: (result) async {
          if (result == 0) {
            await Navigator.pushNamed(
              context,
              AppRouter.userSearchScreen,
            );
          } else if (result == 1) {
            await Navigator.pushNamed(context, AppRouter.postSearchScreen);
          }
          context.read<ProfileBloc>().add(ProfileInitializing(''));
        },
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        offset: const Offset(-35, -150),
        elevation: 10,
        itemBuilder: (context) {
          final list = <PopupMenuEntry<int>>[];
          list.add(
            getMenuItem(null, "User", Icons.grid_on_rounded, 0, null),
          );
          list.add(
            const PopupMenuDivider(),
          );
          list.add(
            getMenuItem(null, "Post", Icons.camera_enhance_outlined, 1,
                AppRouter.postSearchScreen),
          );
          return list;
        },
        icon: SvgPicture.asset(
          "assets/icons/search_icon.svg",
          width: 27,
          height: 27,
          color: Colors.black87,
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
            getMenuItem(ImageSource.gallery, "Gallery", Icons.grid_on_rounded,
                1, AppRouter.uploadScreen),
          );
          list.add(
            const PopupMenuDivider(),
          );
          list.add(
            getMenuItem(ImageSource.camera, "Camera",
                Icons.camera_enhance_outlined, 1, AppRouter.uploadScreen),
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

  PopupMenuItem<int> getMenuItem(ImageSource? source, String label,
      IconData iconData, int? value, String? destination) {
    return PopupMenuItem(
      value: value,
      onTap: () async {
        if (source != null && destination != null) {
          String? message = await pickImage(source, context, destination, null);
          if (message != null) {
            await _getDialog(
                message, 'Error !', () => Navigator.pop(context));
          }
        }
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

  Future<String?> _getDialog(
      String? content, String? header, void Function()? func) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actionsAlignment: MainAxisAlignment.center,
        title: Text(header ?? 'Error !',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 25,
                color: Colors.black87,
                letterSpacing: 1.25,
                fontWeight: FontWeight.bold)),
        content: Text(content ?? 'Something went wrong',
            textAlign: TextAlign.left,
            style: const TextStyle(
                fontSize: 20,
                color: Colors.black87,
                fontWeight: FontWeight.w600)),
        actions: <Widget>[
          TextButton(
            onPressed: func,
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
