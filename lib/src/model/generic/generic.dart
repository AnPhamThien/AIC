// To parse this JSON data, do
//
//     final getMessageResponseMessage = getMessageResponseMessageFromJson(jsonString);

import 'dart:convert';

class GetResponseMessage {
  GetResponseMessage({
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

  factory GetResponseMessage.fromJson(Map<String, dynamic> json) =>
      GetResponseMessage(
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
