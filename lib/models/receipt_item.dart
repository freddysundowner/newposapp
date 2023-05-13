import 'package:pointify/models/product_model.dart';

class ReceiptItem {
  String? id;
  ProductModel? product;
  int? quantity;
  int? total;
  int? discount;
  int? itemCount;
  int? price;
  DateTime? createdAt;
  DateTime? updatedAt;
  ReceiptItem({
    this.id,
    this.product,
    this.quantity,
    this.total,
    this.discount,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  factory ReceiptItem.fromJson(Map<String, dynamic> json) => ReceiptItem(
      id: json["_id"],
      product: ProductModel.fromJson(json["product"]),
      quantity: json["quantity"] ?? 0,
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      total: json["total"] ?? 0,
      discount: json["discount"] ?? 0,
      price: json["price"] ?? 0);

  Map<String, dynamic> toJson(ReceiptItem receiptItem) => {
        "product": receiptItem.product!.id,
        "quantity": receiptItem.quantity,
        "total": receiptItem.total,
        "discount": receiptItem.discount,
        "price": receiptItem.price,
      };
}
