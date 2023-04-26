import 'package:flutterpos/models/product_model.dart';

class ProductTransferHistories {
  ProductModel? product;
  int? quantity;
  DateTime? createdAt;

  ProductTransferHistories({this.product, this.quantity,this.createdAt});

  factory ProductTransferHistories.fromJson(Map<String, dynamic> json) =>
      ProductTransferHistories(
          quantity: json["quantity"],
          createdAt: DateTime.parse(json["createdAt"]),
          product: ProductModel.fromJson(json["product"]));
}
