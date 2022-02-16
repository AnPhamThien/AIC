import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/controller/auth/auth_bloc.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';
import 'package:imagecaptioning/src/presentation/views/storage_page.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';
import 'package:imagecaptioning/src/controller/profile/profile_bloc.dart';
import 'package:imagecaptioning/src/utils/func.dart';

import 'gallery_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        final status = state.status;
        if (status is ErrorStatus) {
          String errorMessage = getErrorMessage(status.exception.toString());
          _getDialog(errorMessage, 'Error !', () => Navigator.pop(context));
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          bool isMe = state.isCurrentUser;
          bool isFollow = state.isFollow;

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: getProfileAppBar(state.user?.userName ?? '', isMe),
            body: DefaultTabController(
              length: 2,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  if (state.user?.avataUrl != null) {
                    refreshNetworkImage(avatarUrl + state.user?.avataUrl);
                  }
                  return [
                    SliverList(
                      delegate: SliverChildListDelegate([
                        const SizedBox(height: 10),
                        getUserHeader(
                            state.user?.avataUrl ?? "",
                            state.user?.numberOfpost ?? 0,
                            state.user?.numberFollower ?? 0,
                            state.user?.numberFollowee ?? 0),
                        getUserDescription(state.user?.userRealName ?? '',
                            state.user?.description ?? ''),
                        isMe == true
                            ? getEditProfileButton(
                                context, state.user?.avataUrl ?? "")
                            : getFollowMessageButton(
                                state.user?.userName,
                                state.user?.avataUrl,
                                state.user?.userRealName,
                                state.user?.id,
                                isFollow)
                      ]),
                    ),
                  ];
                },
                body: Column(
                  children: const [
                    TabBar(
                      labelColor: Colors.black,
                      unselectedLabelColor: Colors.grey,
                      indicatorWeight: 1,
                      indicatorColor: Colors.black,
                      tabs: [
                        Tab(
                          icon: Icon(
                            Icons.grid_on_rounded,
                          ),
                        ),
                        Tab(
                          icon: Icon(
                            Icons.save_alt_rounded,
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          GalleryPage(),
                          StoragePage(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  AppBar getProfileAppBar(String username, bool isCurrentUser) {
    return AppBar(
      automaticallyImplyLeading: !isCurrentUser,
      leadingWidth: 30,
      elevation: 0,
      title: AppBarTitle(
        title: username,
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: IconButton(
            onPressed: () {
              getSheet(context);
            },
            icon: const Icon(
              Icons.dehaze_rounded,
              size: 30,
            ),
          ),
        )
      ],
    );
  }

  Row getUserHeader(
      String imagePath, int postCount, int followerCount, int followingCount) {
    return Row(
      children: [
        //AVATAR
        getAvatar(imagePath),
        const Expanded(
          child: SizedBox(),
          flex: 1,
        ),
        Expanded(
          flex: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              getProfileLabelCount(postCount.toString(), "Posts"),
              getProfileLabelCount(followerCount.toString(), "Follower"),
              getProfileLabelCount(followingCount.toString(), "Following"),
            ],
          ),
        )
      ],
    );
  }

  Future refreshNetworkImage(String url) async {
    NetworkImage provider = NetworkImage(url);
    await provider.evict();
  }

  Padding getAvatar(String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        height: 85.h,
        width: 85.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            onError: (exception, stackTrace) => log(exception.toString()),
            image: imagePath.isNotEmpty
                ? NetworkImage(avatarUrl +
                    imagePath.toString() +
                    "?v=" +
                    DateTime.now().toString())
                : const AssetImage("assets/images/avatar_placeholder.png")
                    as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Column getProfileLabelCount(String count, String label) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          label,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, height: 1.5),
        ),
      ],
    );
  }

  Padding getUserDescription(String fullname, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fullname,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, height: 1.5),
          ),
          const SizedBox(height: 7),
          Text(description),
        ],
      ),
    );
  }

  Padding getEditProfileButton(BuildContext context, String imagePath) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          fixedSize: Size(size.width, 35),
          primary: Colors.black,
          side: const BorderSide(
            width: 1,
            color: bgGrey,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(7),
          ),
        ),
        onPressed: () async {
          await Navigator.of(context).pushNamed(AppRouter.editProfileScreen);

          setState(() {
            context.read<ProfileBloc>().add(ProfileInitializing(''));
          });
        },
        child: const Text("Edit Profile"),
      ),
    );
  }

  Row getFollowMessageButton(
      username, img, userRealName, userId, bool isFollow) {
    Size size = MediaQuery.of(context).size;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            fixedSize: Size(size.width / 2.2, 35),
            primary: Colors.white,
            backgroundColor: Colors.black87,
            side: const BorderSide(
              width: 1,
              color: bgGrey,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          onPressed: () {
            context.read<ProfileBloc>().add(ProfileChangeFollowUser(userId));
          },
          child: isFollow ? const Text("Unfollow") : const Text("Follow"),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            fixedSize: Size(size.width / 2.2, 35),
            primary: Colors.black,
            side: const BorderSide(
              width: 1,
              color: bgGrey,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),
            ),
          ),
          onPressed: () async {
            Map<String, dynamic> args = {
              "username": username,
              "avatar": img,
              "userRealName": userRealName,
              "otherUserId": userId
            };
            await Navigator.of(context)
                .pushNamed(AppRouter.messageScreen, arguments: args);
          },
          child: const Text("Message"),
        ),
      ],
    );
  }

  Future<dynamic> getSheet(BuildContext context) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      enableDrag: true,
      context: context,
      builder: (context) {
        return Wrap(
          direction: Axis.vertical,
          children: [
            const SizedBox(height: 10),
            const SheetLine(),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                leading: const Icon(
                  Icons.photo_album_outlined,
                  color: Colors.black87,
                  size: 35,
                ),
                title: const Text(
                  "Album",
                  style: TextStyle(fontSize: 19),
                ),
                onTap: () {
                  Navigator.pushNamed(context, AppRouter.albumListScreen);
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListTile(
                leading: const Icon(
                  Icons.logout_rounded,
                  color: Colors.black87,
                  size: 35,
                ),
                title: const Text(
                  "Log out",
                  style: TextStyle(fontSize: 19),
                ),
                onTap: () {
                  context.read<AuthBloc>().add(LogoutEvent());
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        );
      },
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
