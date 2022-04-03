import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/controller/post/post_bloc.dart';
import 'package:imagecaptioning/src/model/contest/prize.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../controller/contest/contest_bloc.dart';
import '../../model/contest/contest.dart';
import '../../model/post/post.dart';
import '../../utils/func.dart';
import '../error/something_went_wrong.dart';
import '../theme/style.dart';
import '../widgets/global_widgets.dart';
import '../widgets/post_widgets.dart';

class ContestScreen extends StatefulWidget {
  const ContestScreen({Key? key, required this.contest}) : super(key: key);

  final Contest contest;

  @override
  _ContestScreenState createState() => _ContestScreenState();
}

class _ContestScreenState extends State<ContestScreen> {
  late Contest _contest;
  bool _showBackToTopButton = false;

  final _scrollController = ScrollController();

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    context.read<ContestBloc>().add(InitContestFetched(_contest));
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    _contest = widget.contest;
    _scrollController.addListener(_onScroll);
    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.offset >= 400) {
          _showBackToTopButton = true; // show the back-to-top button
        } else {
          _showBackToTopButton = false; // hide the back-to-top button
        }
      });
    });
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
      context.read<ContestBloc>().add(MoreContestPostFetched());
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }

  @override
  Widget build(BuildContext context) {
    List<Post> _postList = <Post>[];
    return BlocListener<PostBloc, PostState>(
      listener: (context, state) {
        if (state.needUpdate == true) {
          int _index =
              _postList.indexWhere((element) => element.postId == state.postId);
          if (_postList[_index].isLike == 0) {
            _postList[_index].isLike = 1;
          } else {
            _postList[_index].isLike = 0;
          }

          context.read<PostBloc>().add(Reset());
        }
        if (state.status == PostStatus.deleted) {
          _postList.removeWhere((element) => element.postId == state.postId);
          context.read<PostBloc>().add(Reset());
        }
      },
      child: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          return BlocBuilder<ContestBloc, ContestState>(
            builder: (context, state) {
              switch (state.status) {
                case ContestStatus.success:
                  return Scaffold(
                    bottomNavigationBar:
                        widget.contest.timeLeft!.contains("Closed")
                            ? BottomAppBar(
                                child: Container(
                                    color: Colors.black,
                                    height: 50,
                                    child: const Center(
                                        child: Text(
                                      "This contest has ended",
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 18),
                                    ))),
                              )
                            : null,
                    backgroundColor: bgApp,
                    floatingActionButton: _showBackToTopButton == false
                        ? null
                        : FloatingActionButton(
                            backgroundColor: Colors.black87,
                            onPressed: _scrollToTop,
                            child: const Icon(
                              Icons.arrow_upward_rounded,
                              size: 30,
                            ),
                          ),
                    body: SmartRefresher(
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      child: CustomScrollView(
                        controller: _scrollController,
                        slivers: [
                          getAppBar(state),
                          state.topThreePost.isNotEmpty
                              ? getLeaderBoard(context, state)
                              : const SliverToBoxAdapter(
                                  child: SizedBox.shrink(),
                                ),
                          state.post.isEmpty
                              ? SliverToBoxAdapter(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: const Center(
                                      child: Text(
                                        "THIS CONTEST HAS NO POST",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                )
                              : SliverList(
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      _postList = state.post;
                                      final Post post = _postList[index];
                                      return PostWidget(
                                        post: post,
                                        isInContest: true,
                                      );
                                    },
                                    childCount: state.post.length,
                                  ),
                                )
                        ],
                      ),
                    ),
                  );
                case ContestStatus.failure:
                  return SomethingWentWrongScreen(onPressed: () {
                    context
                        .read<ContestBloc>()
                        .add(InitContestFetched(_contest));
                  });
                default:
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.black87,
                    ),
                  );
              }
            },
          );
        },
      ),
    );
  }

  SliverToBoxAdapter getLeaderBoard(BuildContext context, ContestState state) {
    return SliverToBoxAdapter(
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 1),
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(45))),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Divider(
              height: 0,
              thickness: .5,
              endIndent: 20,
              indent: 20,
              color: Colors.black54,
            ),
            const SizedBox(
              height: 15,
            ),
            TextButton(
              onPressed: () {
                String args = state.contest?.id ?? '';
                Navigator.pushNamed(context, AppRouter.leaderboardScreen,
                    arguments: args);
              },
              child: const Text(
                "Leader Board",
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                state.topThreePost.length > 1
                    ? GestureDetector(
                        onTap: () {
                          Map<String, dynamic> args = {
                            'post': state.topThreePost[1],
                            'isInContest': true
                          };
                          Navigator.pushNamed(
                            context,
                            AppRouter.postDetailScreen,
                            arguments: args,
                          );
                        },
                        child: Column(
                          children: [
                            getLBAva(state.topThreePost[1].avataUrl, 80,
                                Colors.grey.shade400),
                            getLBLikeCount(
                                state.topThreePost[1].likecount.toString() +
                                    ' likes')
                          ],
                        ),
                      )
                    : getLBPlacehodler(),
                GestureDetector(
                  onTap: () {
                    Map<String, dynamic> args = {
                      'post': state.topThreePost[0],
                      'isInContest': true
                    };
                    Navigator.pushNamed(
                      context,
                      AppRouter.postDetailScreen,
                      arguments: args,
                    );
                  },
                  child: Column(
                    children: [
                      getLBAva(state.topThreePost[0].avataUrl, 100,
                          Colors.amberAccent.shade700),
                      getLBLikeCount(
                          state.topThreePost[0].likecount.toString() + ' likes')
                    ],
                  ),
                ),
                state.topThreePost.length == 3
                    ? GestureDetector(
                        onTap: () {
                          Map<String, dynamic> args = {
                            'post': state.topThreePost[2],
                            'isInContest': true
                          };
                          Navigator.pushNamed(
                            context,
                            AppRouter.postDetailScreen,
                            arguments: args,
                          );
                        },
                        child: Column(
                          children: [
                            getLBAva(state.topThreePost[2].avataUrl, 80,
                                Colors.brown.shade400),
                            getLBLikeCount(
                                state.topThreePost[2].likecount.toString() +
                                    ' likes')
                          ],
                        ),
                      )
                    : getLBPlacehodler(),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ),
      ),
    );
  }

  SliverAppBar getAppBar(ContestState state) {
    return SliverAppBar(
      elevation: 0,
      pinned: true,
      expandedHeight: kToolbarHeight,
      title: AppBarTitle(title: _contest.contestName ?? ''),
      leadingWidth: 30,
      actions: [
        !state.contest!.timeLeft!.contains("Closed")
            ? IconButton(
                onPressed: () {
                  //chuyển màn upload post
                },
                icon: SvgPicture.asset(
                  'assets/icons/upload_icon.svg',
                  color: Colors.black87,
                ),
              )
            : const SizedBox.shrink(),
        IconButton(
          onPressed: () {
            getSheet(_contest, context.read<ContestBloc>(), state);
          },
          icon: const Icon(Icons.info_outlined, size: 30),
        )
      ],
    );
  }

  Future<dynamic> getSheet(
    Contest contest,
    ContestBloc bloc,
    ContestState state,
  ) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      enableDrag: true,
      context: context,
      builder: (context) {
        String startDate =
            contest.dateCreate?.toLocal().toIso8601String().split('T').first ??
                '';
        String endDate =
            contest.dateEnd?.toLocal().toIso8601String().split('T').first ?? '';
        return Wrap(
          direction: Axis.vertical,
          children: [
            const SizedBox(height: 10),
            const SheetLine(),
            //* contest name
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Text(
                contest.contestName ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: const Divider(
                color: Colors.grey,
                height: 25,
              ),
            ),
            //* end,start date
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "From: " + startDate,
                    style: TextStyle(color: Colors.black87, fontSize: 18.sp),
                  ),
                  Text(
                    "To: " + endDate,
                    style: TextStyle(color: Colors.black87, fontSize: 18.sp),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
              ),
              child: GestureDetector(
                onTap: () async {
                  Map<String, dynamic> args = {'contestId': contest.id};
                  await Navigator.pushNamed(
                      context, AppRouter.contestUserScreen,
                      arguments: args);
                  bloc.add(InitContestFetched(contest));
                },
                child: Text(
                  "Participant: ${state.totalParticipaters}",
                  style: TextStyle(color: Colors.black87, fontSize: 18.sp),
                ),
              ),
            ),
            //* description
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: RichText(
                softWrap: true,
                text: TextSpan(
                  style: TextStyle(color: Colors.black87, fontSize: 18.sp),
                  children: [
                    const TextSpan(
                      text: ("Description: "),
                    ),
                    TextSpan(
                      text: (contest.description ??
                          "This contest does not have a description"),
                    ),
                  ],
                ),
              ),
            ),

            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: Text(
                'Prizes: ',
                style: TextStyle(
                  color: Colors.black87,
                  fontSize: 18.sp,
                ),
              ),
            ),

            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: state.prizes.length,
                itemBuilder: (_, index) {
                  final Prize prize = state.prizes[index];
                  return Container(
                    child: ListTile(
                      dense: true,
                      visualDensity:
                          const VisualDensity(horizontal: 0, vertical: -3),
                      title: Text(
                        'Top ${prize.top}: ${prize.name}',
                        style:
                            TextStyle(color: Colors.black87, fontSize: 18.sp),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
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
        child: Container(
          width: 108,
          height: 48,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SvgPicture.asset(
                  "assets/icons/upload_icon.svg",
                  width: 25,
                  height: 25,
                  color: Colors.white,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Text(
                  "JOIN",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.25,
                      color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<int> getUploadMenuItem(
      ImageSource source, String label, IconData iconData) {
    return PopupMenuItem(
      onTap: () {
        pickImage(source, context, AppRouter.uploadScreen);
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

  Column getLBPlacehodler() {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
        ),
        const SizedBox(
          height: 25,
        ),
      ],
    );
  }

  SizedBox getLBAva(String? avaUrl, double size, Color? color) {
    return SizedBox(
      height: size + 20,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Center(
            child: SvgPicture.asset(
              'assets/icons/LeaderBoardCrown.svg',
              height: size + 10,
              width: size + 10,
              color: color,
            ),
          ),
          Positioned(
            top: 0,
            child: Center(
              child: ClipOval(
                child: Image(
                  image: avaUrl != null
                      ? NetworkImage(avatarUrl + avaUrl)
                      : const AssetImage("assets/images/avatar_placeholder.png")
                          as ImageProvider,
                  height: size,
                  width: size,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Padding getLBLikeCount(String likeCount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: SizedBox(
        height: 25,
        child: Text(
          likeCount,
          style: const TextStyle(
              color: Colors.black87, fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ),
    );
  }
}
