import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imagecaptioning/src/presentation/widgets/get_user_input_field.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';

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
      body: getBody(),
    );
  }

  SafeArea getBody() {
    List<String> genderList = [
      'Male',
      'Female',
      'Other',
    ];
    String initValue = genderList.first;
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
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
                const SizedBox(
                  height: 20,
                ),
                //username
                const GetUserInput(
                  label: "Username",
                  initValue: "thieen__aan",
                ),
                const SizedBox(
                  height: 20,
                ),
                //name
                const GetUserInput(
                  label: "Name",
                  initValue: "Thiên Ân",
                ),
                const SizedBox(
                  height: 20,
                ),
                //bio
                const GetUserInput(
                  label: "Bio",
                  initValue: "WRYYYYYYYYYYYYYYYYYYYYYYYYYYYYYYY",
                ),
                const SizedBox(
                  height: 20,
                ),
                //Email
                const GetUserInput(
                  label: "Email",
                  initValue: "AnDepTrai@Gmail.com",
                ),
                const SizedBox(
                  height: 20,
                ),
                //Phone
                const GetUserInput(
                  label: "Phone",
                  initValue: "0123456789",
                ),
                const SizedBox(
                  height: 20,
                ),
                //Gender
                Stack(
                  children: [
                    const AbsorbPointer(
                        child: GetUserInput(
                      label: "Gender",
                    )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22.0, vertical: 4.5),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        borderRadius: BorderRadius.circular(25),
                        underline: const SizedBox.shrink(),
                        value: initValue,
                        iconSize: 24,
                        onChanged: (String? newValue) {
                          setState(() {
                            initValue = newValue!;
                          });
                        },
                        items: genderList
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                )
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
      titleSpacing: 0,
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
      title: const AppBarTitle(title: "Edit Profile"),
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
