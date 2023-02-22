class ProductSaleHistory {
  ProductSaleHistory({
    this.id,
    this.product,
    this.quantity,
    this.total,
    this.discount,
    this.itemCount,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  Product? product;

  int? quantity;
  int? total;
  int? discount;
  int? itemCount;
  int? price;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ProductSaleHistory.fromJson(Map<String, dynamic> json) =>
      ProductSaleHistory(
          id: json["_id"],
          product: Product.fromJson(json["product"]),
          quantity: json["quantity"],
          createdAt: DateTime.parse(json["createdAt"]),
          updatedAt: DateTime.parse(json["updatedAt"]),
          total: json["total"],
          discount: json["discount"],
          itemCount: json["itemCount"],
          price: json["price"]);
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
    this.v,
  });

  String ?id;
  String? name;
  int ?quantity;
  String ?category;
  int ?stockLevel;
  List<String>? sellingPrice;
  int ?discount;
  String? supplier;
  String? shop;
  String? attendant;
  int ?buyingPrice;
  int ?badstock;
  String ?description;
  String? unit;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

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
    v: json["__v"],
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
    "__v": v,
  };
}
