class ShopCategory {
  String title;
  String id;
  ShopCategory({required this.title, required this.id});

  factory ShopCategory.fromJson(json) =>
      ShopCategory(title: json["title"], id: json["_id"]);
}
