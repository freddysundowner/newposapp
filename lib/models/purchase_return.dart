import 'package:pointify/models/attendant_model.dart';
import 'package:pointify/models/product_model.dart';
import 'package:pointify/models/supplier.dart';

import 'invoice_items.dart';

class PurchaseReturn {
  InvoiceItem? saleOrderItemModel;
  AttendantModel? attendant;
  SupplierModel? supplier;
  int? count;
  ProductModel? productModel;
  DateTime? createdAt;
  DateTime? updatedAt;
  PurchaseReturn(
      {this.saleOrderItemModel,
      this.attendant,
      this.count,
      this.productModel,
      this.createdAt,
      this.updatedAt,
      this.supplier});

  factory PurchaseReturn.fromJson(json) {
    return PurchaseReturn(
        saleOrderItemModel: json["purchaseItem"] == null ||
                json["purchaseItem"].toString().length <= 40
            ? InvoiceItem()
            : InvoiceItem.fromJson(json["purchaseItem"]),
        count: json["count"],
        attendant: json["attendant"] == null ||
                json["attendant"].toString().length <= 40
            ? AttendantModel()
            : AttendantModel.fromJson(json["attendant"]),
        supplier:
            json["supplier"] == null || json["supplier"].toString().length <= 40
                ? SupplierModel()
                : SupplierModel.fromJson(json["supplier"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        productModel:
            json["product"] == null || json["product"].toString().length <= 40
                ? ProductModel()
                : ProductModel.fromJson(json["product"]));
  }
}
