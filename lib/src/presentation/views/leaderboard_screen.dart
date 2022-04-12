import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/controller/leaderboard/leaderboard_bloc.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/utils/func.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LeaderboardBloc, LeaderboardState>(
      listener: (context, state) {
        final status = state.status;
        if (status is ErrorStatus) {
          String errorMessage = getErrorMessage(status.exception.toString());
          _getDialog(errorMessage, 'Error !', () => Navigator.pop(context));
        }
      },
      child: BlocBuilder<LeaderboardBloc, LeaderboardState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                //controller: _scrollController,
                slivers: [
                  const SliverAppBar(
                    centerTitle: true,
                    elevation: 0,
                    pinned: true,
                    expandedHeight: kToolbarHeight,
                    title: AppBarTitle(title: 'Leaderboard'),
                    leadingWidth: 30,
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        int likeCount =
                            state.topPostInContestList?[index].likecount ?? 0;
                        String? avaUrl =
                            state.topPostInContestList?[index].avataUrl;
                        String username =
                            state.topPostInContestList?[index].userName ?? '';
                        switch (index) {
                          case 0:
                            return SizedBox(
                              height: 220,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  getLBAva(
                                      avaUrl, 100, Colors.amberAccent.shade700),
                                  getLBLikeCount(username),
                                  getLBLikeCount(likeCount.toString() +
                                      ((likeCount > 1) ? ' likes' : ' like')),
                                  const Divider(
                                    color: bgGrey,
                                    thickness: 1,
                                    indent: 20,
                                    endIndent: 20,
                                  ),
                                ],
                              ),
                            );
                          case 1: //top2
                            return ListTile(
                              leading:
                                  getLBAva(avaUrl, 50, Colors.grey.shade400),
                              title: Text(username),
                              subtitle: Text(likeCount.toString() +
                                  ((likeCount > 1) ? ' likes' : ' like')),
                              trailing: Text(
                                '${index + 1}nd',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            );
                          case 2: //top3
                            return ListTile(
                              leading:
                                  getLBAva(avaUrl, 50, Colors.brown.shade400),
                              title: Text(username),
                              subtitle: Text(likeCount.toString() +
                                  ((likeCount > 1) ? ' likes' : ' like')),
                              trailing: Text(
                                '${index + 1}rd',
                                style: const TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            );
                          default:
                            String end = 'th';
                            if (index == 10) end = 'st';
                            if (index == 11) end = 'nd';
                            if (index == 12) end = 'rd';
                            return ListTile(
                              leading: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20, right: 20),
                                child: SizedBox(
                                  width: 50.0,
                                  height: 50.0,
                                  child: Image(
                                    image: avaUrl != null
                                        ? NetworkImage(avatarUrl + avaUrl)
                                            as ImageProvider
                                        : const AssetImage(
                                            "assets/images/avatar_placeholder.png"),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              title: Text(username),
                              subtitle: Text(likeCount.toString() +
                                  ((likeCount > 1) ? ' likes' : ' like')),
                              trailing: Text('${index + 1}' + end,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold)),
                            );
                        }
                      },
                      childCount: state.topPostInContestList?.length ?? 0,
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  SizedBox getLBAva(String? avaUrl, double size, Color? color) {
    return SizedBox(
      height: size + 20,
      width: size + 40,
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
                      ? NetworkImage(avatarUrl + avaUrl) as ImageProvider
                      : const AssetImage(
                          "assets/images/avatar_placeholder.png"),
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
      padding: const EdgeInsets.only(top: 15.0),
      child: SizedBox(
        height: 25,
        child: Text(
          likeCount,
          style: const TextStyle(
              color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w600),
        ),
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
