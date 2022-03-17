// To parse this JSON data, do
//
//     final postDetailResponeDart = postDetailResponeDartFromJson(jsonString);

import 'dart:convert';

import 'package:imagecaptioning/src/model/post/post.dart';

PostDetailRespone postDetailResponeDartFromJson(String str) =>
    PostDetailRespone.fromJson(json.decode(str));

String postDetailResponeDartToJson(PostDetailRespone data) =>
    json.encode(data.toJson());

class PostDetailRespone {
  PostDetailRespone({
    this.messageCode,
    this.statusCode,
    this.data,
    this.total,
    this.sunOfPages,
  });

  dynamic messageCode;
  int? statusCode;
  Post? data;
  dynamic total;
  int? sunOfPages;

  factory PostDetailRespone.fromJson(Map<String, dynamic> json) =>
      PostDetailRespone(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: json["data"] != null ? Post.fromJson(json["data"]) : null,
        total: json["total"],
        sunOfPages: json["sunOfPages"],
      );

  Map<String, dynamic> toJson() => {
        "messageCode": messageCode,
        "statusCode": statusCode,
        "data": data!.toJson(),
        "total": total,
        "sunOfPages": sunOfPages,
      };
}
