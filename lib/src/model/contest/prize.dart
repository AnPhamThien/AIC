class Prize {
  Prize({
    this.prizeId,
    this.name,
    this.top,
  });

  String? prizeId;
  String? name;
  int? top;

  factory Prize.fromJson(Map<String, dynamic> json) => Prize(
        prizeId: json["prize_id"],
        name: json["name"],
        top: json["top"],
      );

  Map<String, dynamic> toJson() => {
        "prize_id": prizeId,
        "name": name,
        "top": top,
      };
}
