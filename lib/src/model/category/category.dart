class Category {
  Category({
    this.id,
    this.categoryName,
    this.dateCreate,
    this.dateUpdate,
    this.status,
  });

  String? id;
  String? categoryName;
  DateTime? dateCreate;
  DateTime? dateUpdate;
  int? status;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"],
        categoryName: json["category_name"],
        dateCreate: DateTime.parse(json["date_create"]),
        dateUpdate: DateTime.parse(json["date_update"]),
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_name": categoryName,
        "date_create": dateCreate!.toIso8601String(),
        "date_update": dateUpdate!.toIso8601String(),
        "status": status,
      };
}
