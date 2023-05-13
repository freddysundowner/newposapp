import 'package:pointify/models/attendant_model.dart';
import 'package:pointify/models/customer_model.dart';
import 'package:pointify/models/product_model.dart';
import 'package:pointify/models/receipt.dart';

class InvoiceItem {
  InvoiceItem({
    this.id,
    this.product,
    this.shop,
    this.attendantid,
    this.customerId,
    this.total,
    this.itemCount,
    this.price,
    this.returnedItems,
    this.sale,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  ProductModel? product;
  String? shop;
  AttendantModel? attendantid;
  CustomerModel? customerId;
  int? total;
  int? itemCount;
  int? returnedItems;
  int? price;
  SalesModel? sale;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory InvoiceItem.fromJson(Map<String, dynamic> json) => InvoiceItem(
        id: json["_id"],
        product:
            json["product"] == null || json["product"].toString().length <= 40
                ? null
                : ProductModel.fromJson(json["product"]),
        shop: json["shop"],
        attendantid: json["attendantId"] == null ||
                json["attendantId"].toString().length <= 40
            ? null
            : AttendantModel.fromJson(json["attendantId"]),
        customerId: json["customerId"] == null ||
                json["customerId"].toString().length <= 40
            ? null
            : CustomerModel.fromJson(json["customerId"]),
        total: json["total"] ?? 0,
        itemCount: json["quantity"] ?? 0,
        returnedItems: json["returnedItems"] ?? 0,
        price: json["price"] ?? 0,
        sale: json["sale"] == null || json["sale"].toString().length <= 40
            ? SalesModel()
            : SalesModel.fromJson(json["sale"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );
}
