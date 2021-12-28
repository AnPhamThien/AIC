// To parse this JSON data, do
//
//     final getMessageResponseMessage = getMessageResponseMessageFromJson(jsonString);

import 'dart:convert';

GetMessageResponseMessage getMessageResponseMessageFromJson(String str) =>
    GetMessageResponseMessage.fromJson(json.decode(str));

String getMessageResponseMessageToJson(GetMessageResponseMessage data) =>
    json.encode(data.toJson());

class GetMessageResponseMessage {
  GetMessageResponseMessage({
    this.messageCode,
    this.statusCode,
    this.data,
    this.total,
    this.sunOfPages,
  });

  dynamic messageCode;
  int? statusCode;
  List<Message>? data;
  int? total;
  int? sunOfPages;

  factory GetMessageResponseMessage.fromJson(Map<String, dynamic> json) =>
      GetMessageResponseMessage(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: json["data"] != null
            ? List<Message>.from(json["data"].map((x) => Message.fromJson(x)))
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

class Message {
  Message({
    this.messageId,
    this.conversationId,
    this.content,
    this.time,
    this.realTime,
    this.totalHours,
    this.userId,
    this.userName,
    this.avatar,
    this.conversationTime,
  });

  String? messageId;
  String? conversationId;
  String? content;
  String? time;
  DateTime? realTime;
  double? totalHours;
  String? userId;
  String? userName;
  String? avatar;
  DateTime? conversationTime;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        messageId: json["message_id"],
        conversationId: json["conversation_id"],
        content: json["content"],
        time: json["time"],
        realTime: json["real_Time"] != null
            ? DateTime.parse(json["real_Time"])
            : null,
        totalHours: json["totalHours"].toDouble(),
        userId: json["user_Id"],
        userName: json["user_Name"],
        avatar: json["avatar"],
        conversationTime: json["conversation_Time"] != null
            ? DateTime.parse(json["conversation_Time"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "message_id": messageId,
        "conversation_id": conversationId,
        "content": content,
        "time": time,
        "real_Time": realTime?.toIso8601String(),
        "totalHours": totalHours,
        "user_Id": userId,
        "user_Name": userName,
        "avatar": avatar,
        "conversation_Time": conversationTime?.toIso8601String(),
      };
}
