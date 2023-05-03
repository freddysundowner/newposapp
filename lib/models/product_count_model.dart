
import 'attendant_model.dart';

class ProductCountModel {
  ProductCountModel({
    this.id,
    this.product,
    this.quantity,
    this.shop,
    this.createdAt,
    this.attendantId,
    this.updatedAt,

  });

  String ?id;
  Product? product;
  int ?quantity;
  AttendantModel ? attendantId;
  String? shop;
  DateTime? createdAt;
  DateTime? updatedAt;


  factory ProductCountModel.fromJson(Map<String, dynamic> json) => ProductCountModel(
    id: json["_id"],
    product: json["product"]==null||json["product"].toString().length<=40?null:Product.fromJson(json["product"]),
    attendantId: json["attendantId"]==null||json["attendantId"].toString().length<=40?AttendantModel(): AttendantModel.fromJson(json["attendantId"]),
    quantity: json["quantity"],
    shop: json["shop"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),

  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "product": product!.toJson(),
    "quantity": quantity,
    "shop": shop,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),

  };
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
    this.supplier,
    this.shop,
    this.attendant,
    this.buyingPrice,
    this.badstock,
    this.description,
    this.unit,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? name;
  int ?quantity;
  String? category;
  int? stockLevel;
  List<String>? sellingPrice;
  int ?discount;
  String? supplier;
  String ?shop;
  String ?attendant;
  int? buyingPrice;
  int? badstock;
  String? description;
  String? unit;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["_id"],
    name: json["name"],
    quantity: json["quantity"],
    category: json["category"],
    stockLevel: json["stockLevel"],
    sellingPrice: List<String>.from(json["sellingPrice"].map((x) => x)),
    discount: json["discount"],
    supplier: json["supplier"],
    shop: json["shop"],
    attendant: json["attendant"],
    buyingPrice: json["buyingPrice"],
    badstock: json["badstock"],
    description: json["description"],
    unit: json["unit"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),

  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "quantity": quantity,
    "category": category,
    "stockLevel": stockLevel,
    "sellingPrice": List<dynamic>.from(sellingPrice!.map((x) => x)),
    "discount": discount,
    "supplier": supplier,
    "shop": shop,
    "attendant": attendant,
    "buyingPrice": buyingPrice,
    "badstock": badstock,
    "description": description,
    "unit": unit,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}
