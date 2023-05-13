import 'package:pointify/models/attendant_model.dart';
import 'package:pointify/models/customer_model.dart';
import 'package:pointify/models/shop_model.dart';

class SalesModel {
  SalesModel({
    this.id,
    this.receiptNumber,
    this.shop,
    this.attendantId,
    this.customerId,
    this.grandTotal,
    this.creditTotal,
    this.quantity,
    this.returnedItems,
    this.paymentMethod,
    this.dueDate,
    this.createdAt,
    this.updatedAt,
  });

  String? id;
  String? receiptNumber;
  ShopModel? shop;
  AttendantModel? attendantId;
  CustomerModel? customerId;
  int? grandTotal;
  int? creditTotal;
  List<String>? returnedItems;
  int? totalDiscount;
  int? quantity;
  String? paymentMethod;
  String? dueDate;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory SalesModel.fromJson(Map<String, dynamic> json) => SalesModel(
        id: json["_id"],
        receiptNumber: json["receiptNumber"],
        shop: json["shop"] == null || json["shop"].toString().length <= 40
            ? ShopModel()
            : ShopModel.fromJson(json["shop"]),
        attendantId: json["attendantId"] == null ||
                json["attendantId"].toString().length <= 40
            ? AttendantModel()
            : AttendantModel.fromJson(json["attendantId"]),
        customerId: json["customerId"] == null ||
                json["customerId"].toString().length <= 40
            ? null
            : CustomerModel.fromJson(json["customerId"]),
        returnedItems: List<String>.from(json["returnedItems"].map((x) => x)),
        grandTotal: json["grandTotal"],
        creditTotal: json["creditTotal"],
        quantity: json["quantity"],
        paymentMethod: json["paymentMethod"],
        dueDate: json["dueDate"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
}
