import 'package:flutterpos/models/product_model.dart';
class ProductHistoryModel {
  ProductHistoryModel({
    this.id,
    this.product,
    this.type,
    this.quantity,
    this.shop,
    // this.attendantId,
    // this.stockTransfer,
    this.supplier,
    this.createdAt

  });

  String ?id;
  ProductModel ?product;
  String? type;
  int ?quantity;
  String ?shop;
  // String ?attendantId;
  // String ?stockTransfer;
  String ?supplier;
  DateTime ?createdAt;


  factory ProductHistoryModel.fromJson(Map<String, dynamic> json) => ProductHistoryModel(
    id: json["_id"],
    product: ProductModel.fromJson(json["product"]),
    type: json["type"],
    quantity: json["quantity"],
    shop: json["shop"],
    // attendantId: json["attendantId"],
    // stockTransfer: json["stockTransfer"],
    supplier: json["supplier"],
    createdAt: DateTime.parse(json["createdAt"]),

  );


}

class Product {
  Product({
    this.id,
    this.name,
    this.quantity,
    this.category,
    this.stockLevel,
    this.sellingPrice,
    this.discount,
    this.shop,
    this.attendant,
    this.buyingPrice,
    this.minSellingPrice,
    this.badStock,
    this.description,
    this.deleted,
    this.counted,
    this.createdAt,

  });

  String? id;
  String? name;
  int ?quantity;
  String? category;
  int ?stockLevel;
  List<String>? sellingPrice;
  int? discount;
  String? shop;
  String? attendant;
  int ?buyingPrice;
  int? minSellingPrice;
  int ?badStock;
  String? description;
  bool ?deleted;
  bool ?counted;
  DateTime ?createdAt;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["_id"],
    name: json["name"],
    quantity: json["quantity"],
    category: json["category"],
    stockLevel: json["stockLevel"],
    sellingPrice: List<String>.from(json["sellingPrice"].map((x) => x)),
    discount: json["discount"],
    shop: json["shop"],
    attendant: json["attendant"],
    buyingPrice: json["buyingPrice"],
    minSellingPrice: json["minSellingPrice"],
    badStock: json["badStock"],
    description: json["description"],
    deleted: json["deleted"],
    counted: json["counted"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

}
