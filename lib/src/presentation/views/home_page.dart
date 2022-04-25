import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imagecaptioning/src/constant/error_message.dart';
import 'package:imagecaptioning/src/controller/auth/auth_bloc.dart';
import 'package:imagecaptioning/src/controller/post/post_bloc.dart';
import 'package:imagecaptioning/src/controller/profile/profile_bloc.dart';
import '../../app/routes.dart';
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
          child: MultiBlocListener(
            listeners: [
              BlocListener<PostBloc, PostState>(
                listener: (context, state) {
                  if (state.needUpdate == true) {
                    int _index = _postList.indexWhere(
                        (element) => element.postId == state.postId);
                    if (_postList[_index].isLike == 0) {
                      setState(() {
                        _postList[_index].isLike = 1;
                        _postList[_index].likecount =
                            _postList[_index].likecount! + 1;
                        log(_postList[_index].likecount.toString());
                      });
                    } else {
                      setState(() {
                        _postList[_index].isLike = 0;
                        _postList[_index].likecount =
                            _postList[_index].likecount! - 1;
                        log(_postList[_index].likecount.toString());
                      });
                    }
                    context.read<ProfileBloc>().add(ProfileInitializing(''));
                    context.read<PostBloc>().add(Reset());
                  }
                  if (state.status == PostStatus.added) {
                    setState(() {
                      if (state.post != null) {
                        context.read<HomeBloc>().add(PostAdded(state.post!));
                      }
                      //context.read<HomeBloc>().add(InitPostFetched());
                      context.read<PostBloc>().add(Reset());
                      context.read<ProfileBloc>().add(ProfileInitializing(''));
                    });
                  }
                  if (state.status == PostStatus.updated) {
                    setState(() {
                      if (state.postId.isNotEmpty && state.postCaption != null) {
                        context.read<HomeBloc>().add(PostUpdated(state.postId, state.postCaption!));
                      }
                      //context.read<HomeBloc>().add(InitPostFetched());
                      context.read<PostBloc>().add(Reset());
                      context.read<ProfileBloc>().add(ProfileInitializing(''));
                    });
                  }
                  if (state.status == PostStatus.save &&
                      state.isSaved == false) {
                    int _index = _postList.indexWhere(
                        (element) => element.postId == state.postId);
                    setState(() {
                      _postList[_index].isSaved = 0;
                    });
                    context.read<ProfileBloc>().add(ProfileInitializing(""));
                    context.read<PostBloc>().add(Reset());
                  }
                  if (state.status == PostStatus.save &&
                      state.isSaved == true) {
                    int _index = _postList.indexWhere(
                        (element) => element.postId == state.postId);
                    setState(() {
                      _postList[_index].isSaved = 1;
                    });
                    context.read<ProfileBloc>().add(ProfileInitializing(""));
                    context.read<PostBloc>().add(Reset());
                  }

                  if (state.status == PostStatus.fail) {
                    String error = getErrorMessage(state.error ?? '');
                    _getDialog(error, "Error", () => Navigator.of(context).pop());
                    context.read<PostBloc>().add(Reset());
                  }
                },
              ),
              BlocListener<HomeBloc, HomeState>(
                listenWhen: (previous, current) => previous != current,
                listener: (context, state) async {
                  if (state.deletedPostId != '') {
                    setState(() {
                      context.read<HomeBloc>().add(PostListReset());
                      context.read<HomeBloc>().add(InitPostFetched());
                    });
                  }
                  if (state.status == HomeStatus.failure) {
                    String error = getErrorMessage(state.error ?? '');
                    await _getDialog(error, "Error", () => Navigator.of(context).pop());
                    context.read<HomeBloc>().add(PostListReset());
                  }
                },
              ),
            ],
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
                            return PostWidget(
                              post: post,
                              isInContest: false,
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
        BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return IconButton(
              onPressed: () async {
                await Navigator.of(context)
                    .pushNamed(AppRouter.conversationScreen);
                context.read<AuthBloc>().add(CheckMessageAndNoti());
              },
              icon: SvgPicture.asset(
                "assets/icons/message_icon.svg",
                color: state.newMessage ? Colors.red : Colors.black,
                width: 27,
                height: 27,
              ),
            );
          },
        ), //Message
      ],
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
        content: Text(content ?? MessageCode.genericError,
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
