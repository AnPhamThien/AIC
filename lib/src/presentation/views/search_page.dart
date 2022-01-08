import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/controller/auth/auth_bloc.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/controller/search/search_bloc.dart';
import 'package:imagecaptioning/src/model/search/search_data.dart';
import 'package:imagecaptioning/src/model/search/search_history_data.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:imagecaptioning/src/presentation/error/something_went_wrong.dart';
import '../../data_local/markup_model.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    List<User> searchedUser =
        User.getSearchedUser(); //TODO mốt chuyển vào controller nè
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          fit: StackFit.loose,
          children: [
            BlocBuilder<SearchBloc, SearchState>(
              builder: (context, state) {
                switch (state.status) {
                  case SearchStatus.success:
                    return FloatingSearchBar(
                      margins: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      backgroundColor: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(25),
                      elevation: 0,
                      hint: 'Search...', //TODO nhét từ vừa search vào đây
                      physics: const BouncingScrollPhysics(),
                      openAxisAlignment: 0.0,
                      debounceDelay: const Duration(milliseconds: 500),
                      onQueryChanged: (query) {
                        context
                            .read<SearchBloc>()
                            .add(InitSearchFetched(query));
                      },
                      leadingActions: const [
                        FloatingSearchBarAction(
                          showIfClosed: true,
                          child: Icon(Icons.search_rounded),
                        ),
                      ],
                      automaticallyImplyBackButton: false,
                      transition: CircularFloatingSearchBarTransition(),
                      actions: [
                        FloatingSearchBarAction.searchToClear(
                          showIfClosed: false,
                        ),
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
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: state.searchList.length,
                            itemBuilder: (_, index) {
                              final SearchData searchUser =
                                  state.searchList[index];
                              return getSearchItem(searchUser);
                            },
                          ),
                        );
                      },
                      //lịch sử search
                      body: Padding(
                        padding: const EdgeInsets.only(top: 70),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: state.searchHistoryList.length,
                          itemBuilder: (_, index) {
                            final SearchHistoryData searchedUser =
                                state.searchHistoryList[index];
                            return getSearchHistoryItem(searchedUser);
                          },
                        ),
                      ),
                    );
                  case SearchStatus.failure:
                    return SomethingWentWrongScreen(onPressed: () {
                      context
                          .read<SearchBloc>()
                          .add(InitSearchHistoryFetched());
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
          ],
        ),
      ),
    );
  }

  ListTile getSearchHistoryItem(SearchHistoryData searchedUser) {
    return ListTile(
      onTap: () {
        final userId = searchedUser.userId;
        Map<String, dynamic> args = {'userId': userId};
        userId != getIt<AppPref>().getUserID
            ? context.read<AuthBloc>().add(NavigateToPageEvent(
                route: AppRouter.otherUserProfileScreen, args: args))
            : null;
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
              image: searchedUser.avatarUrl != null
                  ? NetworkImage(avatarUrl + searchedUser.avatarUrl!)
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
        searchedUser.userName ?? '',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
      subtitle: searchedUser.userRealName != null
          ? Text(searchedUser.userRealName ?? '')
          : const SizedBox.shrink(),
      trailing: IconButton(
        splashRadius: 30,
        onPressed: () {
          //TODO xóa user khi nhấn vào button này
        },
        icon: const Icon(
          Icons.clear_rounded,
          color: Colors.grey,
          size: 20,
        ),
      ),
    );
  }

  ListTile getSearchItem(SearchData searchedUser) {
    return ListTile(
      onTap: () {
        final userId = searchedUser.id;
        Map<String, dynamic> args = {'userId': userId};
        userId != getIt<AppPref>().getUserID
            ? context.read<AuthBloc>().add(NavigateToPageEvent(
                route: AppRouter.otherUserProfileScreen, args: args))
            : context.read<AuthBloc>().add(
                NavigateToPageEvent(route: AppRouter.currentUserProfileScreen));
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
              image: searchedUser.avataUrl != null
                  ? NetworkImage(avatarUrl + searchedUser.avataUrl!)
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
        searchedUser.userName ?? '',
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
      ),
      subtitle: searchedUser.userRealName != null
          ? Text(searchedUser.userRealName ?? '')
          : const SizedBox.shrink(),
    );
  }
}
