// To parse this JSON data, do
//
//     final contestPostRespone = contestPostResponeFromJson(jsonString);

import 'dart:convert';

import 'package:imagecaptioning/src/model/post/post.dart';

ContestPostRespone contestPostResponeFromJson(String str) =>
    ContestPostRespone.fromJson(json.decode(str));

String contestPostResponeToJson(ContestPostRespone data) =>
    json.encode(data.toJson());

class ContestPostRespone {
  ContestPostRespone({
    this.messageCode,
    this.statusCode,
    this.data,
    this.total,
    this.sunOfPages,
  });

  dynamic messageCode;
  int? statusCode;
  List<Post>? data;
  int? total;
  int? sunOfPages;

  factory ContestPostRespone.fromJson(Map<String, dynamic> json) =>
      ContestPostRespone(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: json["data"] != null
            ? List<Post>.from(json["data"].map((x) => Post.fromJson(x)))
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
