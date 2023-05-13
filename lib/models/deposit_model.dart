import 'package:pointify/models/attendant_model.dart';

class DepositModel {
  DepositModel({
    this.id,
    this.customerId,
    this.amount,
    this.attendant,
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
  AttendantModel? attendant;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory DepositModel.fromJson(Map<String, dynamic> json) => DepositModel(
        id: json["_id"],
        customerId: json["customerId"],
        amount: json["amount"],
        recieptNumber: json["receiptNumber"],
        attendant: json["attendant"] != null
            ? AttendantModel.fromJson(json["attendant"])
            : null,
        type: json["type"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
}
