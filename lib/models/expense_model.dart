import 'package:flutterpos/models/attendant_model.dart';

class ExpenseModel {
  ExpenseModel({
    this.id,
    this.category,
    this.amount,
    this.shop,
    this.name,
    this.attendantId,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  String? category;
  int? amount;
  String? shop;
  String? name;
  AttendantModel? attendantId;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory ExpenseModel.fromJson(Map<String, dynamic> json) => ExpenseModel(
        id: json["_id"],
        category: json["category"],
        amount: json["amount"],
        shop: json["shop"],
        name: json["name"],
        attendantId: json["attendantId"] == null
            ? null
            : AttendantModel.fromJson(json["attendantId"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );
}
