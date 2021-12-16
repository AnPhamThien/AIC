import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:imagecaptioning/src/controller/profile/profile_bloc.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.imageSourceActionSheetIsVisible) {
          _showImageSourceActionSheet(context);
        }
      },
      child: Scaffold(
        appBar: getAppBar(context),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 100.h,
                    width: 100.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assets/images/Kroni.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        primary: Colors.blue,
                        textStyle: TextStyle(fontSize: 19.sp)),
                    child: const Text("Change profile picture"),
                    onPressed: () {},
                  ),
                  getUserDetail('Username', 'thieen__aan', null),
                  getUserDetail('Name', 'Thiên Ân', null),
                  getUserDetail(
                      'Bio', 'WRYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY', null),
                  getUserDetail('Email', 'AnDepTrai@Gmail.com', null),
                  getUserDetail('Phone', '0123456789', null),
                  getUserDetail('Gender', 'Male', null),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Padding getUserDetail(
    String label,
    String value,
    String Function(String?)? function,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        validator: function,
        initialValue: value,
        style: const TextStyle(fontSize: 18),
        cursorHeight: 25,
        maxLines: 1,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
          labelText: label,
          labelStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  AppBar getAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.clear_rounded,
          size: 35,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: const Text("Edit Profile"),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.done_rounded,
            size: 35,
            color: Colors.lightBlue,
          ),
        )
      ],
    );
  }

  void _showImageSourceActionSheet(BuildContext context) {
    selectImageSource(ImageSource imageSource) =>
        {context.read<ProfileBloc>().add(OpenImagePicker(imageSource))};

    if (Platform.isIOS) {
      showCupertinoModalPopup(
        context: context,
        builder: (context) => CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              child: const Text('Camera'),
              onPressed: () {
                Navigator.pop(context);
                selectImageSource(ImageSource.camera);
              },
            ),
            CupertinoActionSheetAction(
              child: const Text('Gallery'),
              onPressed: () {
                Navigator.pop(context);
                selectImageSource(ImageSource.gallery);
              },
            )
          ],
        ),
      );
    } else {
      showModalBottomSheet(
        context: context,
        builder: (context) => Wrap(children: [
          ListTile(
            leading: const Icon(Icons.camera_alt),
            title: const Text('Camera'),
            onTap: () {
              Navigator.pop(context);
              selectImageSource(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_album),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.pop(context);
              selectImageSource(ImageSource.gallery);
            },
          ),
        ]),
      );
    }
  }
}
