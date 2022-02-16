import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/controller/album/album_bloc.dart';
import 'package:imagecaptioning/src/model/album/album.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';
import 'package:imagecaptioning/src/utils/func.dart';

class AlbumScreen extends StatefulWidget {
  const AlbumScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}

class _AlbumScreenState extends State<AlbumScreen> {
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
      context.read<AlbumBloc>().add(FetchMoreAlbumPosts());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AlbumBloc, AlbumState>(
      listener: (context, state) async {
        final status = state.status;
        if (status is DeletedStatus) {
          await _getDialog(
              "Delete successfully", 'Success !', () => Navigator.pop(context));
          Navigator.pop(context);
        } else if (status is ErrorStatus) {
          String errorMessage = getErrorMessage(status.exception.toString());
          _getDialog(errorMessage, 'Error !', () => Navigator.pop(context));
        }
      },
      child: BlocBuilder<AlbumBloc, AlbumState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: Colors.white,
            appBar: getAppBar(state),
            body: getBody(state),
          );
        },
      ),
    );
  }

  SafeArea getBody(AlbumState state) {
    return SafeArea(
        child: GridView.builder(
      controller: _scrollController,
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
            album.albumName != "Save Post Storage" &&
                    album.albumName != "Contest Post Storage"
                ? SizedBox(
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
                        Navigator.of(wrapContext).pop();
                      },
                    ),
                  )
                : const Text(""),
            const SizedBox(
              height: 15,
            ),
          ],
        );
      },
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
