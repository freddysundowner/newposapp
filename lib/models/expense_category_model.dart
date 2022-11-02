class ExpenseCategoryModel {
  ExpenseCategoryModel({
    this.id,
    this.name,
    this.amount,
    this.type,
    this.shop,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  String? name;
  int? amount;
  String? type;
  String? shop;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory ExpenseCategoryModel.fromJson(Map<String, dynamic> json) =>
      ExpenseCategoryModel(
        id: json["_id"],
        name: json["name"],
        amount: json["amount"],
        type: json["type"],
        shop: json["shop"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );
}
