import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imagecaptioning/src/controller/post/post_bloc.dart';
import '../../app/routes.dart';
import '../../controller/auth/auth_bloc.dart';
import '../../controller/home/home_bloc.dart';
import '../../model/post/post.dart';
import '../theme/style.dart';
import '../widgets/global_widgets.dart';
import '../widgets/post_widgets.dart';
import '../../utils/func.dart';

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
    List<Post> _postList = <Post>[];
    return Scaffold(
      backgroundColor: bgApp,
      appBar: getAppBar(),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: BlocListener<PostBloc, PostState>(
            listener: (context, state) {
              if (state.needUpdate == true) {
                int _index = _postList
                    .indexWhere((element) => element.postId == state.postId);
                if (_postList[_index].isLike == 0) {
                  _postList[_index].isLike = 1;
                } else {
                  _postList[_index].isLike = 0;
                }

                context.read<PostBloc>().add(Reset());
              }
            },
            child: BlocBuilder<PostBloc, PostState>(
              builder: (context, state) {
                return BlocBuilder<HomeBloc, HomeState>(
                  builder: (context, state) {
                    switch (state.status) {
                      case HomeStatus.failure:
                        return const Center(
                            child: Text('failed to fetch posts'));

                      case HomeStatus.success:
                        if (state.postsList.isEmpty) {
                          return const Center(child: Text('no posts'));
                        }
                        return ListView.builder(
                          itemBuilder: (BuildContext context, int index) {
                            _postList = state.postsList;
                            final Post post = _postList[index];
                            context.read<HomeBloc>().add(FetchMorePost());
                            return PostWidget(
                              post: post,
                            );
                          },
                          itemCount: state.postsList.length,
                          controller: _scrollController,
                        );
                      default:
                        return const Center(child: CircularProgressIndicator());
                    }
                  },
                );
              },
            ),
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
            onPressed: () async {
              await Navigator.pushNamed(context, AppRouter.contestListScreen);
              context.read<HomeBloc>().add(InitPostFetched());
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
