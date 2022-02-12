import 'package:imagecaptioning/src/model/post/post.dart';

import 'dart:convert';

GetListOfPostResponseMessage getAlbumResponseMessageFromJson(String str) =>
    GetListOfPostResponseMessage.fromJson(json.decode(str));

String getAlbumResponseMessageToJson(GetListOfPostResponseMessage data) =>
    json.encode(data.toJson());

class GetListOfPostResponseMessage {
  GetListOfPostResponseMessage({
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

  factory GetListOfPostResponseMessage.fromJson(Map<String, dynamic> json) =>
      GetListOfPostResponseMessage(
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
