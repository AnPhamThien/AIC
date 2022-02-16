import 'followee.dart';
import 'post.dart';

class ListPostData {
  ListPostData({
    required this.posts,
    required this.followees,
  });

  List<Post> posts;
  List<Followee> followees;

  factory ListPostData.fromJson(Map<String, dynamic> json) => ListPostData(
        posts: json["posts"] != null
            ? List<Post>.from(json["posts"].map((x) => Post.fromJson(x)))
            : [],
        followees: json["followees"] != null
            ? List<Followee>.from(
                json["followees"].map((x) => Followee.fromJson(x)))
            : [],
      );

  Map<String, dynamic> toJson() => {
        "posts": List<dynamic>.from(posts.map((x) => x.toJson())),
        "followees": List<dynamic>.from(followees.map((x) => x.toJson())),
      };
}
