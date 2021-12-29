// To parse this JSON data, do
//
//     final postCommentRespone = postCommentResponeFromJson(jsonString);

import 'dart:convert';

import 'comment.dart';

PostCommentRespone postCommentResponeFromJson(String str) =>
    PostCommentRespone.fromJson(json.decode(str));

String postCommentResponeToJson(PostCommentRespone data) =>
    json.encode(data.toJson());

class PostCommentRespone {
  PostCommentRespone({
    this.messageCode,
    this.statusCode,
    this.data,
    this.total,
    this.sunOfPages,
  });

  dynamic messageCode;
  int? statusCode;
  List<Comment>? data;
  int? total;
  int? sunOfPages;

  factory PostCommentRespone.fromJson(Map<String, dynamic> json) =>
      PostCommentRespone(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: json["data"] != null
            ? List<Comment>.from(json["data"].map((x) => Comment.fromJson(x)))
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
