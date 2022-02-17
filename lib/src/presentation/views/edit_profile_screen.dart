import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/controller/edit_profile/edit_profile_bloc.dart';
import 'package:imagecaptioning/src/presentation/widgets/get_user_input_field.dart';
import 'package:imagecaptioning/src/presentation/widgets/global_widgets.dart';
import 'package:imagecaptioning/src/utils/func.dart';
import 'package:imagecaptioning/src/utils/validations.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _usernameController = TextEditingController();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool firstInit = true;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: getAppBar(context),
      body: getBody(),
    );
  }

  Future refreshNetworkImage(String url) async {
    NetworkImage provider = NetworkImage(url);
    await provider.evict();
  }

  SafeArea getBody() {
    return SafeArea(
      child: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            child: BlocListener<EditProfileBloc, EditProfileState>(
              listener: (context, state) async {
                final status = state.status;
                if (status is EditProfileSuccess) {
                  if (state.user?.avataUrl != null) {
                    refreshNetworkImage(
                        avatarUrl + state.user!.avataUrl.toString());
                  }

                  Navigator.pop(context);
                }
                if (status is ErrorStatus) {
                  String errorMessage =
                      getErrorMessage(status.exception.toString());
                  await _getDialog(
                      errorMessage, 'Error !', () => Navigator.pop(context));
                  // context
                  //     .read<EditProfileBloc>()
                  //     .add(EditProfileInitializing());
                }
              },
              child: BlocBuilder<EditProfileBloc, EditProfileState>(
                builder: (context, state) {
                  if (state.status is FinishInitializing ||
                      state.status is ErrorStatus) {
                    if (firstInit) {
                      _usernameController.text = state.user?.userName ?? '';
                      _nameController.text = state.user?.userRealName ?? '';
                      _descController.text = state.user?.description ?? '';
                      _emailController.text = state.user?.userEmail ?? '';
                      _phoneController.text = state.user?.phone ?? '';
                      firstInit = false;
                    }

                    if (state.user?.avataUrl != null) {
                      refreshNetworkImage(
                          avatarUrl + state.user!.avataUrl.toString());
                    }

                    return Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: 100.h,
                            width: 100.h,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                image: state.avatarChanged
                                    ? Image.file(
                                            File((state.avatarPath.toString())))
                                        .image
                                    : state.avatarPath != null
                                        ? NetworkImage(avatarUrl +
                                            state.avatarPath.toString())
                                        : const AssetImage(
                                                "assets/images/avatar_placeholder.png")
                                            as ImageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                                primary: Colors.blue,
                                textStyle: TextStyle(fontSize: 19.sp)),
                            child: const Text("Change profile picture"),
                            onPressed: () => getUploadButton(),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //username
                          GetUserInput(
                            controller: _usernameController,
                            label: "Username",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //name
                          GetUserInput(
                            controller: _nameController,
                            label: "Name",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //bio
                          GetUserInput(
                            controller: _descController,
                            label: "Bio",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //Email
                          GetUserInput(
                            controller: _emailController,
                            label: "Email",
                            validator: Validation.emailValidation,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          //Phone
                          GetUserInput(
                            controller: _phoneController,
                            label: "Phone",
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  void getUploadButton() {
    final list = <PopupMenuEntry<int>>[];
    list.add(
      getUploadMenuItem(ImageSource.gallery, "Gallery", Icons.grid_on_rounded),
    );
    list.add(
      const PopupMenuDivider(),
    );
    list.add(
      getUploadMenuItem(
          ImageSource.camera, "Camera", Icons.camera_enhance_outlined),
    );
    showMenu(
        context: context,
        position: const RelativeRect.fromLTRB(25, 25, 0, 0),
        items: list);
  }

  Padding getUserDetail(
    String label,
    String value,
    String? Function(String?)? function,
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
          Navigator.of(context).pop(true);
        },
      ),
      title: const AppBarTitle(title: "Edit Profile"),
      actions: [
        BlocBuilder<EditProfileBloc, EditProfileState>(
          builder: (context, state) {
            return IconButton(
              onPressed: () {
                context.read<EditProfileBloc>().add(SaveProfileChanges(
                    username: _usernameController.value.text,
                    email: _emailController.value.text,
                    phone: _phoneController.value.text,
                    desc: _descController.value.text,
                    userRealName: _nameController.value.text,
                    avatar: state.avatarPath ?? ''));
              },
              icon: const Icon(
                Icons.done_rounded,
                size: 35,
                color: Colors.lightBlue,
              ),
            );
          },
        )
      ],
    );
  }

  PopupMenuItem<int> getUploadMenuItem(
      ImageSource source, String label, IconData iconData) {
    return PopupMenuItem(
      onTap: () async {
        final newAvatar = await pickAvatar(source, context);
        if (newAvatar != null) {
          context.read<EditProfileBloc>().add(ChangeAvatar(newAvatar));
        }
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
