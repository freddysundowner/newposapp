import 'package:pointify/models/attendant_model.dart';
import 'package:pointify/models/product_model.dart';

class BadStock {
  String? description;
  int? quantity;
  DateTime? createdAt;
  DateTime? updatedAt;
  ProductModel? product;
  AttendantModel? attendantId;

  BadStock(
      {this.attendantId,
      this.updatedAt,
      this.createdAt,
      this.quantity,
      this.description,
      this.product});

  factory BadStock.fromJson(Map<String, dynamic> json) => BadStock(
      description: json["description"],
      quantity: json["quantity"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      product: json["product"] == null
          ? null
          : ProductModel.fromJson(json["product"]),
      attendantId: json["attendantId"] == null
          ? null
          : AttendantModel.fromJson(json["attendantId"]));
}
