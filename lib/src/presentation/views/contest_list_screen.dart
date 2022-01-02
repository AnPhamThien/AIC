import 'dart:developer';

import 'package:backdrop/backdrop.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import '../../controller/contest/contest_list_bloc.dart';
import '../../model/contest/contest.dart';
import '../theme/style.dart';
import '../widgets/global_widgets.dart';
import '../../utils/func.dart';

class ContestListScreen extends StatefulWidget {
  const ContestListScreen({Key? key}) : super(key: key);

  @override
  _ContestListScreenState createState() => _ContestListScreenState();
}

class _ContestListScreenState extends State<ContestListScreen> {
  String _searchText = '';
  final _scrollInitController = ScrollController();
  final _scrollSearchController = ScrollController();
  DateTime? selectedDateDown;
  DateTime? selectedDateUp;
  bool isDatePicked = false;
  final _searchTextEditingController = TextEditingController();
  @override
  void initState() {
    _scrollInitController.addListener(_onScroll);
    _scrollSearchController.addListener(_onSearchScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollInitController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (isScrollEnd(_scrollInitController)) {
      log(DefaultTabController.of(context)!.index.toString());
      context
          .read<ContestListBloc>()
          .add(FetchMoreContest(DefaultTabController.of(context)!.index));
    }
  }

  void _onSearchScroll() {
    if (isScrollEnd(_scrollInitController)) {
      log(DefaultTabController.of(context)!.index.toString());
      context
          .read<ContestListBloc>()
          .add(FetchMoreContest(DefaultTabController.of(context)!.index));
    }
  }

  Future<void> _selectDate(BuildContext context, bool start) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateUp ?? DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: selectedDateUp ?? DateTime.now());
    if (picked != null && picked != selectedDateDown) {
      if (start) {
        setState(
          () {
            selectedDateDown = picked;
            isDatePicked = true;
          },
        );
      } else {
        setState(
          () {
            selectedDateUp = picked;
            selectedDateDown ??= selectedDateUp;
            isDatePicked = true;
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropScaffold(
        backLayerBackgroundColor: bgApp,
        appBar: getAppBar(),
        backLayer: getBackLayer(),
        resizeToAvoidBottomInset: true,
        headerHeight: 49,
        frontLayerScrim: Colors.white54,
        frontLayerBorderRadius: const BorderRadius.vertical(
          top: Radius.circular(25),
        ),
        frontLayer: getFrontLayer());
  }

  DefaultTabController getFrontLayer() {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: TabBar(
          labelStyle: TextStyle(fontSize: 17.sp, fontWeight: FontWeight.w700),
          indicatorColor: Colors.black54,
          labelColor: Colors.black,
          unselectedLabelColor: Colors.black45,
          tabs: const [
            Tab(
              text: 'On-going',
            ),
            Tab(
              text: 'Closed',
            ),
          ],
        ),
        body: SafeArea(
          child: TabBarView(
            children: [
              BlocBuilder<ContestListBloc, ContestListState>(
                builder: (context, state) {
                  switch (state.status) {
                    case ContestListStatus.failure:
                      return const Center(
                          child: Text('failed to fetch contest'));

                    case ContestListStatus.success:
                      if (state.activeContestList.isEmpty) {
                        return const Center(child: Text('no contest'));
                      }
                      return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          final Contest contest =
                              state.activeContestList[index];
                          return Column(
                            children: [
                              getContestItem(contest),
                              const Divider(
                                height: 0,
                                thickness: 1.5,
                                indent: 70,
                                endIndent: 40,
                                color: bgGrey,
                              ),
                            ],
                          );
                        },
                        itemCount: state.activeContestList.length,
                        controller: _scrollInitController,
                      );
                    default:
                      return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
              BlocBuilder<ContestListBloc, ContestListState>(
                builder: (context, state) {
                  switch (state.status) {
                    case ContestListStatus.failure:
                      return const Center(
                          child: Text('failed to fetch contest'));
                    case ContestListStatus.success:
                      if (state.inactiveContestList.isEmpty) {
                        return const Center(child: Text('no contest'));
                      }
                      return ListView.builder(
                        itemBuilder: (BuildContext context, int index) {
                          final Contest contest =
                              state.inactiveContestList[index];
                          return Column(
                            children: [
                              getContestItem(contest),
                              const Divider(
                                height: 0,
                                thickness: 1.5,
                                indent: 70,
                                endIndent: 40,
                                color: bgGrey,
                              ),
                            ],
                          );
                        },
                        itemCount: state.activeContestList.length,
                        controller: _scrollInitController,
                      );
                    default:
                      return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  BackdropAppBar getAppBar() {
    return BackdropAppBar(
      title: Text(_searchText == '' ? 'Contest list' : _searchText),
      foregroundColor: Colors.black87,
      backgroundColor: bgApp,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(
          Icons.arrow_back_rounded,
        ),
      ),
      actions: [
        Builder(
          builder: (context) {
            return Backdrop.of(context).isBackLayerRevealed
                ? Builder(
                    builder: (context) => IconButton(
                      onPressed: () {
                        setState(() {
                          _searchText = _searchTextEditingController.text;
                        });
                        if (selectedDateDown != null) {
                          context.read<ContestListBloc>().add(
                                InitSearchContestFetched(
                                  _searchTextEditingController.text,
                                  selectedDateUp == null
                                      ? DateTime.now()
                                          .toIso8601String()
                                          .split('T')
                                          .first
                                      : selectedDateUp!
                                          .toIso8601String()
                                          .split('T')
                                          .first,
                                  selectedDateDown!
                                      .toIso8601String()
                                      .split('T')
                                      .first,
                                ),
                              );
                        }

                        Backdrop.of(context).concealBackLayer();
                      },
                      icon: const Icon(
                        Icons.search_rounded,
                      ),
                    ),
                  )
                : Builder(
                    builder: (context) => _searchText != '' || isDatePicked
                        ? IconButton(
                            onPressed: () {
                              setState(
                                () {
                                  _searchText = '';
                                  selectedDateDown = null;
                                  selectedDateUp = null;
                                  _searchTextEditingController.clear();
                                  isDatePicked = false;
                                },
                              );
                              context
                                  .read<ContestListBloc>()
                                  .add(InitContestFetched());
                            },
                            icon: const Icon(
                              Icons.clear_rounded,
                            ),
                          )
                        : IconButton(
                            onPressed: () {
                              Backdrop.of(context).revealBackLayer();
                            },
                            icon: const Icon(
                              Icons.search_rounded,
                            ),
                          ),
                  );
          },
        ),
      ],
    );
  }

  SafeArea getBackLayer() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Contest name ...',
                fillColor: bgGrey,
                filled: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(width: 0.0, style: BorderStyle.none)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide:
                        const BorderSide(width: 0.0, style: BorderStyle.none)),
                contentPadding:
                    const EdgeInsets.fromLTRB(20.0, 10.0, 10.0, 0.0),
              ),
              controller: _searchTextEditingController,
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                getDate(true, selectedDateDown, 'Start date'),
                getDate(false, selectedDateUp, 'End date'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  SizedBox getDate(bool isStart, DateTime? date, String hint) {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 2.2,
      child: GestureDetector(
        onTap: () => _selectDate(context, isStart),
        child: AbsorbPointer(
          absorbing: true,
          child: TextField(
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              hintText:
                  date == null ? hint : date.toIso8601String().split('T').first,
              fillColor: bgGrey,
              filled: true,
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      const BorderSide(width: 0.0, style: BorderStyle.none)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide:
                      const BorderSide(width: 0.0, style: BorderStyle.none)),
              contentPadding: const EdgeInsets.only(top: 0),
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
      onTap: () {},

      minVerticalPadding: 15,
      leading: contest.timeLeft == 'Present'
          //nếu còn thời hạn
          ? const RadiantGradientMask(
              child: Icon(
                Icons.emoji_events_outlined,
                color: Colors.white,
                size: 37,
              ),
            )
          //nếu hết thời hạn
          : const Icon(
              Icons.emoji_events_outlined,
              color: Colors.grey,
              size: 37,
            ),
      //contest title
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Text(
          contest.contestName!,
          style: const TextStyle(
              color: Colors.black87, fontSize: 20, fontWeight: FontWeight.w600),
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
