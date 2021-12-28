// To parse this JSON data, do
//
//     final userMessage = userMessageFromJson(jsonString);

class User {
  User({
    this.avatar,
    this.phone,
    this.role,
    this.email,
    this.userName,
  });

  String? avatar;
  String? phone;
  String? role;
  String? email;
  dynamic userName;

  factory User.fromJson(Map<String, dynamic> json) => User(
        avatar: json["avatar"],
        phone: json["phone"],
        role: json["role"],
        email: json["email"],
        userName: json["userName"],
      );

  Map<String, dynamic> toJson() => {
        "avatar": avatar,
        "phone": phone,
        "role": role,
        "email": email,
        "userName": userName,
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
          user: json["user"] != null ? User.fromJson(json["user"]) : null,
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
