class RolesModel {
  String key;
  String name;
  RolesModel({required this.key, required this.name});

  factory RolesModel.fromJson(json) {
    return RolesModel(key: json["key"], name: json["value"]);
  }

  Map<String, dynamic> toJson() => {
    "key": key,
    "value": name,
  };
}