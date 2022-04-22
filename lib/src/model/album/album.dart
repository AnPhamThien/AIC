// To parse this JSON data, do
//
//     final getAlbumResponseMessage = getAlbumResponseMessageFromJson(jsonString);

import 'dart:convert';

GetAlbumResponseMessage getAlbumResponseMessageFromJson(String str) =>
    GetAlbumResponseMessage.fromJson(json.decode(str));

String getAlbumResponseMessageToJson(GetAlbumResponseMessage data) =>
    json.encode(data.toJson());

class GetAlbumResponseMessage {
  GetAlbumResponseMessage({
    this.messageCode,
    this.statusCode,
    this.data,
    this.total,
    this.sunOfPages,
  });

  dynamic messageCode;
  int? statusCode;
  List<Album>? data;
  int? total;
  int? sunOfPages;

  factory GetAlbumResponseMessage.fromJson(Map<String, dynamic> json) =>
      GetAlbumResponseMessage(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: json["data"] == null
            ? null
            : List<Album>.from(json["data"].map((x) => Album.fromJson(x))),
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

class Album {
  Album(
      {this.id,
      this.albumName,
      this.status,
      this.dateCreate,
      this.dateUpdate,
      this.imgUrl,
      this.totalPost});

  String? id;
  String? albumName;
  int? status;
  DateTime? dateCreate;
  DateTime? dateUpdate;
  String? imgUrl;
  int? totalPost;

  factory Album.fromJson(Map<String, dynamic> json) => Album(
      id: json["id"],
      albumName: json["album_name"],
      status: json["status"],
      dateCreate: json["date_create"] != null
          ? DateTime.parse(json["date_create"])
          : null,
      dateUpdate: json["date_update"] != null
          ? DateTime.parse(json["date_update"])
          : null,
      imgUrl: json["img_url"],
      totalPost: json["total_post"]);
      

  Map<String, dynamic> toJson() => {
        "id": id,
        "album_name": albumName,
        "status": status,
        "date_create": dateCreate!.toIso8601String(),
        "date_update": dateUpdate!.toIso8601String(),
        "img_url": imgUrl
      };
}
