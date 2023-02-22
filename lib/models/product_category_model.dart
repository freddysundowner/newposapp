class ProductCategoryModel {
  ProductCategoryModel({
    this.id,
    this.name,
    this.shop,
    this.createdAt,
    this.updatedAt,

  });

  String ?id;
  String ?name;
  String ?shop;
  DateTime? createdAt;
  DateTime ?updatedAt;

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) => ProductCategoryModel(
    id: json["_id"],
    name: json["name"],
    shop: json["shop"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),

  );

}
