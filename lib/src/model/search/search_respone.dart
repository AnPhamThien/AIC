// To parse this JSON data, do
//
//     final searchResponeDart = searchResponeDartFromJson(jsonString);

import 'dart:convert';

import 'search_data.dart';

SearchRespone searchResponeDartFromJson(String str) =>
    SearchRespone.fromJson(json.decode(str));

String searchResponeDartToJson(SearchRespone data) =>
    json.encode(data.toJson());

class SearchRespone {
  SearchRespone({
    this.messageCode,
    this.statusCode,
    this.data,
    this.total,
    this.sunOfPages,
  });

  dynamic messageCode;
  int? statusCode;
  List<SearchData>? data;
  int? total;
  int? sunOfPages;

  factory SearchRespone.fromJson(Map<String, dynamic> json) =>
      SearchRespone(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: json["data"] != null
            ? List<SearchData>.from(
                json["data"].map((x) => SearchData.fromJson(x)))
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
