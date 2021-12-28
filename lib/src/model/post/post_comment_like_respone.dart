// To parse this JSON data, do
//
//     final postCommentLikeRespone = postCommentLikeResponeFromJson(jsonString);

import 'dart:convert';

import 'post_comment_like_data.dart';

PostCommentLikeRespone postCommentLikeResponeFromJson(String str) =>
    PostCommentLikeRespone.fromJson(json.decode(str));

String postCommentLikeResponeToJson(PostCommentLikeRespone data) =>
    json.encode(data.toJson());

class PostCommentLikeRespone {
  PostCommentLikeRespone({
    this.messageCode,
    this.statusCode,
    this.data,
    this.total,
    this.sunOfPages,
  });

  dynamic messageCode;
  int? statusCode;
  PostCommentLikeData? data;
  dynamic total;
  int? sunOfPages;

  factory PostCommentLikeRespone.fromJson(Map<String, dynamic> json) =>
      PostCommentLikeRespone(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: PostCommentLikeData.fromJson(json["data"]),
        total: json["total"],
        sunOfPages: json["sunOfPages"],
      );

  Map<String, dynamic> toJson() => {
        "messageCode": messageCode,
        "statusCode": statusCode,
        "data": data?.toJson(),
        "total": total,
        "sunOfPages": sunOfPages,
      };
}
