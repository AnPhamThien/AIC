import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';

class LeaderBoardScreen extends StatefulWidget {
  const LeaderBoardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderBoardScreen> createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  @override
  Widget build(BuildContext context) {
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
              title: AppBarTitle(title: 'LeaderBoard'),
              leadingWidth: 30,
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  //nếu là thằng đầu tiên
                  switch (index) {
                    case 0:
                      return SizedBox(
                        height: 200,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getLBAva('truyền avatar url vô đây', 100,
                                Colors.amberAccent.shade700),
                            getLBLikeCount('100' + ' likes'),
                            //truyền like count vô đây
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
                        leading: getLBAva(
                            'avaUrl thằng top 2', 50, Colors.grey.shade400),
                        title: const Text('Username2'),
                        subtitle: const Text('Likes'),
                        trailing: Text(
                          '${index + 1}nd',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      );
                    case 2: //top3
                      return ListTile(
                        leading: getLBAva(
                            'avaUrl thằng top 2', 50, Colors.brown.shade400),
                        title: const Text('Username3'),
                        subtitle: const Text('Likes'),
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
                        leading: const Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: SizedBox(
                            width: 50.0,
                            height: 50.0,
                            child: Image(
                              image: AssetImage(
                                  "assets/images/avatar_placeholder.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        title: const Text('Username'),
                        subtitle: const Text('Likes'),
                        trailing: Text('${index + 1}$end',
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.bold)),
                      );
                  }
                },
                childCount: 20,
              ),
            )
          ],
        ),
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
                  // truyền avatarURL vào đây
                  image:
                      // avaUrl != null
                      //? NetworkImage(avatarUrl + avaUrl)
                      //:
                      const AssetImage("assets/images/avatar_placeholder.png"),
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
}
