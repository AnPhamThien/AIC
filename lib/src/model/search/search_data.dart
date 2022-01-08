class SearchData {
  SearchData({
    this.id,
    this.userName,
    this.avataUrl,
    this.userRealName,
    this.status,
    this.dateCreate,
  });

  String? id;
  String? userName;
  String? avataUrl;
  String? userRealName;
  int? status;
  DateTime? dateCreate;

  factory SearchData.fromJson(Map<String, dynamic> json) => SearchData(
        id: json["id"],
        userName: json["user_name"],
        avataUrl: json["avata_url"],
        userRealName: json["user_real_name"],
        status: json["status"],
        dateCreate: DateTime.parse(json["date_create"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "avata_url": avataUrl,
        "user_real_name": userRealName,
        "status": status,
        "date_create": dateCreate!.toIso8601String(),
      };
}
