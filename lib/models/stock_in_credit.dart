class StockInCredit {
  StockInCredit({
    this.id,
    this.supplier,
    this.shop,
    this.attendant,
    this.balance,
    this.total,
    this.recietNumber,
    this.createdAt,
    this.updatedAt,
  });

  String ?id;
  String ?supplier;
  String ?shop;
  String? attendant;
  int? balance;
  int ?total;
  String ?recietNumber;
  DateTime? createdAt;
  DateTime ?updatedAt;


  factory StockInCredit.fromJson(Map<String, dynamic> json) => StockInCredit(
    id: json["_id"],
    supplier: json["supplier"],
    shop: json["shop"],
    attendant: json["attendant"],
    balance: json["balance"],
    total: json["total"],
    recietNumber: json["recietNumber"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );
}