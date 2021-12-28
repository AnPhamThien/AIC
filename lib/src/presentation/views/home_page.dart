import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/controller/auth/auth_bloc.dart';
import 'package:imagecaptioning/src/controller/home/home_bloc.dart';
import 'package:imagecaptioning/src/model/post/post.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';
import 'package:imagecaptioning/src/presentation/widgets/post_widgets.dart';
import 'package:imagecaptioning/src/utils/func.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (isScrollEnd(_scrollController)) {
      context.read<HomeBloc>().add(FetchMorePost());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgApp,
      appBar: getAppBar(),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: BlocBuilder<HomeBloc, HomeState>(
            builder: (context, state) {
              log(state.status.toString());
              switch (state.status) {
                case HomeStatus.failure:
                  return const Center(child: Text('failed to fetch posts'));
                case HomeStatus.maxpost:
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      if (index == state.postsList.length) {
                        return const GetEndListPost();
                      } else {
                        final Post post = state.postsList[index];
                        return PostWidget(post: post);
                      }
                    },
                    itemCount: state.postsList.length + 1,
                    controller: _scrollController,
                  );
                case HomeStatus.success:
                  if (state.postsList.isEmpty) {
                    return const Center(child: Text('no posts'));
                  }
                  return ListView.builder(
                    itemBuilder: (BuildContext context, int index) {
                      final Post post = state.postsList[index];
                      return PostWidget(post: post);
                    },
                    itemCount: state.postsList.length,
                    controller: _scrollController,
                  );
                default:
                  return const Center(child: CircularProgressIndicator());
              }
            },
          ),
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
              context
                  .read<AuthBloc>()
                  .add(NavigateToPageEvent(route: AppRouter.contestListScreen));
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
            context
                .read<AuthBloc>()
                .add(NavigateToPageEvent(route: AppRouter.conversationScreen));
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
