// To parse this JSON data, do
//
//     final userMessage = userMessageFromJson(jsonString);

import 'dart:convert';

GetUserDetailsResponseMessage userMessageFromJson(String str) =>
    GetUserDetailsResponseMessage.fromJson(json.decode(str));

String userMessageToJson(GetUserDetailsResponseMessage data) =>
    json.encode(data.toJson());

class GetUserDetailsResponseMessage {
  GetUserDetailsResponseMessage({
    this.messageCode,
    this.statusCode,
    this.data,
    this.totalLike,
    this.totalComment,
    this.total,
    this.sunOfPages,
  });

  dynamic messageCode;
  int? statusCode;
  UserDetails? data;
  dynamic totalLike;
  dynamic totalComment;
  dynamic total;
  int? sunOfPages;

  factory GetUserDetailsResponseMessage.fromJson(Map<String, dynamic> json) =>
      GetUserDetailsResponseMessage(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: json["data"] == null ? null : UserDetails.fromJson(json["data"]),
        totalLike: json["totalLike"],
        totalComment: json["totalComment"],
        total: json["total"],
        sunOfPages: json["sunOfPages"],
      );

  Map<String, dynamic> toJson() => {
        "messageCode": messageCode,
        "statusCode": statusCode,
        "data": data?.toJson(),
        "totalLike": totalLike,
        "totalComment": totalComment,
        "total": total,
        "sunOfPages": sunOfPages,
      };
}

class UserDetails {
  UserDetails({
    this.id,
    this.userName,
    this.avataUrl,
    this.phone,
    this.numberFollower,
    this.numberFollowee,
    this.numberOfpost,
    this.isFollow,
    this.description,
    this.userEmail,
    this.userRealName,
    this.posts,
  });

  String? id;
  String? userName;
  dynamic avataUrl;
  dynamic phone;
  int? numberFollower;
  int? numberFollowee;
  int? numberOfpost;
  int? isFollow;
  dynamic description;
  String? userEmail;
  dynamic userRealName;
  List<dynamic>? posts;

  factory UserDetails.fromJson(Map<String, dynamic> json) => UserDetails(
        id: json["id"],
        userName: json["user_name"],
        avataUrl: json["avata_url"],
        phone: json["phone"],
        numberFollower: json["number_follower"],
        numberFollowee: json["number_followee"],
        numberOfpost: json["number_ofpost"],
        isFollow: json["is_follow"],
        description: json["description"],
        userEmail: json["user_email"],
        userRealName: json["user_real_name"],
        posts: List<dynamic>.from(json["posts"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_name": userName,
        "avata_url": avataUrl,
        "phone": phone,
        "number_follower": numberFollower,
        "number_followee": numberFollowee,
        "number_ofpost": numberOfpost,
        "is_follow": isFollow,
        "description": description,
        "user_email": userEmail,
        "user_real_name": userRealName,
        "posts": List<dynamic>.from(posts!.map((x) => x)),
      };

  UserDetails copyWith({
    dynamic avataUrl,
    dynamic phone,
    int? numberFollower,
    int? numberFollowee,
    int? numberOfpost,
    int? isFollow,
    dynamic description,
    String? userEmail,
    dynamic userRealName,
    List<dynamic>? posts,
  }) {
    return UserDetails(
        avataUrl: avataUrl ?? this.avataUrl,
        phone: phone ?? this.phone,
        numberFollower: numberFollower ?? this.numberFollower,
        numberFollowee: numberFollowee ?? this.numberFollowee,
        numberOfpost: numberOfpost ?? this.numberOfpost,
        isFollow: isFollow ?? this.isFollow,
        description: description ?? this.description,
        userEmail: userEmail ?? this.userEmail,
        userRealName: userRealName ?? this.userRealName,
        posts: posts ?? this.posts);
  }
}
