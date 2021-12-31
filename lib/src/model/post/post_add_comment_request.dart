// To parse this JSON data, do
//
//     final postAddCommentRequest = postAddCommentRequestFromJson(jsonString);

import 'dart:convert';

PostAddCommentRequest postAddCommentRequestFromJson(String str) =>
    PostAddCommentRequest.fromJson(json.decode(str));

String postAddCommentRequestToJson(PostAddCommentRequest data) =>
    json.encode(data.toJson());

class PostAddCommentRequest {
  PostAddCommentRequest({
    this.content,
    this.postId,
  });

  String? content;
  String? postId;

  factory PostAddCommentRequest.fromJson(Map<String, dynamic> json) =>
      PostAddCommentRequest(
        content: json["content"],
        postId: json["post_id"],
      );

  Map<String, dynamic> toJson() => {
        "content": content,
        "post_id": postId,
      };
}
