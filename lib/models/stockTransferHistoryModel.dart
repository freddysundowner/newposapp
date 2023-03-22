import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/models/shop_model.dart';

class StockTransferHistory {
  StockTransferHistory({
    this.id,
    this.from,
    this.to,
    this.product,
    this.type,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  ShopModel? from;
  ShopModel? to;
  List<ProductModel>? product;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory StockTransferHistory.fromJson(Map<String, dynamic> json) =>
      StockTransferHistory(
        id: json["_id"],
        from: json["from"]==null?ShopModel():ShopModel.fromJson(json["from"]),
        to:json["to"]==null?ShopModel(): ShopModel.fromJson(json["to"]),
        product: List<ProductModel>.from(
            json["product"].map((x) => ProductModel.fromJson(x))),
        type: json["type"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
}
