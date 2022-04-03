import 'package:imagecaptioning/src/model/post/post.dart';

class ListSearchPostResponseMessage {
    ListSearchPostResponseMessage({
        this.messageCode,
        this.statusCode,
        this.data,
        this.total,
        this.sunOfPages,
    });

    dynamic messageCode;
    int? statusCode;
    List<Post>? data;
    dynamic total;
    int? sunOfPages;

    factory ListSearchPostResponseMessage.fromJson(Map<String, dynamic> json) => ListSearchPostResponseMessage(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: json["data"] != null ? (List<Post>.from(json["data"].map((x) => Post.fromJson(x)))) : null,
        total: json["total"],
        sunOfPages: json["sunOfPages"],
    );

    Map<String, dynamic> toJson() => {
        "messageCode": messageCode,
        "statusCode": statusCode,
        "data": data,
        "total": total,
        "sunOfPages": sunOfPages,
    };
}