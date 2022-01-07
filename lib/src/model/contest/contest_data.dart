import '../post/post.dart';

class ContestData {
  ContestData({
    this.totalParticipaters,
    this.topThreePosts,
    this.posts,
    this.prizes,
  });

  int? totalParticipaters;
  List<Post>? topThreePosts;
  List<Post>? posts;
  List<dynamic>? prizes;

  factory ContestData.fromJson(Map<String, dynamic> json) => ContestData(
        totalParticipaters: json["total_Participaters"],
        topThreePosts: json["top_ThreePosts"] != null
            ? List<Post>.from(
                json["top_ThreePosts"].map((x) => Post.fromJson(x)))
            : null,
        posts: json["posts"] != null
            ? List<Post>.from(json["posts"].map((x) => Post.fromJson(x)))
            : null,
        prizes: List<dynamic>.from(json["prizes"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "total_Participaters": totalParticipaters,
        "top_ThreePosts": List<Post>.from(topThreePosts!.map((x) => x)),
        "posts": List<Post>.from(posts!.map((x) => x)),
        "prizes": List<dynamic>.from(prizes!.map((x) => x)),
      };
}
