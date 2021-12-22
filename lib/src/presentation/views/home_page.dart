import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imagecaptioning/src/controller/home_controller/bloc/home_bloc.dart';
import 'package:imagecaptioning/src/model/post/post.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';
import 'package:imagecaptioning/src/presentation/views/contest_list_screen.dart';
import 'package:imagecaptioning/src/presentation/views/message_screen.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';
import 'package:imagecaptioning/src/presentation/widgets/post_widgets.dart';
import 'package:imagecaptioning/src/repositories/post/post_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //final List<Post> postList = Post.getPostList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgApp,
      appBar: getAppBar(),
      body: SafeArea(
        child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: BlocProvider(
              create: (_) => HomeBloc(PostRepository()),
              child:
                  BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
                context.read<HomeBloc>().add(PostFetched());
                log("ABC111");
                switch (state.status) {
                  case HomeStatus.failure:
                    return const Center(child: Text('failed to fetch posts'));
                  case HomeStatus.success:
                    log("ABC");
                    if (state.postsList.isEmpty) {
                      return const Center(child: Text('no posts'));
                    }
                    return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          final Post post = state.postsList[index];
                          return PostWidget(post: post);
                        },
                        itemCount: state.postsList.length
                        //controller: _scrollController,
                        );
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              }),
            )
            // ListView.builder(
            //   itemCount: postList.length,
            //   itemBuilder: (_, index) {
            //     final Post post = postList[index];
            //     return PostWidget(
            //       post: post,
            //     );
            //   },
            // ),
            ),
      ),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Text(
        "Image Captioning",
        style: TextStyle(
          color: Colors.black87,
          fontFamily: "Billabong",
          fontWeight: FontWeight.w400,
          fontSize: 27.0,
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      actions: [
        RadiantGradientMask(
          child: IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ContestListScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.emoji_events_outlined,
              color: Colors.white,
              size: 32,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const MessageScreen(),
              ),
            );
          },
          icon: SvgPicture.asset(
            "assets/icons/message_icon.svg",
            color: Colors.black,
            width: 27,
            height: 27,
          ),
        ), //Message
      ],
    );
  }
}
