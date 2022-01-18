class Comment {
  Comment({
    this.id,
    this.content,
    this.userId,
    this.userName,
    this.avataUrl,
    this.time,
    this.dateCreate,
  });

  String? id;
  String? content;
  String? userId;
  String? userName;
  String? avataUrl;
  double? time;
  DateTime? dateCreate;

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
        id: json["id"],
        content: json["content"],
        userId: json["user_id"],
        userName: json["user_name"],
        avataUrl: json["avata_url"],
        time: json["time"].toDouble(),
        dateCreate: DateTime.parse(json["date_create"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "user_id": userId,
        "user_name": userName,
        "avata_url": avataUrl,
        "time": time,
        "date_create": dateCreate!.toIso8601String(),
      };
}
