class Followee {
  Followee({
    this.id,
    this.dateUp,
    this.dateDow,
  });

  String? id;
  DateTime? dateUp;
  DateTime? dateDow;

  factory Followee.fromJson(Map<String, dynamic> json) => Followee(
        id: json["id"],
        dateUp: DateTime.parse(json["date_up"]),
        dateDow: DateTime.parse(json["date_dow"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "date_up": dateUp?.toIso8601String(),
        "date_dow": dateDow?.toIso8601String(),
      };
}
