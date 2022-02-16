// To parse this JSON data, do
//
//     final categoryResponeDart = categoryResponeDartFromJson(jsonString);

import 'dart:convert';

import 'package:imagecaptioning/src/model/category/category.dart';

CategoryRespone categoryResponeDartFromJson(String str) =>
    CategoryRespone.fromJson(json.decode(str));

String categoryResponeDartToJson(CategoryRespone data) =>
    json.encode(data.toJson());

class CategoryRespone {
  CategoryRespone({
    this.messageCode,
    this.statusCode,
    this.data,
    this.total,
    this.sunOfPages,
  });

  dynamic messageCode;
  int? statusCode;
  List<Category>? data;
  int? total;
  int? sunOfPages;

  factory CategoryRespone.fromJson(Map<String, dynamic> json) =>
      CategoryRespone(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: json["data"] != null
            ? List<Category>.from(json["data"].map((x) => Category.fromJson(x)))
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
