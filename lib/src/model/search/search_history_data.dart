class SearchHistoryData {
  SearchHistoryData({
    this.userId,
    this.avatarUrl,
    this.userName,
    this.userRealName,
    this.dateSearch,
  });

  String? userId;
  String? avatarUrl;
  String? userName;
  String? userRealName;
  DateTime? dateSearch;

  factory SearchHistoryData.fromJson(Map<String, dynamic> json) =>
      SearchHistoryData(
        userId: json["user_id"],
        avatarUrl: json["avatar_url"],
        userName: json["user_name"],
        userRealName: json["user_real_name"],
        dateSearch: DateTime.parse(json["date_search"]),
      );

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "avatar_url": avatarUrl,
        "user_name": userName,
        "user_real_name": userRealName,
        "date_search": dateSearch!.toIso8601String(),
      };
}
