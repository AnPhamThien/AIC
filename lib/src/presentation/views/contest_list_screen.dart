import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/controller/contest/contest_list_bloc.dart';
import 'package:imagecaptioning/src/model/contest/contest.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';
import 'package:imagecaptioning/src/presentation/views/contest_screen.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';
import 'package:imagecaptioning/src/utils/func.dart';

class ContestListScreen extends StatefulWidget {
  const ContestListScreen({Key? key}) : super(key: key);

  @override
  _ContestListScreenState createState() => _ContestListScreenState();
}

class _ContestListScreenState extends State<ContestListScreen> {
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
      // context.read<HomeBloc>().add(FetchMorePost());
    }
  }

  @override
  Widget build(BuildContext context) {
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
            child: BlocBuilder<ContestListBloc, ContestListState>(
              builder: (context, state) {
                switch (state.status) {
                  case ContestListStatus.failure:
                    return const Center(child: Text('failed to fetch contest'));

                  case ContestListStatus.success:
                    if (state.contestsList.isEmpty) {
                      return const Center(child: Text('no contest'));
                    }
                    return ListView.builder(
                      itemBuilder: (BuildContext context, int index) {
                        final Contest contest = state.contestsList[index];
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
                      itemCount: state.contestsList.length,
                      controller: _scrollController,
                    );
                  default:
                    return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  ListTile getContestItem(Contest contest) {
    String startDate =
        contest.dateCreate!.toLocal().toIso8601String().split('T').first;
    String endDate =
        contest.dateEnd!.toLocal().toIso8601String().split('T').first;
    return ListTile(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ContestScreen(
        //       contest: contest,
        //     ),
        //   ),
        // );
      },

      minVerticalPadding: 15,
      leading: contest.status == 3
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
          contest.contestName!,
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
