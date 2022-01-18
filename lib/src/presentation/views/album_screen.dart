import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/controller/album/album_bloc.dart';
import 'package:imagecaptioning/src/model/album/album.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AlbumBloc, AlbumState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: getAppBar(state),
          body: getBody(state),
        );
      },
    );
  }

  SafeArea getBody(AlbumState state) {
    return SafeArea(
        child: GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          childAspectRatio: 1,
          crossAxisCount: 2,
          crossAxisSpacing: 25,
          mainAxisSpacing: 20),
      itemCount: state.postList?.length ?? 0,
      itemBuilder: (_, index) {
        final post = state.postList?[index];
        final String postImage = post?.imageUrl ?? '';
        return GestureDetector(
          onTap: () async {
            Map<String, dynamic> args = {'post': post};
            await Navigator.pushNamed(context, AppRouter.postDetailScreen,
                arguments: args);
            context.read<AlbumBloc>().add(FetchAlbumPosts(state.album!));
          },
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: postImage.isNotEmpty
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      image: DecorationImage(
                          image: NetworkImage(postImageUrl + postImage),
                          fit: BoxFit.cover),
                    )
                  : BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(25),
                    ),
            ),
          ),
        );
      },
    ));
  }

  AppBar getAppBar(AlbumState state) {
    return AppBar(
      elevation: 0,
      leadingWidth: 30,
      title: AppBarTitle(title: state.album?.albumName ?? ''),
      actions: [
        IconButton(
          onPressed: () {
            getSheet(context, state.album!, state.postList?.length ?? 0);
          },
          icon: const Icon(
            Icons.more_vert_rounded,
            color: Colors.black87,
            size: 30,
          ),
        )
      ],
    );
  }

  Future<dynamic> getSheet(BuildContext context, Album album, int imagesNum) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      enableDrag: true,
      context: context,
      builder: (wrapContext) {
        return Wrap(
          direction: Axis.vertical,
          children: [
            const SizedBox(height: 10),
            const SheetLine(),
            SizedBox(
              width: MediaQuery.of(wrapContext).size.width,
              child: Text(
                album.albumName ?? '',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(wrapContext).size.width,
              child: const Divider(
                color: Colors.grey,
                height: 25,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 18,
                  ),
                  children: [
                    TextSpan(
                      text: "Images: " + imagesNum.toString() + "\n\n",
                    ),
                    TextSpan(
                      text: "Created on: " + album.dateCreate.toString(),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(wrapContext).size.width,
              child: const Divider(
                color: Colors.grey,
                height: 25,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(wrapContext).size.width,
              child: ListTile(
                leading: const Icon(
                  Icons.delete_rounded,
                  color: Colors.redAccent,
                  size: 35,
                ),
                title: const Text(
                  "Delete",
                  style: TextStyle(fontSize: 19, color: Colors.redAccent),
                ),
                onTap: () {
                  context.read<AlbumBloc>().add(DeleteAlbum());
                },
              ),
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        );
      },
    );
  }
}
