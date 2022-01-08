// To parse this JSON data, do
//
//     final searchHistoryRespone = searchHistoryResponeFromJson(jsonString);

import 'dart:convert';

import 'search_history_data.dart';

SearchHistoryRespone searchHistoryResponeFromJson(String str) =>
    SearchHistoryRespone.fromJson(json.decode(str));

String searchHistoryResponeToJson(SearchHistoryRespone data) =>
    json.encode(data.toJson());

class SearchHistoryRespone {
  SearchHistoryRespone({
    this.messageCode,
    this.statusCode,
    this.data,
    this.total,
    this.sunOfPages,
  });

  dynamic messageCode;
  int? statusCode;
  List<SearchHistoryData>? data;
  int? total;
  int? sunOfPages;

  factory SearchHistoryRespone.fromJson(Map<String, dynamic> json) =>
      SearchHistoryRespone(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: json["data"] != null
            ? List<SearchHistoryData>.from(
                json["data"].map((x) => SearchHistoryData.fromJson(x)))
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
