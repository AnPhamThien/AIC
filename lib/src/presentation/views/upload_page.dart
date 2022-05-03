import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/constant/error_message.dart';
import 'package:imagecaptioning/src/utils/func.dart';
import 'package:imagecaptioning/src/utils/validations.dart';
import '../../controller/get_it/get_it.dart';
import '../../controller/upload/upload_bloc.dart';
import '../../model/album/album.dart';
import '../../model/contest/contest.dart';
import '../../prefs/app_prefs.dart';

import '../theme/style.dart';
import '../widgets/global_widgets.dart';

class UploadScreen extends StatefulWidget {
  const UploadScreen({
    Key? key,
  }) : super(key: key);

  @override
  _UploadScreenState createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  String? selectedAlbumId;
  String? selectedContestId;
  bool joinContest = false;
  final _captionController = TextEditingController();
  final _formKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UploadBloc, UploadState>(
      listener: (context, state) async {
        _captionController.text = state.aiCaption;
        final status = state.status;
        if (status is ErrorStatus) {
          String errorMessage = getErrorMessage(status.exception.toString());
          if (errorMessage ==
              MessageCode.errorMap[MessageCode.duplicatePostInContest]) {
            await _getDialog(
                errorMessage, "Warning", () => Navigator.of(context).pop());
          } else {
            await _getDialog(
                errorMessage, 'Error !', () => Navigator.pop(context));
          }
        }
        if (status is UploadSuccess) {
          if (joinContest) {
            ScaffoldMessenger.of(context)
                .showSnackBar(const SnackBar(
                  content: Text(
                      'Please wait for approval from the managers to successfully join the contest.'),
                  duration: Duration(seconds: 5),
                ))
                .closed
                .then(
                    (value) => ScaffoldMessenger.of(context).clearSnackBars());
          }

          await _getDialog("Create post successfully.", 'Success !',
              () => Navigator.pop(context));
          Navigator.of(context).pop(status.post);
        }
      },
      child: Scaffold(
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
                  getPostCaption(),
                  SizedBox(
                    height: 15.h,
                  ),
                  getAlbumContestSection(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container getAlbumContestSection() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      child: Center(
        child: BlocBuilder<UploadBloc, UploadState>(
          builder: (context, state) {
            if (state.contestId == null) {
              return Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  state.contestList.isNotEmpty
                      ? ListTile(
                          title: const Text("Do you wanna join a poll ?"),
                          trailing: IconButton(
                              icon: joinContest
                                  ? const Icon(Icons.clear_rounded)
                                  : const Icon(Icons.check_box),
                              onPressed: () {
                                setState(() {
                                  joinContest = !joinContest;
                                  if (!joinContest) {
                                    selectedContestId = null;
                                  } else {
                                    selectedAlbumId = null;
                                  }
                                });
                              }))
                      : const Text(""),
                  joinContest
                      ? getItemPicker("Choose a poll for your picture",
                          state.contestList, 2)
                      : getItemPicker("Choose an album for your picture",
                          state.albumList, 1),
                ],
              );
            } else {
              joinContest = true;
              selectedContestId = state.contestId;
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }

  Column getItemPicker(String label, List<dynamic> itemList, int type) {
    String? dropdownValue;
    if (type == 1 && selectedAlbumId != null) {
      dropdownValue = selectedAlbumId;
    } else if (type == 2 && selectedContestId != null) {
      dropdownValue = selectedContestId;
    } else if (itemList.isNotEmpty) {
      dynamic first = itemList.first;
      String? firstItem;
      if (first is Album) {
        firstItem = first.id ?? 'Album';
        selectedAlbumId = firstItem;
      } else if (first is Contest) {
        firstItem = first.id;
        selectedContestId = firstItem;
      }
      dropdownValue = firstItem;
    }

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
              if (type == 1) {
                selectedAlbumId = dropdownValue;
              }

              if (type == 2) {
                selectedContestId = dropdownValue;
              }
            });
          },
          items: itemList.map<DropdownMenuItem<String>>((dynamic value) {
            if (value is Album) {
              return DropdownMenuItem<String>(
                value: value.id,
                child: Text(value.albumName ?? ''),
              );
            } else if (value is Contest) {
              return DropdownMenuItem<String>(
                value: value.id,
                child: Text(value.contestName ?? ''),
              );
            } else {
              return const DropdownMenuItem<String>(
                child: Text('Empty'),
              );
            }
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
            onPressed: () {
              if (context.read<UploadBloc>().state.imgPath != null &&
                  _formKey.currentState!.validate()) {
                context.read<UploadBloc>().add(SaveUploadPost(
                    albumId: selectedAlbumId,
                    contestId: selectedContestId,
                    userCaption: _captionController.value.text,
                    postImg: context.read<UploadBloc>().state.imgPath!));
              }
            },
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
        child: BlocBuilder<UploadBloc, UploadState>(
          builder: (context, state) {
            return Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                image: DecorationImage(
                  image: state.imgPath != null
                      ? Image.file(File((state.imgPath.toString()))).image
                      : const AssetImage(
                          "assets/images/avatar_placeholder.png"),
                  fit: BoxFit.fill,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Container getPostCaption() {
    Size size = MediaQuery.of(context).size;
    String avatarPath = getIt<AppPref>().getAvatarPath;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
      ),
      child: BlocBuilder<UploadBloc, UploadState>(
        builder: (context, state) {
          return TextFormField(
            enabled: !context.read<UploadBloc>().state.aiGenerationInProgress,
            controller: _captionController,
            key: _formKey,
            validator: Validation.blankValidation,
            style: const TextStyle(
              fontSize: 18,
            ),
            textAlignVertical: TextAlignVertical.center,
            // initialValue:
            //     "1 con ngựa xòe ra 2 cái cánh",
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
                      image: avatarPath.isNotEmpty
                          ? NetworkImage(avatarUrl + avatarPath)
                          : const AssetImage(
                                  "assets/images/avatar_placeholder.png")
                              as ImageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              //   suffixIcon: BlocBuilder<UploadBloc, UploadState>(
              //     builder: (context, state) {
              //       bool aiGenerationInProgress =
              // context.read<UploadBloc>().state.aiGenerationInProgress;
              //       return IconButton(
              //         padding: const EdgeInsets.all(0),
              //         onPressed: () {
              //           log(aiGenerationInProgress.toString());
              //           if (!aiGenerationInProgress) {
              //             context.read<UploadBloc>().add(RequestCaption(
              //                 postImg:
              //                     context.read<UploadBloc>().state.originalImgPath!));
              //           }
              //         },
              //         icon: Icon(
              //           aiGenerationInProgress ? Icons.stop : Icons.refresh_rounded,
              //           size: 40,
              //           color: Colors.blueAccent,
              //         ),
              //       );
              //     },
              //   ),
              border: InputBorder.none,
            ),
          );
        },
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
