
class Post {
  Post({
    this.postId,
    this.imageId,
    this.imageUrl,
    this.userId,
    this.userName,
    this.avataUrl,
    this.aiCaption,
    this.userCaption,
    this.dateCreate,
    this.dateUpdate,
    this.likecount,
    this.isLike,
    this.contestId,
    this.isSaved,
  });

  String? postId;
  String? imageId;
  String? imageUrl;
  String? userId;
  String? userName;
  String? avataUrl;
  String? aiCaption;
  String? userCaption;
  DateTime? dateCreate;
  DateTime? dateUpdate;
  int? likecount;
  int? isLike;
  String? contestId;
  int? isSaved;

  factory Post.fromJson(Map<String, dynamic> json) => Post(
        postId: json["post_id"],
        imageId: json["image_id"],
        imageUrl: json["image_url"],
        userId: json["user_id"],
        userName: json["user_name"],
        avataUrl: json["avata_url"],
        aiCaption: json["ai_caption"],
        userCaption: json["user_caption"] == null ? null : json["user_caption"],
        dateCreate: DateTime.parse(json["date_create"]),
        dateUpdate: DateTime.parse(json["date_update"]),
        likecount: json["likecount"],
        isLike: json["isLike"],
        contestId: json["contest_id"],
        isSaved: json["isSaved"],
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "image_id": imageId,
        "image_url": imageUrl,
        "user_id": userId,
        "user_name": userName,
        "avata_url": avataUrl,
        "ai_caption": aiCaption,
        "user_caption": userCaption == null ? null : userCaption,
        "date_create": dateCreate?.toIso8601String(),
        "date_update": dateUpdate?.toIso8601String(),
        "likecount": likecount,
        "isLike": isLike,
        "contest_id": contestId,
        "isSaved": isSaved,
      };
}
