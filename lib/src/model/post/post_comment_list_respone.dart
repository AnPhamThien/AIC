// To parse this JSON data, do
//
//     final postCommentRespone = postCommentResponeFromJson(jsonString);

import 'dart:convert';

import 'comment.dart';

PostCommentListRespone postCommentResponeFromJson(String str) =>
    PostCommentListRespone.fromJson(json.decode(str));

String postCommentResponeToJson(PostCommentListRespone data) =>
    json.encode(data.toJson());

class PostCommentListRespone {
  PostCommentListRespone({
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

  factory PostCommentListRespone.fromJson(Map<String, dynamic> json) =>
      PostCommentListRespone(
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
