import 'package:pointify/models/attendant_model.dart';
import 'package:pointify/models/supplier.dart';

class Invoice {
  Invoice({
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
  SupplierModel? supplier;
  String? shop;
  AttendantModel? attendantId;
  int? balance;
  int? total;
  String? receiptNumber;
  bool? onCredit;
  int? productCount;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Invoice.fromJson(Map<String, dynamic> json) => Invoice(
        id: json["_id"],
        supplier:
            json["supplier"] == null || json["supplier"].toString().length <= 40
                ? SupplierModel()
                : SupplierModel.fromJson(json["supplier"]),
        shop: json["shop"],
        attendantId: json["attendantId"] == null ||
                json["attendantId"].toString().length <= 40
            ? AttendantModel()
            : AttendantModel.fromJson(json["attendantId"]),
        balance: json["balance"],
        total: json["total"],
        receiptNumber: json["receiptNumber"],
        onCredit: json["onCredit"],
        productCount: json["productCount"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
}
