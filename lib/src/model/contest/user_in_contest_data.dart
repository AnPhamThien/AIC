class UserInContestData {
  UserInContestData({
    this.postId,
    this.userId,
    this.userName,
    this.userAvatar,
    this.userRealname,
    this.dateCreate,
  });

  String? postId;
  String? userId;
  String? userName;
  String? userAvatar;
  dynamic userRealname;
  DateTime? dateCreate;

  factory UserInContestData.fromJson(Map<String, dynamic> json) => UserInContestData(
        postId: json["post_id"],
        userId: json["user_id"],
        userName: json["user_name"],
        userAvatar: json["user_avatar"],
        userRealname: json["user_realname"],
        dateCreate: DateTime.parse(json["date_create"]),
      );

  Map<String, dynamic> toJson() => {
        "post_id": postId,
        "user_id": userId,
        "user_name": userName,
        "user_avatar": userAvatar,
        "user_realname": userRealname,
        "date_create": dateCreate!.toIso8601String(),
      };
}
