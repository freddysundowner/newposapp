class CashFlowCategory {
  String? id;
  String? name;
  int? amount;
  String? type;
  String? shop;
  DateTime? createdAt;

  CashFlowCategory({this.type,this.shop,this.name,this.amount,this.id,this.createdAt});

  factory CashFlowCategory.fromJson(Map<String,dynamic>json)=>CashFlowCategory(
    id: json["_id"],
    name: json["name"],
    amount: json["amount"],
    type: json["type"],
    shop: json["shop"],
    createdAt: DateTime.parse(json["createdAt"])
  );


}
