import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                getUserDetail('Bio', 'WRYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY', null),
                getUserDetail('Email', 'AnDepTrai@Gmail.com', null),
                getUserDetail('Phone', '0123456789', null),
                getUserDetail('Gender', 'Male', null),
              ],
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
}
