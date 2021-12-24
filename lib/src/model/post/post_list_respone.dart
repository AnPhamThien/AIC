// To parse this JSON data, do
//
//     final postListRespone = postListResponeFromJson(jsonString);

import 'dart:convert';

import 'data.dart';

PostListRespone postListResponeFromJson(String str) =>
    PostListRespone.fromJson(json.decode(str));

String postListResponeToJson(PostListRespone data) =>
    json.encode(data.toJson());

class PostListRespone {
  PostListRespone({
    this.messageCode,
    this.statusCode,
    this.data,
    this.total,
    this.sunOfPages,
  });

  dynamic messageCode;
  int? statusCode;
  Data? data;
  dynamic total;
  int? sunOfPages;

  factory PostListRespone.fromJson(Map<String, dynamic> json) =>
      PostListRespone(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: json["data"] != null ? Data.fromJson(json["data"]) : null,
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
