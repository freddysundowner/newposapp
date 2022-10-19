class ShopModel {
  ShopModel(
      {this.id,
      this.name,
      this.location,
      this.owner,
      this.type,
      this.currency});

  String? id;
  String? name;
  String? location;
  String? owner;
  String? type;
  String? currency;

  factory ShopModel.fromJson(Map<String, dynamic> json) => ShopModel(
        id: json["_id"],
        name: json["name"],
        location: json["location"],
        owner: json["owner"],
        type: json["type"],
        currency: json["currency"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "location": location,
        "owner": owner,
        "type": type,
        "currency": currency,
      };
}
