import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/controller/album_list/album_list_bloc.dart';
import 'package:imagecaptioning/src/model/album/album.dart';
import 'package:imagecaptioning/src/presentation/widgets/get_user_input_field.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';

class AlbumListScreen extends StatefulWidget {
  const AlbumListScreen({Key? key}) : super(key: key);

  @override
  _AlbumListScreenState createState() => _AlbumListScreenState();
}

class _AlbumListScreenState extends State<AlbumListScreen> {
  final _addAlbumController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(context),
      body: getBody(),
    );
  }

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leadingWidth: 30,
      title: const AppBarTitle(title: "Album"),
      actions: [
        IconButton(
          //* tạo album
          onPressed: () => showCreateAlbumnDialog(),
          icon: const Icon(
            Icons.add_rounded,
            size: 32,
          ),
        )
      ],
    );
  }

  //hàm tạo album
  Future<String?> showCreateAlbumnDialog() {
    return showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actionsAlignment: MainAxisAlignment.center,
        title: const Text('New Album',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 23,
                color: Colors.black87,
                letterSpacing: 1.25,
                fontWeight: FontWeight.w500)),
        content: SizedBox(
          width: MediaQuery.of(dialogContext).size.width * .9,
          child: GetUserInput(
              label: "",
              hint: "Your new album name",
              isPassword: false,
              controller: _addAlbumController),
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              context
                  .read<AlbumListBloc>()
                  .add(AddNewAlbum(_addAlbumController.value.text));
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }

  SafeArea getBody() {
    return SafeArea(
      child: BlocBuilder<AlbumListBloc, AlbumListState>(
        builder: (context, state) {
          return GridView.builder(
            padding: const EdgeInsets.all(15),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 2 / 2.35,
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 10),
            itemCount: state.albumList.length,
            itemBuilder: (_, index) {
              final Album album = state.albumList[index];
              return GestureDetector(
                onTap: () async {
                  Map<String, dynamic> args = {"album": album};
                  await Navigator.pushNamed(context, AppRouter.albumScreen,
                      arguments: args);
                  context.read<AlbumListBloc>().add(FetchAlbum());
                },
                onLongPress: () {
                  getSheet(context, album.albumName ?? '', album.id ?? '');
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AspectRatio(
                      aspectRatio: 1,
                      child: Container(
                        decoration: album.imgUrl != null
                            ? BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        postImageUrl + album.imgUrl!),
                                    fit: BoxFit.cover),
                              )
                            : BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(25),
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 7.0, horizontal: 3),
                      child: Text(
                        album.albumName ?? '',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<dynamic> getSheet(
      BuildContext context, String albumName, String albumId) {
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
                albumName, //TODO nhét contest name vào đây
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
            SizedBox(
              width: MediaQuery.of(wrapContext).size.width,
              child: ListTile(
                leading: const Icon(
                  Icons.edit_rounded,
                  color: Colors.black87,
                  size: 35,
                ),
                title: const Text(
                  "Edit Album",
                  style: TextStyle(fontSize: 19),
                ),
                onTap: () {
                  //TODO hàm edit album
                },
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
                  context.read<AlbumListBloc>().add(DeleteAlbum(albumId));
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
