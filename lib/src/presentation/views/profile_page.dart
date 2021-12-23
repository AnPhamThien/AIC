import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/controller/auth/auth_bloc.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';
import 'package:imagecaptioning/src/presentation/views/album_list_screen.dart';
import 'package:imagecaptioning/src/presentation/views/conversation_screen.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';

import 'gallery_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    bool isMe = false;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getProfileAppBar("thieen_aan"),
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
          headerSliverBuilder: (context, _) {
            return [
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    const SizedBox(height: 10),
                    getUserHeader("assets/images/Kroni.jpg", 1, 40, 130),
                    getUserDescription("Thiên Ân",
                        "Hello, DIO DA!\nWRYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY"),
                    isMe == true
                        ? getEditProfileButton()
                        : getFollowMessageButton()
                  ],
                ),
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
                    Center(child: Text("Saved post")),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppBar getProfileAppBar(String username) {
    return AppBar(
      automaticallyImplyLeading: false,
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

  Padding getAvatar(String imagePath) {
    return Padding(
      padding: const EdgeInsets.only(left: 10),
      child: Container(
        height: 85.h,
        width: 85.h,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: AssetImage(
                imagePath.isNotEmpty ? imagePath : "assets/images/Kroni.jpg"),
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

  Padding getEditProfileButton() {
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
        onPressed: () {
          context
              .read<AuthBloc>()
              .add(NavigateToPageEvent(AppRouter.editProfileScreen));
          //Navigator.of(context).pushNamed(AppRouter.editProfileScreen);
        },
        child: const Text("Edit Profile"),
      ),
    );
  }

  Row getFollowMessageButton() {
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
            //TODO function follow ở đây
          },
          child: const Text("Follow"),
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
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ConversationScreen(),
              ),
            );
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AlbumListScreen(),
                    ),
                  );
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
}
