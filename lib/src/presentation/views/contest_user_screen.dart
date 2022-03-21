import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/controller/auth/auth_bloc.dart';
import 'package:imagecaptioning/src/controller/contest_user/contest_user_bloc.dart';
import 'package:imagecaptioning/src/model/contest/user_in_contest_data.dart';
import 'package:imagecaptioning/src/presentation/error/something_went_wrong.dart';
import 'package:imagecaptioning/src/utils/func.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class ContestUserScreen extends StatefulWidget {
  const ContestUserScreen({Key? key, required this.contestId})
      : super(key: key);

  @override
  _ContestUserScreenState createState() => _ContestUserScreenState();

  final String contestId;
}

class _ContestUserScreenState extends State<ContestUserScreen> {
  final _userScrollController = ScrollController();
  final _searchScrollController = ScrollController();

  void _onScrollUser() {
    if (isScrollEnd(_userScrollController)) {
      context.read<ContestUserBloc>().add(FetchMoreContestUser());
    }
  }

  void _onScrollSearch() {
    if (isScrollEnd(_searchScrollController)) {
      context.read<ContestUserBloc>().add(FetchMoreSearchContestUser());
    }
  }

  @override
  void initState() {
    _userScrollController.addListener(_onScrollUser);
    _searchScrollController.addListener(_onScrollSearch);

    super.initState();
  }

  @override
  void dispose() {
    _userScrollController
      ..removeListener(_onScrollUser)
      ..dispose();
    _searchScrollController
      ..removeListener(_onScrollSearch)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String _contestId = widget.contestId;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          fit: StackFit.loose,
          children: [
            Positioned(
              top: 10,
              child: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back_rounded)),
            ),
            BlocListener<ContestUserBloc, ContestUserState>(
              listener: (context, state) {
                if (state.status == ContestUserStatus.postfetched) {
                  context.read<ContestUserBloc>().add(NavigatedToPost());
                  log("like" + state.post!.isLike.toString());
                  Map<String, dynamic> args = {'post': state.post};
                  log(state.post!.postId!);
                  context.read<AuthBloc>().add(NavigateToPageEvent(
                        route: AppRouter.postDetailScreen,
                        args: args,
                      ));
                }
              },
              child: BlocBuilder<ContestUserBloc, ContestUserState>(
                builder: (context, state) {
                  switch (state.status) {
                    case ContestUserStatus.success:
                      return FloatingSearchBar(
                        width: MediaQuery.of(context).size.width - 60,
                        axisAlignment: 1,
                        openWidth: MediaQuery.of(context).size.width,
                        margins: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 10),
                        backgroundColor: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(25),
                        elevation: 0,
                        hint: 'Search user ...',
                        physics: const BouncingScrollPhysics(),
                        openAxisAlignment: 0.0,
                        debounceDelay: const Duration(milliseconds: 500),
                        onQueryChanged: (query) {
                          context
                              .read<ContestUserBloc>()
                              .add(SearchContestUserFetched(query));
                        },
                        leadingActions: const [
                          FloatingSearchBarAction(
                            showIfClosed: false,
                            child: Icon(Icons.search_rounded),
                          ),
                        ],
                        automaticallyImplyBackButton: false,
                        transition: CircularFloatingSearchBarTransition(),
                        actions: [
                          FloatingSearchBarAction.searchToClear(
                            showIfClosed: false,
                          ),
                          //Float
                        ],
                        isScrollControlled: true,
                        builder: (context, transition) {
                          return Container(
                            margin: const EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              color: Colors.white,
                            ),
                            child: ListView.builder(
                              controller: _searchScrollController,
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: state.searchUserInContest.length,
                              itemBuilder: (_, index) {
                                if (state.searchUserInContest.isEmpty) {
                                  return const Center(
                                    child: Text("No user match your search"),
                                  );
                                }
                                final UserInContestData user =
                                    state.searchUserInContest[index];
                                return getUserItem(user, state);
                              },
                            ),
                          );
                        },
                        body: Padding(
                          padding: const EdgeInsets.only(top: 70),
                          child: state.userInContest.isEmpty
                              ? const Center(
                                  child: Text(
                                    'This contest has no participant',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                )
                              : ListView.builder(
                                  controller: _userScrollController,
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: state.userInContest.length,
                                  itemBuilder: (_, index) {
                                    final UserInContestData user =
                                        state.userInContest[index];
                                    return getUserItem(user, state);
                                  },
                                ),
                        ),
                      );
                    case ContestUserStatus.failure:
                      return SomethingWentWrongScreen(onPressed: () {
                        context
                            .read<ContestUserBloc>()
                            .add(InitContestUserFetched(_contestId));
                      });
                    default:
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.black87,
                        ),
                      );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  ListTile getUserItem(UserInContestData user, ContestUserState state) {
    return ListTile(
      onTap: () {
        context.read<ContestUserBloc>().add(PostFromUserFetched(user.postId!));
      },
      contentPadding: const EdgeInsets.fromLTRB(20, 8, 10, 8),
      leading: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          child: ClipOval(
            child: Image(
              image: user.userAvatar != null
                  ? NetworkImage(avatarUrl + user.userAvatar!)
                  : const AssetImage("assets/images/avatar_placeholder.png")
                      as ImageProvider,
              height: 55,
              width: 55,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: Text(
        user.userName ?? '',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
      subtitle:
          user.userRealname != null ? Text(user.userRealname ?? '') : null,
    );
  }
}
