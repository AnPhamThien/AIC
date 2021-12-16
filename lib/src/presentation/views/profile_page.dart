import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/controller/auth/form_submission_status.dart';
import 'package:imagecaptioning/src/controller/navigator/navigator_bloc.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';
import 'package:imagecaptioning/src/controller/profile/profile_bloc.dart';

import 'gallery_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileBloc>().add(Initializing());
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocListener<ProfileBloc, ProfileState>(
      listenWhen: (previous, current) =>
          previous.formStatus != current.formStatus,
      listener: (context, state) {
        if (state.formStatus is InitialFormStatus) {
          context.read<ProfileBloc>().add(Initializing());
        }
      },
      child: BlocBuilder<ProfileBloc, ProfileState>(
        buildWhen: (previous, current) =>
            previous.formStatus != current.formStatus,
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: (state.user != null)
                ? getProfileAppBar(state.user!.userName ?? "")
                : null,
            body: (state.user != null)
                ? DefaultTabController(
                    length: 2,
                    child: NestedScrollView(
                      headerSliverBuilder: (context, _) {
                        return [
                          SliverList(
                            delegate: SliverChildListDelegate(
                              [
                                const SizedBox(height: 10),
                                getUserHeader(
                                    "assets/images/Kroni.jpg",
                                    state.user!.numberOfpost ?? 0,
                                    state.user!.numberFollower ?? 0,
                                    state.user!.numberFollowee ?? 0),
                                getUserDescription(
                                    state.user!.userRealName ?? "",
                                    state.user!.description ?? ""),
                                getEditProfileButton(size),
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
                                // Gallery(),
                                GalleryPage(),
                                Center(child: Text("CDE")),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }

  AppBar getProfileAppBar(String username) {
    return AppBar(
      title: Text(
        username,
        style: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w500,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: IconButton(
            onPressed: () => {},
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
    String imagePath,
    int postCount,
    int followerCount,
    int followingCount,
  ) {
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
            image: AssetImage(imagePath),
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

  Padding getEditProfileButton(Size size) {
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
              .read<NavigatorBloc>()
              .add(NavigateToPageEvent(AppRouter.editProfileScreen));
          //Navigator.of(context).pushNamed(AppRouter.editProfileScreen);
        },
        child: const Text("Edit Profile"),
      ),
    );
  }
}
