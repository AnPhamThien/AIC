import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:imagecaptioning/src/app/routes.dart';
import 'package:imagecaptioning/src/constanct/env.dart';
import 'package:imagecaptioning/src/controller/auth/auth_bloc.dart';
import 'package:imagecaptioning/src/model/post/post.dart';
import 'package:imagecaptioning/src/presentation/theme/style.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';

class PostWidget extends StatefulWidget {
  const PostWidget({Key? key, required this.post}) : super(key: key);

  @override
  _PostWidgetState createState() => _PostWidgetState();

  final Post post;
}

class _PostWidgetState extends State<PostWidget> {
  @override
  Widget build(BuildContext context) {
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
                    userId: widget.post.userId ?? "",
                    username: widget.post.userName ?? "",
                    time: widget.post.dateCreate ?? DateTime.now(),
                    postAvatar: widget.post.avataUrl ?? ""),
                PostImgWidget(postImage: widget.post.imageUrl ?? ""),
                const PostIconWidget(),
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
        onTap: () {
          Map<String, dynamic> args = {'post': widget.post};

          context.read<AuthBloc>().add(NavigateToPageEvent(
                route: AppRouter.postDetailScreen,
                args: args,
              ));
        },
      ),
    );
  }
}

//* HEADLINE CỦA POST
class PostHeadlineWidget extends StatelessWidget {
  const PostHeadlineWidget({
    Key? key,
    required this.userId,
    required this.username,
    required this.time,
    required this.postAvatar,
  }) : super(key: key);

  final String userId;
  final String username;
  final DateTime time;
  final String postAvatar;

  @override
  Widget build(BuildContext context) {
    final hourCount = DateTime.now().difference(time).inHours;
    String timeCount;
    if (hourCount < 1) {
      timeCount =
          DateTime.now().difference(time).inMinutes.toString() + " mins";
    } else if (hourCount < 24 && hourCount > 1) {
      timeCount = hourCount.toString() + " hours";
    } else if (hourCount > 24 && hourCount < 730) {
      timeCount = DateTime.now().difference(time).inDays.toString() + " days";
    } else {
      timeCount =
          (DateTime.now().difference(time).inDays / 30).round().toString() +
              " months";
    }
    Map<String, dynamic> args = {'userId': userId};
    return ListTile(
      onTap: () => context.read<AuthBloc>().add(NavigateToPageEvent(
          route: AppRouter.otherUserProfileScreen, args: args)),
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
              image: postAvatar != ""
                  ? NetworkImage(avatarUrl + postAvatar)
                  : const AssetImage("assets/images/Kroni.jpg")
                      as ImageProvider,
              height: 45,
              width: 45,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: Text(
        username,
        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 17),
      ),
      subtitle: Text(timeCount),

      ///options
      trailing: PopupMenuButton(
        icon: const Icon(
          Icons.more_vert_rounded,
          color: Colors.black87,
          size: 27,
        ),
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        offset: const Offset(-10, 45),
        elevation: 10,
        itemBuilder: (context) => <PopupMenuEntry>[
          PopupMenuItem(
            onTap: () {}, //TODO hàm Report ở đây
            child: Row(
              children: const [
                Text("Report"),
                Icon(
                  Icons.error_outline_rounded,
                  color: Colors.black87,
                  size: 30,
                ),
              ],
            ),
          )
        ],
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
              image: postImage != ""
                  ? NetworkImage(postImageUrl + postImage)
                  : const AssetImage("assets/images/Kroni.jpg")
                      as ImageProvider,
              fit: BoxFit.fill,
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
    this.isLike,
  }) : super(key: key);

  final int? likeCount;
  final int? commentCount;
  final int? isLike;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Row(
                children: [
                  isLike == 0
                      ? IconButton(
                          splashRadius: 23,
                          icon: const Icon(Icons.favorite_border_rounded),
                          iconSize: 30.0,
                          onPressed: () {}, //TODO hàm Like ở đây
                        )
                      : IconButton(
                          splashRadius: 23,
                          icon: const Icon(
                            Icons.favorite_rounded,
                          ),
                          color: Colors.red,
                          iconSize: 30.0,
                          onPressed: () {}, //TODO hàm DisLike ở đây
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
                    onPressed: () {}, //TODO hàm comment ở đây
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
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            iconSize: 30.0,
            onPressed: () {}, //TODO hàm save ở đây
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
              "$likeCount likes",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          //USERNAME & CAPTIONS
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: username,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextSpan(
                  text: "  " + caption,
                )
              ],
            ),
          ),
          //COMMENTS
          const Padding(
            padding: EdgeInsets.only(top: 5),
            child: Text(
              "View comments",
              style: TextStyle(color: bgGrey),
            ),
          ),
        ],
      ),
    );
  }
}
