// To parse this JSON data, do
//
//     final postListRespone = postListResponeFromJson(jsonString);

import 'dart:convert';

import 'package:imagecaptioning/src/model/post/followee.dart';

PostListRequest postListRequestFromJson(String str) =>
    PostListRequest.fromJson(json.decode(str));

String postListRequestToJson(PostListRequest data) =>
    json.encode(data.toJson());

class PostListRequest {
  PostListRequest({
    this.postPerPerson,
    this.limitDay,
    this.listFollowees,
  });

  int? postPerPerson;
  int? limitDay;
  List<Followee>? listFollowees;

  factory PostListRequest.fromJson(Map<String, dynamic> json) =>
      PostListRequest(
        postPerPerson: json["postPerPerson"],
        limitDay: json["limitDay"],
        listFollowees: List<Followee>.from(
            json["listFollowees"].map((x) => Followee.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "postPerPerson": postPerPerson,
        "limitDay": limitDay,
        "listFollowees":
            List<dynamic>.from(listFollowees!.map((x) => x.toJson())),
      };
}
