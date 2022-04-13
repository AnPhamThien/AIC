import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/constant/env.dart';
import 'package:imagecaptioning/src/controller/auth/auth_bloc.dart';
import 'package:imagecaptioning/src/controller/get_it/get_it.dart';
import 'package:imagecaptioning/src/controller/home/home_bloc.dart';
import 'package:imagecaptioning/src/controller/post/post_bloc.dart';
import 'package:imagecaptioning/src/controller/profile/profile_bloc.dart';
import 'package:imagecaptioning/src/model/category/category.dart';
import 'package:imagecaptioning/src/model/post/post.dart';
import 'package:imagecaptioning/src/prefs/app_prefs.dart';
import 'package:imagecaptioning/src/utils/func.dart';
import 'package:imagecaptioning/src/utils/validations.dart';

import 'get_user_input_field.dart';
import 'global_widgets.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({Key? key, required this.post, required this.isInContest})
      : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();

  final Post post;
  final bool isInContest;
}

class _PostWidgetState extends State<PostWidget> {
  late Post post;

  @override
  void initState() {
    post = widget.post;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    post = widget.post;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      height: 580.h,
      child: GestureDetector(
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostHeadlineWidget(
                  userId: post.userId!,
                  username: post.userName!,
                  caption:
                      post.userCaption ?? post.aiCaption ?? "",
                  time: post.dateCreate!,
                  postAvatar: post.avataUrl,
                  postId: post.postId!,
                  isSave: post.isSaved!,
                  contestId: post.contestId,
                ),
                PostImgWidget(postImage: widget.post.imageUrl ?? ""),
                PostIconWidget(
                  postId: widget.post.postId!,
                  isLike: widget.post.isLike!,
                  post: widget.post,
                ),
                PostDescription(
                  username: widget.post.userName ?? "",
                  caption:
                      widget.post.userCaption ?? widget.post.aiCaption ?? "",
                  likeCount: widget.post.likecount!,
                ),
              ],
            ),
          ),
        ),
        onTap: () async {
          // ignore: unnecessary_null_comparison
          if (post != null) {
            Map<String, dynamic> args = {
              'post': post,
              'isInContest': widget.isInContest
            };
            final Post? _post = await Navigator.pushNamed(
              context,
              AppRouter.postDetailScreen,
              arguments: args,
            ) as Post?;

            if (_post == null) {
              setState(() {
                context.read<HomeBloc>().add(PostListReset());
                context.read<HomeBloc>().add(InitPostFetched());
              });

              return;
            }
            setState(() {
              if (context.read<ProfileBloc?>() != null) {
                context.read<ProfileBloc>().add(ProfileInitializing(""));
              }
              post = _post;
            });
          }
        },
      ),
    );
  }
}

//* HEADLINE CỦA POST
class PostHeadlineWidget extends StatefulWidget {
  const PostHeadlineWidget({
    Key? key,
    required this.userId,
    required this.username,
    required this.caption,
    required this.time,
    required this.postAvatar,
    required this.postId,
    this.route,
    required this.isSave,
    this.contestId,
  }) : super(key: key);

  final String userId;
  final String username;
  final String caption;
  final DateTime time;
  final String? postAvatar;
  final String postId;
  final String? route;
  final int isSave;
  final String? contestId;

  @override
  State<PostHeadlineWidget> createState() => _PostHeadlineWidgetState();
}

class _PostHeadlineWidgetState extends State<PostHeadlineWidget> {
  final _updatePostController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    context.read<PostBloc>().add(GetCategory());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _calculatedTime = timeCalculate(widget.time);
    Map<String, dynamic> args = {'userId': widget.userId};
    _updatePostController.text = widget.caption;
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 15),
      onTap: () => widget.userId != getIt<AppPref>().getUserID
          ? context.read<AuthBloc>().add(NavigateToPageEvent(
              route: AppRouter.otherUserProfileScreen, args: args))
          : context.read<AuthBloc>().add(
              NavigateToPageEvent(route: AppRouter.currentUserProfileScreen)),
      leading: Container(
        width: 45,
        height: 45,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54),
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          child: ClipOval(
            child: Image(
              image: widget.postAvatar != null
                  ? NetworkImage(avatarUrl + widget.postAvatar!)
                  : const AssetImage("assets/images/avatar_placeholder.png")
                      as ImageProvider,
              height: 45,
              width: 45,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: Text(
        widget.username,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
      ),
      subtitle: Text(_calculatedTime),

      ///options
      trailing: SizedBox(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              child: widget.contestId != null
                  ? RadiantGradientMask(
                      child: IconButton(
                        onPressed: () async {
                          await Navigator.pushNamed(
                              context, AppRouter.contestListScreen);
                          context.read<HomeBloc>().add(InitPostFetched());
                        },
                        icon: const Icon(
                          Icons.emoji_events_outlined,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                    )
                  : null,
            ),
            BlocListener<PostBloc, PostState>(
              listener: (context, state) {
                if (state.status == PostStatus.reported) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(
                        content: Text('This post has been reported! Please wait for the system to process.'),
                        duration: Duration(seconds: 5),
                      ))
                      .closed
                      .then((value) =>
                          ScaffoldMessenger.of(context).clearSnackBars());
                  context.read<PostBloc>().add(Reset());
                }
                if (state.status == PostStatus.save) {
                  if (state.isSaved == true) {
                    ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(
                        content: Text('This post has been saved! Please check your profile.'),
                        duration: Duration(seconds: 5),
                      ))
                      .closed
                      .then((value) =>
                          ScaffoldMessenger.of(context).clearSnackBars());
                    setState(() {
                      widget.isSave == 1;
                      context.read<PostBloc>().add(Reset());
                      if (context.read<ProfileBloc?>() != null) {
                        context
                            .read<ProfileBloc>()
                            .add(ProfileInitializing(""));
                      }
                    });
                  } else {
                    setState(() {
                      widget.isSave == 0;
                      context.read<PostBloc>().add(Reset());
                      if (context.read<ProfileBloc?>() != null) {
                        context
                            .read<ProfileBloc>()
                            .add(ProfileInitializing(""));
                      }
                    });
                  }
                }
              },
              child: BlocBuilder<PostBloc, PostState>(
                builder: (context, state) {
                  return PopupMenuButton(
                    onSelected: (value) async {
                      switch (value) {
                        case 'delete':
                          return showDeleteDialog();
                        case 'report':
                          return showReportDialog(
                              state.categoryList, widget.postId);
                        case 'unsave':
                          context.read<PostBloc>().add(
                                UnsavePost(widget.postId),
                              );
                          break;
                        case 'save':
                          context.read<PostBloc>().add(SavePost(widget.postId));
                          break;
                        case 'update':
                          return showUpdateDialog(
                              'Update caption', widget.postId);
                        default:
                          return;
                      }
                    },
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: Colors.black87,
                      size: 27,
                    ),
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    offset: const Offset(-10, 45),
                    elevation: 10,
                    itemBuilder: (context) {
                      if (isUser(widget.userId)) {
                        return <PopupMenuEntry>[
                          PopupMenuItem(
                              value: 'delete',
                              child: getPopupMenuItem(
                                  "Delete", Icons.delete_outline_rounded)),
                          PopupMenuItem(
                              value: 'update',
                              child: getPopupMenuItem(
                                  "Update caption", Icons.edit_rounded))
                        ];
                      }

                      return <PopupMenuEntry>[
                        PopupMenuItem(
                            value: 'report',
                            child: getPopupMenuItem(
                                "Report", Icons.error_outline_rounded)),
                        widget.isSave == 1
                            ? PopupMenuItem(
                                value: 'unsave',
                                child: getPopupMenuItem(
                                    "Unsave post", Icons.bookmark_rounded))
                            : PopupMenuItem(
                                value: 'save',
                                child: getPopupMenuItem("Save post",
                                    Icons.bookmark_border_rounded)),
                      ];
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> showUpdateDialog(String text, String postId) {
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
                hint: "Your new caption",
                isPassword: false,
                validator: Validation.blankValidation,
                controller: _updatePostController),
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context
                    .read<PostBloc>()
                    .add(UpdatePost(postId, _updatePostController.value.text));
                Navigator.of(dialogContext).pop();
              }
            },
            child: const Text(
              'Finish',
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
          )
          
        ],
      ),
    );
  }

  Future<void> showDeleteDialog() {
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
        content: const Text('Are you sure you want to delete this post?',
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
              context.read<HomeBloc>().add(DeletePost(widget.postId));
              if (context.read<ProfileBloc?>() != null) {
                context.read<ProfileBloc>().add(ProfileInitializing(""));
              }
              if (widget.route != null) {
                Navigator.pop(context, null);
                Navigator.of(context).popAndPushNamed(
                  widget.route!,
                );
              }
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

  Future<void> showReportDialog(List<Category> categoryList, String postId) {
    final _reportDesciption = TextEditingController();
    Category? value = categoryList.first;
    return showDialog(
      context: context,
      builder: (BuildContext dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actionsAlignment: MainAxisAlignment.center,
        title: const Text('Report Post',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 23,
                color: Colors.black87,
                letterSpacing: 1.25,
                fontWeight: FontWeight.w500)),
        content: SizedBox(
          width: MediaQuery.of(dialogContext).size.width * .9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<Category>(
                  decoration: const InputDecoration.collapsed(hintText: ''),
                  value: value,
                  isExpanded: true,
                  onSaved: (Category? newValue) {
                    setState(() {
                      value = newValue!;
                    });
                  },
                  onChanged: (Category? newValue) {
                    setState(() {
                      value = newValue!;
                    });
                  },
                  items: categoryList
                      .map<DropdownMenuItem<Category>>((Category value) {
                    return DropdownMenuItem(
                        value: value,
                        child: Text(
                          value.categoryName!,
                        ));
                  }).toList()),
              const SizedBox(
                height: 20,
              ),
              GetUserInput(
                label: "",
                hint: "Report description",
                isPassword: false,
                controller: _reportDesciption,
              ),
            ],
          ),
        ),
        contentPadding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              context
                  .read<PostBloc>()
                  .add(ReportPost(postId, value!.id!, _reportDesciption.text));
              Navigator.of(dialogContext).pop();
            },
            child: const Text(
              'Report',
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

  ListTile getPopupMenuItem(String title, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      leading: Icon(
        icon,
        color: Colors.black87,
        size: 30,
      ),
    );
  }
}

//* ẢNH CỦA POST
class PostImgWidget extends StatelessWidget {
  const PostImgWidget({
    Key? key,
    required this.postImage,
  }) : super(key: key);

  final String postImage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            image: DecorationImage(
              onError: (exception, stackTrace) => log(exception.toString()),
              image: postImage != ""
                  ? NetworkImage(postImageUrl + postImage)
                  : const AssetImage("assets/images/Kroni.jpg")
                      as ImageProvider,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

//* ICON CỦA POST
class PostIconWidget extends StatelessWidget {
  const PostIconWidget({
    Key? key,
    this.likeCount,
    this.commentCount,
    required this.isLike,
    this.post,
    required this.postId,
  }) : super(key: key);
  final String postId;
  final Post? post;
  final int? likeCount;
  final int? commentCount;
  final int isLike;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              isLike == 0
                  ? IconButton(
                      splashRadius: 23,
                      icon: const Icon(Icons.favorite_border_rounded),
                      iconSize: 30.0,
                      onPressed: () {
                        context.read<PostBloc>().add(LikePress(postId, isLike));
                      },
                    )
                  : IconButton(
                      splashRadius: 23,
                      icon: const Icon(
                        Icons.favorite_rounded,
                      ),
                      color: Colors.red,
                      iconSize: 30.0,
                      onPressed: () {
                        context.read<PostBloc>().add(LikePress(postId, isLike));
                      },
                    ),
              likeCount == null
                  ? const SizedBox.shrink()
                  : Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Text(
                        likeCount.toString(),
                        style: const TextStyle(
                          fontSize: 14.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
            ],
          ),
          Row(
            children: [
              IconButton(
                splashRadius: 23,
                onPressed: () async {
                  if (post != null) {
                    Map<String, dynamic> args = {'post': post};
                    await Navigator.pushNamed(
                        context, AppRouter.postDetailScreen,
                        arguments: args);
                  }
                },
                icon: SvgPicture.asset(
                  "assets/icons/comment_icon.svg",
                  color: Colors.black,
                  width: 24,
                  height: 24,
                ),
              ),
              commentCount == null
                  ? const SizedBox.shrink()
                  : Text(
                      commentCount.toString(),
                      style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}

//* DESCRIPTION CỦA POST
class PostDescription extends StatelessWidget {
  const PostDescription({
    Key? key,
    required this.likeCount,
    required this.username,
    required this.caption,
  }) : super(key: key);

  final int likeCount;
  final String username;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //LIKES
          Padding(
            padding: const EdgeInsets.only(bottom: 5),
            child: Text(
              likeCount < 2 ? "$likeCount like" : "$likeCount likes",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          //USERNAME & CAPTIONS
          RichText(
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              children: [
                TextSpan(
                  text: username,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                TextSpan(
                    text: "  " + caption,
                    style: const TextStyle(color: Colors.black))
              ],
            ),
          ),
          //COMMENTS
          Padding(
            padding: const EdgeInsets.only(top: 7),
            child: Text(
              "View comments",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ),
        ],
      ),
    );
  }
}
