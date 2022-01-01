// To parse this JSON data, do
//
//     final conversationResponseMessage = conversationResponseMessageFromJson(jsonString);


class GetConversationResponseMessage {
  GetConversationResponseMessage({
    this.messageCode,
    this.statusCode,
    this.data,
    this.total,
    this.sunOfPages,
  });

  dynamic messageCode;
  int? statusCode;
  List<Conversation>? data;
  int? total;
  int? sunOfPages;

  factory GetConversationResponseMessage.fromJson(Map<String, dynamic> json) =>
      GetConversationResponseMessage(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: json["data"] != null
            ? List<Conversation>.from(
                json["data"].map((x) => Conversation.fromJson(x)))
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

class Conversation {
  Conversation(
      {this.userId,
      this.userName,
      this.avataUrl,
      this.conversationId,
      this.sendUserId,
      this.messageContent,
      this.isSeen,
      this.dateSend,
      this.totalTime,
      this.messageId,
      this.conversationDate,
      this.userRealName});

  String? userId;
  String? userName;
  String? avataUrl;
  String? conversationId;
  String? sendUserId;
  String? messageContent;
  int? isSeen;
  DateTime? dateSend;
  double? totalTime;
  String? messageId;
  DateTime? conversationDate;
  String? userRealName;

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
      userId: json["user_id"],
      userName: json["user_name"],
      avataUrl: json["avata_url"],
      conversationId: json["conversation_id"],
      sendUserId: json["send_user_id"],
      messageContent: json["message_content"],
      isSeen: json["isSeen"],
      dateSend:
          json["date_send"] != null ? DateTime.parse(json["date_send"]) : null,
      totalTime: json["total_time"].toDouble(),
      messageId: json["message_id"],
      conversationDate: json["conversation_date"] != null
          ? DateTime.parse(json["conversation_date"])
          : null,
      userRealName: json["user_real_name"]);

  Map<String, dynamic> toJson() => {
        "user_id": userId,
        "user_name": userName,
        "avata_url": avataUrl,
        "conversation_id": conversationId,
        "send_user_id": sendUserId,
        "message_content": messageContent,
        "isSeen": isSeen,
        "date_send": dateSend!.toIso8601String(),
        "total_time": totalTime,
        "message_id": messageId,
        "conversation_date": conversationDate!.toIso8601String(),
        "user_real_name": userRealName,
      };
}
