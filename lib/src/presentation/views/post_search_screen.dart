import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/controller/post_search/post_search_bloc.dart';
import 'package:imagecaptioning/src/model/post/post.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';
import 'package:imagecaptioning/src/utils/func.dart';

class PostSearchScreen extends StatefulWidget {
  const PostSearchScreen({Key? key}) : super(key: key);

  @override
  State<PostSearchScreen> createState() => _PostSearchScreenState();
}

class _PostSearchScreenState extends State<PostSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<PostSearchBloc, PostSearchState>(
      listener: (context, state) {
        final status = state.status;
        if (status is ErrorStatus) {
          String errorMessage = getErrorMessage(status.exception.toString());
          _getDialog(errorMessage, 'Error !', () => Navigator.pop(context));
        }
      },
      child: BlocBuilder<PostSearchBloc, PostSearchState>(
        builder: (context, state) {
          return Scaffold(
              appBar: AppBar(
                title: const AppBarTitle(title: 'Post Search'),
              ),
              body: SafeArea(
                child: CustomScrollView(
                    //controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: SizedBox(
                          height: 200,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Searched Image",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w500),
                              ),
                              Image(
                                image: state.imgPath != null
                      ? Image.file(File((state.imgPath.toString()))).image
                      : const AssetImage("assets/images/avatar_placeholder.png"),
                                height: 150,
                                width: 150,
                              ),
                             const Divider(
                                color: bgGrey,
                                thickness: 1,
                                indent: 20,
                                endIndent: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverGrid(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent:
                              MediaQuery.of(context).size.width / 3,
                          mainAxisSpacing: 5.0,
                          crossAxisSpacing: 5.0,
                          childAspectRatio: 1.0,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            Post? post = state.searchResultPostList?[index];
                            String imagePath = post?.imageUrl ?? '';
                            return GestureDetector(
                                onTap: () async {if (post != null) {
                    Map<String, dynamic> args = {'post': post};
                    await Navigator.pushNamed(
                        context, AppRouter.postDetailScreen,
                        arguments: args);
                  }},
                                child: Image(
                                    image:
                                        imagePath.isNotEmpty
                ? NetworkImage(postImageUrl + imagePath)
                : const AssetImage("assets/images/avatar_placeholder.png")
                    as ImageProvider));
                          },
                          childCount: state.searchResultPostList?.length ?? 0,
                        ),
                      ),
                  
                    ]),
              ));
        },
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
