
class DepositModel {
  DepositModel({
    this.id,
    this.customerId,
    this.amount,
    this.recieptNumber,
    this.type,
    this.createdAt,
    this.updatedAt,

  });

  String? id;
  String? customerId;
  int? amount;
  String? recieptNumber;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;


  factory DepositModel.fromJson(Map<String, dynamic> json) => DepositModel(
    id: json["_id"],
    customerId: json["customerId"],
    amount: json["amount"],
    recieptNumber: json["receiptNumber"],
    type:json["type"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),

  );
}