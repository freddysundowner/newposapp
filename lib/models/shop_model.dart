import 'package:pointify/models/shop_category.dart';

class ShopModel {
  ShopModel(
      {this.id,
      this.name,
      this.location,
      this.owner,
      this.category,
      this.currency = "KES"});

  String? id;
  String? name;
  String? location;
  String? owner;
  ShopCategory? category;
  String? currency;

  factory ShopModel.fromJson(Map<String, dynamic> json) => ShopModel(
        id: json["_id"],
        name: json["name"],
        location: json["location"],
        owner: json["owner"],
        category:
            json["category"] == null || json["category"].toString().length <= 40
                ? null
                : ShopCategory.fromJson(json["category"]),
        currency: json["currency"] ?? "KES",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "location": location,
        "owner": owner,
        "category": category,
        "currency": currency,
      };
}
