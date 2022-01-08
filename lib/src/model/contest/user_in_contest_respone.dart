// To parse this JSON data, do
//
//     final userInContestRespone = userInContestResponeFromJson(jsonString);

import 'dart:convert';

import 'package:imagecaptioning/src/model/contest/user_in_contest_data.dart';

UserInContestRespone userInContestResponeFromJson(String str) =>
    UserInContestRespone.fromJson(json.decode(str));

String userInContestResponeToJson(UserInContestRespone data) =>
    json.encode(data.toJson());

class UserInContestRespone {
  UserInContestRespone({
    this.messageCode,
    this.statusCode,
    this.data,
    this.total,
    this.sunOfPages,
  });

  dynamic messageCode;
  int? statusCode;
  List<UserInContestData>? data;
  int? total;
  int? sunOfPages;

  factory UserInContestRespone.fromJson(Map<String, dynamic> json) =>
      UserInContestRespone(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: json["data"] != null
            ? List<UserInContestData>.from(
                json["data"].map((x) => UserInContestData.fromJson(x)))
            : null,
        total: json["total"],
        sunOfPages: json["sunOfPages"],
      );

  Map<String, dynamic> toJson() => {
        "messageCode": messageCode,
        "statusCode": statusCode,
        "data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "total": total,
        "sunOfPages": sunOfPages,
      };
}
