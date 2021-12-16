import 'package:flutter/material.dart';
import 'package:imagecaptioning/src/data_local/markup_model.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';
import 'package:imagecaptioning/src/presentation/views/contest_screen.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';

class ContestListScreen extends StatefulWidget {
  const ContestListScreen({Key? key}) : super(key: key);

  @override
  _ContestListScreenState createState() => _ContestListScreenState();
}

class _ContestListScreenState extends State<ContestListScreen> {
  @override
  Widget build(BuildContext context) {
    List<Contest> contestList = Contest.getContestList();
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        title: const AppBarTitle(title: "Contest List"),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: ListView.builder(
              itemCount: contestList.length, //TODO: độ dài list contest  ở đây
              itemBuilder: (_, index) {
                final Contest contest =
                    contestList[index]; //TODO: moi contest ra ở đây
                return Column(
                  children: [
                    getContestItem(contest),
                    const Divider(
                      height: 15,
                      thickness: 1.5,
                      indent: 70,
                      endIndent: 40,
                      color: bgGrey,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  ListTile getContestItem(Contest contest) {
    String startDate =
        contest.startDate.toLocal().toIso8601String().split('T').first;
    String endDate =
        contest.endDate.toLocal().toIso8601String().split('T').first;
    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ContestScreen(
              contest: contest,
            ),
          ),
        );
      },

      minVerticalPadding: 15,
      leading: contest.statusCode == 3
          //nếu còn thời hạn
          ? const RadiantGradientMask(
              child: Icon(
                Icons.emoji_events_outlined,
                color: Colors.white,
                size: 42,
              ),
            )
          //nếu hết thời hạn
          : const Icon(
              Icons.emoji_events_outlined,
              color: Colors.grey,
              size: 42,
            ),
      //contest title
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Text(
          contest.contestName,
          style: const TextStyle(
              color: Colors.black87, fontSize: 22, fontWeight: FontWeight.w600),
        ),
      ),
      //from end
      subtitle: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "From: " + startDate,
          ),
          Text("To: " + endDate),
        ],
      ),
    );
  }
}
