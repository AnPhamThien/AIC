// To parse this JSON data, do
//
//     final getMessageResponseMessage = getMessageResponseMessageFromJson(jsonString);

import 'package:imagecaptioning/src/model/post/post.dart';

class AddPostResponseMessage {
  AddPostResponseMessage({
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

  factory AddPostResponseMessage.fromJson(Map<String, dynamic> json) =>
      AddPostResponseMessage(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: Post.fromJson(json["data"]),
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
