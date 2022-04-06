import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/controller/album_list/album_list_bloc.dart';
import 'package:imagecaptioning/src/model/album/album.dart';
import 'package:imagecaptioning/src/presentation/widgets/get_user_input_field.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';
import 'package:imagecaptioning/src/utils/func.dart';
import 'package:imagecaptioning/src/utils/validations.dart';

class AlbumListScreen extends StatefulWidget {
  const AlbumListScreen({Key? key}) : super(key: key);

  @override
  _AlbumListScreenState createState() => _AlbumListScreenState();
}

class _AlbumListScreenState extends State<AlbumListScreen> {
  final _addAlbumController = TextEditingController();
  final _editAlbumController = TextEditingController();
  final _scrollController = ScrollController();

  final _formKey = GlobalKey<FormState>();

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
      context.read<AlbumListBloc>().add(FetchMoreAlbum());
    }
  }

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
          onPressed: () => showAlbumnDialog("Add new album", null, null),
          icon: const Icon(
            Icons.add_rounded,
            size: 32,
          ),
        )
      ],
    );
  }

  //hàm tạo album
  Future<String?> showAlbumnDialog(
      String text, String? albumId, BuildContext? wrapContext) {
    return showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actionsAlignment: MainAxisAlignment.center,
        title: Text(text,
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 23,
                color: Colors.black87,
                letterSpacing: 1.25,
                fontWeight: FontWeight.w500)),
        content: SizedBox(
          width: MediaQuery.of(dialogContext).size.width * .9,
          child: Form(
            key: _formKey,
            child: GetUserInput(
                label: "",
                hint: "Your new album name",
                isPassword: false,
                validator: Validation.blankValidation,
                controller: albumId == null
                    ? _addAlbumController
                    : _editAlbumController),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                albumId == null
                    ? context
                        .read<AlbumListBloc>()
                        .add(AddNewAlbum(_addAlbumController.value.text))
                    : context.read<AlbumListBloc>().add(
                        EditAlbum(_editAlbumController.value.text, albumId));
                Navigator.of(dialogContext).pop();
                if (wrapContext != null) {
                  Navigator.of(wrapContext).pop();
                }
              }
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
      child: BlocListener<AlbumListBloc, AlbumListState>(
        listener: (context, state) async {
          final status = state.status;
          if (status is ErrorStatus) {
            String errorMessage = getErrorMessage(status.exception.toString());
            _getDialog(errorMessage, 'Error !', () => Navigator.pop(context));
          } else if (status is DeleteAlbumStatus) {
            await _getDialog(
              "Delete Album successfully", 'Success !', () => Navigator.pop(context));
          }
        },
        child: BlocBuilder<AlbumListBloc, AlbumListState>(
          builder: (context, state) {
            return GridView.builder(
              controller: _scrollController,
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
                albumName,
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
            // albumName != "Save Post Storage" &&
            albumName != "Poll Post Storage"
                ? SizedBox(
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
                        showAlbumnDialog("Edit Album", albumId, wrapContext);
                      },
                    ),
                  )
                : const Text(
                    "",
                  ),
            // albumName != "Save Post Storage" &&
            albumName != "Poll Post Storage"
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
                      onTap: () async {
                        await showDeleteDialog(albumId);
                        Navigator.pop(wrapContext);
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
  Future<void> showDeleteDialog(String albumId) {
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actionsAlignment: MainAxisAlignment.center,
        title: const Text('Delete',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 23,
                color: Colors.black87,
                letterSpacing: 1.25,
                fontWeight: FontWeight.w500)),
        content: const Text('Are you sure you want to delete this Album?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.black87,
              letterSpacing: 1.25,
            )),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              context.read<AlbumListBloc>().add(DeleteAlbum(albumId));
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              'OK',
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.black87, fontSize: 20),
            ),
          ),
        ],
      ),
    );
  }
}
