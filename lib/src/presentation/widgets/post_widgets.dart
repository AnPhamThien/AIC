import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class PostHeadlineWidget extends StatelessWidget {
  const PostHeadlineWidget({
    Key? key,
    required this.username,
    required this.posttime,
    required this.imagepath,
  }) : super(key: key);

  final String username;
  final int posttime;
  final String imagepath;

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
              image: AssetImage(imagepath),
              height: 45,
              width: 45,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      title: Text(
        username,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(posttime.toString() + " min"),

      ///options
      trailing: IconButton(
        splashRadius: 30,
        onPressed: () {},
        icon: Icon(
          Icons.more_vert_rounded,
          color: Colors.black,
          size: 27.sp,
        ),
      ),
    );
  }
}

class PostIconWidget extends StatelessWidget {
  const PostIconWidget({
    Key? key,
    this.likeCount,
    this.commentCount,
  }) : super(key: key);

  final int? likeCount;
  final int? commentCount;

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
                  IconButton(
                    splashRadius: 23,
                    icon: const Icon(Icons.favorite_border_rounded),
                    iconSize: 30.0,
                    onPressed: () {},
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
                    onPressed: () {},
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
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class PostImgWidget extends StatelessWidget {
  const PostImgWidget({
    Key? key,
    required this.imgPath,
  }) : super(key: key);

  final String imgPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 7),
      child: AspectRatio(
        aspectRatio: 1,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            image: DecorationImage(
              image: AssetImage(imgPath),
              fit: BoxFit.fill,
            ),
          ),
        ),
      ),
    );
  }
}
