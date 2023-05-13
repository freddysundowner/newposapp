import 'package:pointify/models/attendant_model.dart';
import 'package:pointify/models/product_model.dart';

import 'invoice_items.dart';

class SalesReturn {
  InvoiceItem? saleOrderItemModel;
  AttendantModel? attendant;
  int? count;
  ProductModel? productModel;
  SalesReturn(
      {this.saleOrderItemModel, this.attendant, this.count, this.productModel});

  factory SalesReturn.fromJson(json) {
    return SalesReturn(
        saleOrderItemModel:
            json["saleItem"] == null || json["saleItem"].toString().length <= 40
                ? InvoiceItem()
                : InvoiceItem.fromJson(json["saleItem"]),
        count: json["count"],
        attendant: json["attendant"] == null ||
                json["attendant"].toString().length <= 40
            ? AttendantModel()
            : AttendantModel.fromJson(json["attendant"]),
        productModel:
            json["product"] == null || json["product"].toString().length <= 40
                ? ProductModel()
                : ProductModel.fromJson(json["product"]));
  }
}
