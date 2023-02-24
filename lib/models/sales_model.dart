import 'package:flutterpos/models/attendant_model.dart';
import 'package:flutterpos/models/customer_model.dart';
import 'package:flutterpos/models/shop_model.dart';

class SalesModel {
  SalesModel({
    this.id,
    this.receiptNumber,
    this.shop,
    this.attendantId,
    this.customerId,
    this.grandTotal,
    this.creditTotal,
    this.totalDiscount,
    this.quantity,
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
  int? totalDiscount;
  int? quantity;
  String? paymentMethod;
  String? dueDate;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory SalesModel.fromJson(Map<String, dynamic> json) => SalesModel(
        id: json["_id"],
        receiptNumber: json["receiptNumber"],
        shop: json["shop"] == null ? null : ShopModel.fromJson(json["shop"]),
        attendantId: json["attendantId"] == null
            ? AttendantModel()
            : AttendantModel.fromJson(json["attendantId"]),
        customerId: json["customerId"] == null
            ? null
            : CustomerModel.fromJson(json["customerId"]),
        grandTotal: json["grandTotal"],
        creditTotal: json["creditTotal"],
        totalDiscount: json["totalDiscount"],
        quantity: json["quantity"],
        paymentMethod: json["paymentMethod"],
        dueDate: json["dueDate"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );
}





