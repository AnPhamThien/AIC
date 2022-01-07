// To parse this JSON data, do
//
//     final contestRespone = contestResponeFromJson(jsonString);

import 'dart:convert';

import 'contest_data.dart';

ContestRespone contestResponeFromJson(String str) =>
    ContestRespone.fromJson(json.decode(str));

String contestResponeToJson(ContestRespone data) => json.encode(data.toJson());

class ContestRespone {
  ContestRespone({
    this.messageCode,
    this.statusCode,
    this.data,
    this.total,
    this.sunOfPages,
  });

  dynamic messageCode;
  int? statusCode;
  ContestData? data;
  dynamic total;
  int? sunOfPages;

  factory ContestRespone.fromJson(Map<String, dynamic> json) => ContestRespone(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: json["data"] != null ? ContestData.fromJson(json["data"]) : null,
        total: json["total"],
        sunOfPages: json["sunOfPages"],
      );

  Map<String, dynamic> toJson() => {
        "messageCode": messageCode,
        "statusCode": statusCode,
        "data": data!.toJson(),
        "total": total,
        "sunOfPages": sunOfPages,
      };
}
