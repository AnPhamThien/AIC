import 'dart:convert';

GetNotificationResponseMessage notificationResponseMessageFromJson(
        String str) =>
    GetNotificationResponseMessage.fromJson(json.decode(str));

String notificationResponseMessageToJson(GetNotificationResponseMessage data) =>
    json.encode(data.toJson());

class GetNotificationResponseMessage {
  GetNotificationResponseMessage({
    this.messageCode,
    this.statusCode,
    this.data,
    this.total,
    this.sunOfPages,
  });

  dynamic messageCode;
  int? statusCode;
  List<NotificationItem>? data;
  int? total;
  int? sunOfPages;

  factory GetNotificationResponseMessage.fromJson(Map<String, dynamic> json) =>
      GetNotificationResponseMessage(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: json["data"] != null
            ? List<NotificationItem>.from(
                json["data"].map((x) => NotificationItem.fromJson(x)))
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

class NotificationItem {
  NotificationItem({
    this.notificationId,
    this.notifyContent,
    this.postId,
    this.userId,
    this.userName,
    this.avataUrl,
    this.imageUrl,
    this.dateCreate,
    this.totalHours,
    this.isRead
  });

  String? notificationId;
  String? notifyContent;
  String? postId;
  String? userId;
  String? userName;
  dynamic avataUrl;
  dynamic imageUrl;
  DateTime? dateCreate;
  double? totalHours;
  bool? isRead;

  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
        notificationId: json["notification_id"],
        notifyContent: json["notify_content"],
        postId: json["post_id"],
        userId: json["user_id"],
        userName: json["user_name"],
        avataUrl: json["avata_url"],
        imageUrl: json["image_url"],
        dateCreate: DateTime.parse(json["date_create"]),
        totalHours: json["totalHours"].toDouble(),
        isRead: json["isRead"]
      );

  Map<String, dynamic> toJson() => {
        "notification_id": notificationId,
        "notify_content": notifyContent,
        "post_id": postId,
        "user_id": userId,
        "user_name": userName,
        "avata_url": avataUrl,
        "image_url": imageUrl,
        "date_create": dateCreate?.toIso8601String(),
        "totalHours": totalHours,
        "isRead": isRead
      };
}
