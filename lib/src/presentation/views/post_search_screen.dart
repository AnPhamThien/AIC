import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/controller/post_search/post_search_bloc.dart';
import 'package:imagecaptioning/src/model/post/post.dart';
import 'package:imagecaptioning/src/utils/func.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

class PostSearchScreen extends StatefulWidget {
  const PostSearchScreen({Key? key}) : super(key: key);

  @override
  State<PostSearchScreen> createState() => _PostSearchScreenState();
}

class _PostSearchScreenState extends State<PostSearchScreen> {
  static const historyLength = 5;
  final _searchScrollController = ScrollController();

  void _onScrollSearch() {
    if (isScrollEnd(_searchScrollController)) {
      context.read<PostSearchBloc>().add(PostSearchMore());
    }
  }

// The "raw" history that we don't access from the UI, prefilled with values
  List<String> _searchHistory = [];
// The filtered & ordered history that's accessed from the UI
  List<String>? filteredSearchHistory;

// The currently searched-for term
  String? selectedTerm;

  List<String> filterSearchTerms({
    required String? filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      // Reversed because we want the last added items to appear first in the UI
      return _searchHistory.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return _searchHistory.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (_searchHistory.contains(term)) {
      // This method will be implemented soon
      putSearchTermFirst(term);
      return;
    }
    _searchHistory.add(term);
    if (_searchHistory.length > historyLength) {
      _searchHistory.removeRange(0, _searchHistory.length - historyLength);
    }
    // Changes in _searchHistory mean that we have to update the filteredSearchHistory
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    _searchHistory.removeWhere((t) => t == term);
    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  late FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    controller = FloatingSearchBarController();
    _searchScrollController.addListener(_onScrollSearch);

    filteredSearchHistory = filterSearchTerms(filter: null);
  }

  @override
  void dispose() {
    controller.dispose();
    _searchScrollController
      ..removeListener(_onScrollSearch)
      ..dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            BlocListener<PostSearchBloc, PostSearchState>(
              listener: (context, state) {
                final status = state.status;
                if (status is ErrorStatus) {
                  String errorMessage =
                      getErrorMessage(status.exception.toString());
                  _getDialog(
                      errorMessage, 'Error !', () => Navigator.pop(context));
                }
              },
              child: BlocBuilder<PostSearchBloc, PostSearchState>(
                builder: (context, state) {
                  return FloatingSearchBar(
                    controller: controller,
                    title: Text(
                      selectedTerm ?? 'Start searching',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    width: MediaQuery.of(context).size.width - 60,
                    axisAlignment: 1,
                    openWidth: MediaQuery.of(context).size.width,
                    margins: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    backgroundColor: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(25),
                    elevation: 0,
                    hint: 'Search...',
                    physics: const BouncingScrollPhysics(),
                    openAxisAlignment: 0.0,
                    debounceDelay: const Duration(milliseconds: 500),
                    onQueryChanged: (query) {
                      if (query.isNotEmpty) {
                        context.read<PostSearchBloc>().add(PostSearch(query));
                      }

                      setState(() {
                        filteredSearchHistory =
                            filterSearchTerms(filter: query);
                      });
                    },
                    onSubmitted: (query) {
                      if (query.isNotEmpty) {
                        context.read<PostSearchBloc>().add(PostSearch(query));
                      }
                      setState(() {
                        addSearchTerm(query);
                        selectedTerm = query;
                      });
                      controller.close();
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
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Material(
                          color: Colors.white,
                          elevation: 4,
                          child: Builder(
                            builder: (context) {
                              if (filteredSearchHistory!.isEmpty &&
                                  controller.query.isEmpty) {
                                return Container(
                                  height: 56,
                                  width: double.infinity,
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Start searching',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                );
                              } else if (filteredSearchHistory!.isEmpty) {
                                return ListTile(
                                  title: Text(controller.query),
                                  leading: const Icon(Icons.search),
                                  onTap: () {
                                    setState(() {
                                      addSearchTerm(controller.query);
                                      selectedTerm = controller.query;

                                      controller.close();
                                    });
                                  },
                                );
                              } else {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: filteredSearchHistory!
                                      .map(
                                        (term) => ListTile(
                                          title: Text(
                                            term,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          leading: const Icon(Icons.history),
                                          trailing: IconButton(
                                            icon: const Icon(Icons.clear),
                                            onPressed: () {
                                              setState(() {
                                                deleteSearchTerm(term);
                                              });
                                            },
                                          ),
                                          onTap: () {
                                            setState(() {
                                              putSearchTermFirst(term);
                                              selectedTerm = term;

                                              controller.close();
                                            });
                                          },
                                        ),
                                      )
                                      .toList(),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                    body: Padding(
                      //post search item
                      padding: const EdgeInsets.only(top: 70),
                      child: GridView.builder(
                        controller: _searchScrollController,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 5,
                                crossAxisSpacing: 5),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: false,
                        itemCount: state.searchResultPostList?.length ?? 0,
                        itemBuilder: (_, index) {
                          Post? post = state.searchResultPostList?[index];
                          String imagePath = post?.imageUrl ?? '';
                          return GestureDetector(
                              onTap: () async {
                                if (post != null) {
                                  Map<String, dynamic> args = {'post': post};
                                  await Navigator.pushNamed(
                                      context, AppRouter.postDetailScreen,
                                      arguments: args);
                                }
                              },
                              child: Image(
                                  image: imagePath.isNotEmpty
                                      ? NetworkImage(postImageUrl + imagePath)
                                      : const AssetImage(
                                              "assets/images/avatar_placeholder.png")
                                          as ImageProvider));
                        },
                      ),
                    ),
                  );
                },
              ),
            )
          ],
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
