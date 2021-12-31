// To parse this JSON data, do
//
//     final postAddCommentRespone = postAddCommentResponeFromJson(jsonString);

import 'dart:convert';

PostAddCommentRespone postAddCommentResponeFromJson(String str) =>
    PostAddCommentRespone.fromJson(json.decode(str));

String postAddCommentResponeToJson(PostAddCommentRespone data) =>
    json.encode(data.toJson());

class PostAddCommentRespone {
  PostAddCommentRespone({
    this.messageCode,
    this.statusCode,
    this.data,
    this.total,
    this.sunOfPages,
  });

  dynamic messageCode;
  int? statusCode;
  dynamic data;
  dynamic total;
  int? sunOfPages;

  factory PostAddCommentRespone.fromJson(Map<String, dynamic> json) =>
      PostAddCommentRespone(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: json["data"],
        total: json["total"],
        sunOfPages: json["sunOfPages"],
      );

  Map<String, dynamic> toJson() => {
        "messageCode": messageCode,
        "statusCode": statusCode,
        "data": data,
        "total": total,
        "sunOfPages": sunOfPages,
      };
}
