import 'package:flutterpos/models/product_category_model.dart';

import 'attendant_model.dart';

class ProductModel {
  ProductModel({
    this.id,
    this.name,
    this.quantity,
    this.category,
    this.stockLevel,
    this.sellingPrice,
    this.discount,
    this.supplier,
    this.shop,
    this.attendant,
    this.buyingPrice,
    this.badstock,
    this.description,
    this.unit,
    this.cartquantity,
    this.amount,
    this.createdAt,
    this.updatedAt,
    this.allowedDiscount,
    this.deleted,
    this.selling,
    this.minPrice,
  });

  String? id;
  String? name;
  int? quantity;
  ProductCategoryModel? category;
  int? stockLevel;
  bool? deleted;
  List<String>? sellingPrice;
  int? discount;
  String? supplier;
  String? shop;
  int? cartquantity;
  int? amount;
  int? minPrice;
  int? selling;
  int? allowedDiscount;
  AttendantModel? attendant;
  int? buyingPrice;
  int? badstock;
  String? description;
  String? unit;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ProductModel.fromJson(var json) => ProductModel(
        id: json["_id"],
        name: json["name"],
        quantity: json["quantity"],
        category: json["category"] == null
            ? null
            : ProductCategoryModel.fromJson(json["category"]),
        stockLevel: json["stockLevel"],
        sellingPrice: List<String>.from(json["sellingPrice"].map((x) => x)),
        discount: json["discount"],
        supplier: json["supplier"],
        shop: json["shop"],
        selling: int.parse(List<String>.from(json["sellingPrice"].map((x) => x))[0]),
        cartquantity: 1,
        deleted: json["deleted"],
        amount: 0,
        minPrice: json["minSellingPrice"],
        allowedDiscount: 0,
        attendant: json["attendant"] == null
            ? null
            : AttendantModel.fromJson(json["attendant"]),
        buyingPrice: json["buyingPrice"],
        badstock: json["badstock"],
        description: json["description"],
        unit: json["measureUnit"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "quantity": quantity,
        // "category": category,
        "stockLevel": stockLevel,
        "sellingPrice": List<dynamic>.from(sellingPrice!.map((x) => x)),
        "discount": discount,
        "supplier": supplier,
        "shop": shop,
        "deleted": deleted,
        "cartquantity": cartquantity,
        "selling": selling,
        "amount": amount,
        "allowedDiscount": allowedDiscount,
        // "attendant": attendant!.toJson(),
        "buyingPrice": buyingPrice,
        "badstock": badstock,
        "description": description,
        "minprice": minPrice,
        "unit": unit,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
      };
}
