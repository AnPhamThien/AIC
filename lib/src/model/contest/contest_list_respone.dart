// To parse this JSON data, do
//
//     final contestRespone = contestResponeFromJson(jsonString);

import 'dart:convert';

import 'contest.dart';

ContestListRespone contestResponeFromJson(String str) =>
    ContestListRespone.fromJson(json.decode(str));

String contestResponeToJson(ContestListRespone data) =>
    json.encode(data.toJson());

class ContestListRespone {
  ContestListRespone({
    this.messageCode,
    this.statusCode,
    this.data,
    this.total,
    this.sunOfPages,
  });

  dynamic messageCode;
  int? statusCode;
  List<Contest>? data;
  int? total;
  int? sunOfPages;

  factory ContestListRespone.fromJson(Map<String, dynamic> json) =>
      ContestListRespone(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: json["data"] != null
            ? List<Contest>.from(json["data"].map((x) => Contest.fromJson(x)))
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
