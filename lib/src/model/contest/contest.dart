class Contest {
  Contest({
    required this.id,
    this.contestName,
    this.description,
    this.dateCreate,
    this.dateEnd,
    this.status,
    this.timeLeft,
    this.userwinId,
    this.contestActive,
  });

  String id;
  String? contestName;
  String? description;
  DateTime? dateCreate;
  DateTime? dateEnd;
  int? status;
  String? timeLeft;
  dynamic userwinId;
  int? contestActive;

  factory Contest.fromJson(Map<String, dynamic> json) => Contest(
        id: json["id"],
        contestName: json["contest_name"],
        description: json["description"],
        dateCreate: DateTime.parse(json["date_create"]),
        dateEnd: DateTime.parse(json["date_end"]),
        status: json["status"],
        timeLeft: json["time_left"],
        userwinId: json["userwin_id"],
        contestActive: json["contest_active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "contest_name": contestName,
        "description": description,
        "date_create": dateCreate?.toIso8601String(),
        "date_end": dateEnd?.toIso8601String(),
        "status": status,
        "time_left": timeLeft,
        "userwin_id": userwinId,
        "contest_active": contestActive,
      };
}
