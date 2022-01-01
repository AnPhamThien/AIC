import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import '../../data_local/markup_model.dart';
import '../theme/style.dart';
import '../widgets/global_widgets.dart';
import '../../utils/func.dart';

class ContestScreen extends StatefulWidget {
  const ContestScreen({Key? key, required this.contest}) : super(key: key);

  final Contest contest;

  @override
  _ContestScreenState createState() => _ContestScreenState();
}

class _ContestScreenState extends State<ContestScreen> {
  //List<Post> postList = Post.getPostList();
  @override
  Widget build(BuildContext context) {
    Contest contest = widget.contest;
    return Scaffold(
      backgroundColor: bgApp,
      floatingActionButton: getUploadButton(),
      appBar: AppBar(
        foregroundColor: Colors.black87,
        elevation: 0,
        titleSpacing: 0,
        title: AppBarTitle(title: contest.contestName),
        actions: [
          IconButton(
            onPressed: () {
              getSheet(context, contest);
            },
            icon: const Icon(
              Icons.info_outlined,
              size: 30,
            ),
          )
        ],
      ),
      // body: SafeArea(
      //   child: SingleChildScrollView(
      //       child: SizedBox(
      //     height: MediaQuery.of(context).size.height,
      //     child: ListView.builder(
      //       itemCount: postList.length,
      //       itemBuilder: (_, index) {
      //         final Post post = postList[index];
      //         return PostWidget(
      //           post: post,
      //         );
      //       },
      //     ),
      //   )),
      // ),
    );
  }

  Future<dynamic> getSheet(BuildContext context, Contest contest) {
    return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      enableDrag: true,
      context: context,
      builder: (context) {
        String startDate =
            contest.startDate.toLocal().toIso8601String().split('T').first;
        String endDate =
            contest.endDate.toLocal().toIso8601String().split('T').first;
        return Wrap(
          direction: Axis.vertical,
          children: [
            const SizedBox(height: 10),
            const SheetLine(),
            //* contest name
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Text(
                contest.contestName, //TODO nhét contest name vào đây
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
            //* end,start date
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black54, fontSize: 16),
                  children: [
                    TextSpan(
                      text: ("From: " +
                          startDate), //TODO nhét contest startdate vào đây
                    ),
                    TextSpan(
                      text: ("\nTo: " +
                          endDate), //TODO nhét contest enddate vào đây
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            //* description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                contest.description,
                softWrap: true,
                style: const TextStyle(color: Colors.black87, fontSize: 19),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        );
      },
    );
  }

  Theme getUploadButton() {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerTheme:
            const DividerThemeData(color: Colors.grey, thickness: 0.5),
      ),
      child: PopupMenuButton(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        offset: const Offset(65, -150),
        elevation: 10,
        itemBuilder: (context) {
          final list = <PopupMenuEntry<int>>[];
          list.add(
            getUploadMenuItem(
                ImageSource.gallery, "Gallery", Icons.grid_on_rounded),
          );
          list.add(
            const PopupMenuDivider(),
          );
          list.add(
            getUploadMenuItem(
                ImageSource.camera, "Camera", Icons.camera_enhance_outlined),
          );
          return list;
        },
        child: Container(
          width: 108,
          height: 48,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(
              Radius.circular(25),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: SvgPicture.asset(
                  "assets/icons/upload_icon.svg",
                  width: 25,
                  height: 25,
                  color: Colors.white,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: Text(
                  "JOIN",
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 1.25,
                      color: Colors.white),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<int> getUploadMenuItem(
      ImageSource source, String label, IconData iconData) {
    return PopupMenuItem(
      onTap: () {
        pickImage(source, context);
      },
      textStyle: const TextStyle(
          fontSize: 20, fontWeight: FontWeight.w400, color: Colors.black),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Icon(
            iconData,
            color: Colors.black87,
            size: 30,
          ),
        ],
      ),
    );
  }
}
