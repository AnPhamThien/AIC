import 'package:flutter/material.dart';
import 'package:imagecaptioning/src/data_local/markup_model.dart';
import 'package:imagecaptioning/src/presentation/views/album_screen.dart';
import 'package:imagecaptioning/src/presentation/widgets/get_user_input_field.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';

class AlbumListScreen extends StatefulWidget {
  const AlbumListScreen({Key? key}) : super(key: key);

  @override
  _AlbumListScreenState createState() => _AlbumListScreenState();
}

class _AlbumListScreenState extends State<AlbumListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(),
      body: getBody(),
    );
  }

  AppBar getAppBar() {
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
      builder: (BuildContext context) => AlertDialog(
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
          width: MediaQuery.of(context).size.width * .9,
          child: const GetUserInput(
              label: "", hint: "Your new album name", isPassword: false),
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              //TODO Thêm hàm tạo album
              Navigator.of(context).pop();
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
    List<Album> albumList = Album.getAlbumList();
    return SafeArea(
      child: GridView.builder(
        padding: const EdgeInsets.all(15),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            childAspectRatio: 2 / 2.35,
            crossAxisCount: 2,
            crossAxisSpacing: 15,
            mainAxisSpacing: 10),
        itemCount: albumList.length,
        itemBuilder: (_, index) {
          final Album album = albumList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlbumScreen(
                    album: album,
                  ),
                ),
              );
            },
            onLongPress: () {
              getSheet(context, album.albumName);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: album.albumImages.isNotEmpty
                        ? BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                                image: AssetImage(album.albumImages.first),
                                fit: BoxFit.cover),
                          )
                        : BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(25),
                          ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 7.0, horizontal: 3),
                  child: Text(
                    album.albumName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<dynamic> getSheet(BuildContext context, String albumName) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      enableDrag: true,
      context: context,
      builder: (context) {
        return Wrap(
          direction: Axis.vertical,
          children: [
            const SizedBox(height: 10),
            const SheetLine(),
            SizedBox(
              width: MediaQuery.of(context).size.width,
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
              width: MediaQuery.of(context).size.width,
              child: const Divider(
                color: Colors.grey,
                height: 25,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
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
              width: MediaQuery.of(context).size.width,
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
                  //TODO hàm delete album
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
