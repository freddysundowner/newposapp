class BankModel {
  BankModel({
    this.id,
    this.shop,
    this.category,
    this.bankname,
    this.amount,
    this.type,
    this.createdAt,
    this.updatedAt,

  });

  String? id;
  String? shop;
  String? category;
  Bankname? bankname;
  int? amount;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;


  factory BankModel.fromJson(Map<String, dynamic> json) => BankModel(
    id: json["_id"],
    shop: json["shop"],
    category: json["category"],
    bankname: Bankname.fromJson(json["bankname"]),
    amount: json["amount"],
    type: json["type"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),

  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "shop": shop,
    "category": category,
    "bankname": bankname!.toJson(),
    "amount": amount,
    "type": type,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),
  };
}

class Bankname {
  Bankname({
    this.id,
    this.name,
    this.category,
    this.amount,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? name;
  String? category;
  int? amount;
  DateTime? createdAt;
  DateTime? updatedAt;


  factory Bankname.fromJson(Map<String, dynamic> json) => Bankname(
    id: json["_id"],
    name: json["name"],
    category: json["category"],
    amount: json["amount"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),

  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "category": category,
    "amount": amount,
    "createdAt": createdAt!.toIso8601String(),
    "updatedAt": updatedAt!.toIso8601String(),

  };
}