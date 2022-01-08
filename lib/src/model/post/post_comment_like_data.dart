import 'comment.dart';

class PostCommentLikeData {
  PostCommentLikeData({
    this.comments,
    this.totalLike,
    this.totalComment,
  });

  List<Comment>? comments;
  int? totalLike;
  int? totalComment;

  factory PostCommentLikeData.fromJson(Map<String, dynamic> json) =>
      PostCommentLikeData(
        comments: json["comments"] != null
            ? List<Comment>.from(
                json["comments"].map((x) => Comment.fromJson(x)))
            : null,
        totalLike: json["totalLike"],
        totalComment: json["totalComment"],
      );

  Map<String, dynamic> toJson() => {
        "comments": List<dynamic>.from(comments!.map((x) => x.toJson())),
        "totalLike": totalLike,
        "totalComment": totalComment,
      };
}
