
class PurchaseOrder {
  PurchaseOrder({
    this.id,
    this.supplier,
    this.shop,
    this.attendantId,
    this.balance,
    this.total,
    this.receiptNumber,
    this.onCredit,
    this.productCount,
    this.createdAt,
    this.updatedAt,

  });

  String? id;
  String ?supplier;
  String ?shop;
  String? attendantId;
  int ?balance;
  int ?total;
  String? receiptNumber;
  bool ?onCredit;
  int ?productCount;
  DateTime? createdAt;
  DateTime? updatedAt;


  factory PurchaseOrder.fromJson(Map<String, dynamic> json) => PurchaseOrder(
    id: json["_id"],
    supplier: json["supplier"],
    shop: json["shop"],
    attendantId: json["attendantId"],
    balance: json["balance"],
    total: json["total"],
    receiptNumber: json["receiptNumber"],
    onCredit: json["onCredit"],
    productCount: json["productCount"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
  );

}
