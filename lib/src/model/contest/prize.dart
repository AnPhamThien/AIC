class Prize {
  Prize({
    this.name,
    this.top,
  });

  String? name;
  int? top;

  factory Prize.fromJson(Map<String, dynamic> json) => Prize(
        name: json["name"],
        top: json["top"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "top": top,
      };
}
