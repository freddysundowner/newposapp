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

  List<String>? product;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory StockTransferHistory.fromJson(Map<String, dynamic> json) =>
      StockTransferHistory(
        id: json["_id"],
        from: json["from"]==null?ShopModel():ShopModel.fromJson(json["from"]),
        to:json["to"]==null?ShopModel(): ShopModel.fromJson(json["to"]),
        product: List<String>.from(json["product"].map((x) =>x)),
        type: json["type"],

        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
}

class ProductData{
  String ?id;
  String ?name;
  int? quantity;
  ProductData({this.quantity,this.name,this.id});

  factory ProductData.fromJson(Map<String,dynamic> json)=>ProductData(
    id: json["_id"],
    name: json["name"],
    quantity:json["quantity"],
  );
}