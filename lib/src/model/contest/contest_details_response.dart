import 'dart:convert';
import 'contest.dart';

GetContestDetailsRespone contestResponeFromJson(String str) =>
    GetContestDetailsRespone.fromJson(json.decode(str));

String contestResponeToJson(GetContestDetailsRespone data) =>
    json.encode(data.toJson());

class GetContestDetailsRespone {
  GetContestDetailsRespone({
    this.messageCode,
    this.statusCode,
    this.data,
    this.total,
    this.sunOfPages,
  });

  dynamic messageCode;
  int? statusCode;
  Contest? data;
  int? total;
  int? sunOfPages;

  factory GetContestDetailsRespone.fromJson(Map<String, dynamic> json) =>
      GetContestDetailsRespone(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: json["data"] == null ? null : Contest.fromJson(json["data"]),
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
