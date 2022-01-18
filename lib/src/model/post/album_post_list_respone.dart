import 'package:imagecaptioning/src/model/post/post.dart';

import 'dart:convert';

GetAlbumPostListResponseMessage getAlbumResponseMessageFromJson(String str) =>
    GetAlbumPostListResponseMessage.fromJson(json.decode(str));

String getAlbumResponseMessageToJson(GetAlbumPostListResponseMessage data) =>
    json.encode(data.toJson());

class GetAlbumPostListResponseMessage {
  GetAlbumPostListResponseMessage({
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

  factory GetAlbumPostListResponseMessage.fromJson(Map<String, dynamic> json) =>
      GetAlbumPostListResponseMessage(
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
