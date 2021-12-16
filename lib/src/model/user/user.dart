// To parse this JSON data, do
//
//     final userMessage = userMessageFromJson(jsonString);

import 'dart:convert';

class User {
  User({this.id, this.name, this.avatar, this.phone, this.role, this.email});

  String? id;
  String? name;
  String? avatar;
  String? phone;
  String? role;
  String? email;

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json[
          "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier"],
      name: json["http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name"],
      avatar: json[""],
      role:
          json["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"],
      email: json[
          "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"]);

  Map<String, dynamic> toJson() => {
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier":
            id,
        "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name": name,
        "avatar": avatar,
        "phone": phone,
        "role": role,
      };
}

class AuthenticationResponseMessage {
  AuthenticationResponseMessage(
      {this.data,
      this.user,
      this.statusCode,
      this.messageCode,
      this.refreshToken});

  String? data;
  User? user;
  int? statusCode;
  String? messageCode;
  String? refreshToken;

  factory AuthenticationResponseMessage.fromJson(Map<String, dynamic> json) =>
      AuthenticationResponseMessage(
          data: json["data"],
          user: json["user"] == null ? null : User.fromJson(json["user"]),
          messageCode: json["messageCode"],
          statusCode: json["statusCode"],
          refreshToken: json["refreshToken"]);

  Map<String, dynamic> toJson() => {
        "data": data,
        "user": user!.toJson(),
        "messageCode": messageCode,
        "statusCode": statusCode,
        "refreshToken": refreshToken
      };
}

class RegisterDefaultResponseMessage {
  RegisterDefaultResponseMessage({
    this.messageCode,
    this.statusCode,
    this.data,
    this.totalLike,
    this.totalComment,
    this.total,
    this.sunOfPages,
  });

  String? messageCode;
  int? statusCode;
  dynamic data;
  dynamic totalLike;
  dynamic totalComment;
  dynamic total;
  int? sunOfPages;

  factory RegisterDefaultResponseMessage.fromJson(Map<String, dynamic> json) =>
      RegisterDefaultResponseMessage(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: json["data"],
        totalLike: json["totalLike"],
        totalComment: json["totalComment"],
        total: json["total"],
        sunOfPages: json["sunOfPages"],
      );

  Map<String, dynamic> toJson() => {
        "messageCode": messageCode,
        "statusCode": statusCode,
        "data": data,
        "totalLike": totalLike,
        "totalComment": totalComment,
        "total": total,
        "sunOfPages": sunOfPages,
      };
}
