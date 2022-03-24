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
    SearchResultsData? data;
    dynamic total;
    int? sunOfPages;

    factory ListSearchPostResponseMessage.fromJson(Map<String, dynamic> json) => ListSearchPostResponseMessage(
        messageCode: json["messageCode"],
        statusCode: json["statusCode"],
        data: json["data"] != null ? SearchResultsData.fromJson(json["data"]) : null,
        total: json["total"],
        sunOfPages: json["sunOfPages"],
    );

    Map<String, dynamic> toJson() => {
        "messageCode": messageCode,
        "statusCode": statusCode,
        "data": data!.toJson(),
        "total": total,
        "sunOfPages": sunOfPages,
    };
}

class SearchResultsData {
    SearchResultsData({
        this.posts,
        this.words,
    });

    List<Post>? posts;
    List<String>? words;

    factory SearchResultsData.fromJson(Map<String, dynamic> json) => SearchResultsData(
        posts: List<Post>.from(json["posts"].map((x) => Post.fromJson(x))),
        words: List<String>.from(json["words"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "posts": List<dynamic>.from(posts!.map((x) => x.toJson())),
        "words": List<dynamic>.from(words!.map((x) => x)),
    };
}