import 'package:imagecaptioning/src/model/contest/prize.dart';

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
  List<Prize>? prizes;

  factory ContestData.fromJson(Map<String, dynamic> json) => ContestData(
        totalParticipaters: json["total_Participaters"],
        topThreePosts: json["top_ThreePosts"] != null
            ? List<Post>.from(
                json["top_ThreePosts"].map((x) => Post.fromJson(x)))
            : null,
        posts: json["posts"] != null
            ? List<Post>.from(json["posts"].map((x) => Post.fromJson(x)))
            : null,
        prizes: json["prizes"] != null
            ? List<Prize>.from(json["prizes"].map((x) => Prize.fromJson(x)))
            : null,
      );

  Map<String, dynamic> toJson() => {
        "total_Participaters": totalParticipaters,
        "top_ThreePosts": topThreePosts,
        "posts": posts,
        "prizes": List<dynamic>.from(prizes!.map((x) => x.toJson())),
      };
}
