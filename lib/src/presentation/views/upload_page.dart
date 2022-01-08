import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/style.dart';
import '../widgets/global_widgets.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({
    Key? key,
    this.image,
  }) : super(key: key);
  final File? image;

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgApp,
      appBar: getAppBar(),
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                getImg(),
                SizedBox(
                  height: 15.h,
                ),
                getPostCaption(
                  "assets/images/Kroni.jpg",
                ),
                SizedBox(
                  height: 15.h,
                ),
                getAlbumContestSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container getAlbumContestSection() {
    List<String> albumList = [
      'Default album',
      'Dog album',
      'Cat album',
    ];
    List<String> contestList = [
      'None',
      'September holidays',
      'Food around the world',
      'Mood pictures'
    ];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 15),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      child: Center(
        child: Column(
          children: [
            getItemPicker("Choose an album for your picture",
                albumList), //TODO: nhét list albumn vào đây
            const SizedBox(
              height: 20,
            ),
            getItemPicker("Do you wanna join a contest ?",
                contestList), //TODO: nhét list contest vào đây
          ],
        ),
      ),
    );
  }

  Column getItemPicker(String label, List<String> itemList) {
    String dropdownValue = itemList.first;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
              fontSize: 22, color: Colors.black87, fontWeight: FontWeight.w600),
        ),
        const SizedBox(
          height: 5,
        ),
        DropdownButton<String>(
          isExpanded: true,
          borderRadius: BorderRadius.circular(25),
          underline: const SizedBox.shrink(),
          value: dropdownValue,
          iconSize: 24,
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          items: itemList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  AppBar getAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(
          Icons.close_rounded,
          size: 30.sp,
        ),
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      titleSpacing: 0,
      elevation: 0,
      title: const AppBarTitle(title: "New Post"),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 5),
          child: IconButton(
            onPressed: () => {},
            icon: const Icon(
              Icons.arrow_forward_rounded,
              size: 30,
              color: Colors.blueAccent,
            ),
          ),
        )
      ],
    );
  }

  AspectRatio getImg() {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        height: 400.h,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(25),
          ),
        ),
        child: Container(
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            image: DecorationImage(
              image: FileImage(
                  widget.image!), //TODO: nhét ảnh vừa chụp hoặc chọn vào đây
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }

  Container getPostCaption(String userAvatar) {
    Size size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: TextFormField(
        style: const TextStyle(
          fontSize: 18,
        ),
        textAlignVertical: TextAlignVertical.center,
        initialValue:
            "1 con ngựa xòe ra 2 cái cánh", //TODO: caption cho thằng AI nhét vào đây
        minLines: null,
        maxLines: null,
        expands: true,
        decoration: InputDecoration(
          icon: SizedBox(
            width: size.width * .13,
            height: size.width * .13,
            child: CircleAvatar(
              child: ClipOval(
                child: Image(
                  width: size.width * .13,
                  height: size.width * .13,
                  image: AssetImage(userAvatar),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          suffixIcon: IconButton(
            padding: const EdgeInsets.all(0),
            onPressed: () {
              //TODO: Fetch caption mới ở đây
            },
            icon: const Icon(
              Icons.refresh_rounded,
              size: 40,
              color: Colors.blueAccent,
            ),
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
