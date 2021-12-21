import 'followee.dart';
import 'post.dart';

class Data {
  Data({
    required this.posts,
    required this.followees,
  });

  List<Post> posts;
  List<Followee> followees;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
        followees: List<Followee>.from(
            json["followees"].map((x) => Followee.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "posts": List<dynamic>.from(posts.map((x) => x.toJson())),
        "followees": List<dynamic>.from(followees.map((x) => x.toJson())),
      };
}
