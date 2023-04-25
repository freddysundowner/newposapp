import 'package:flutterpos/models/attendant_model.dart';
import 'package:flutterpos/models/customer_model.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/models/shop_model.dart';
import 'package:flutterpos/services/shop.dart';

class SupplyOrderModel {
  SupplyOrderModel({
    this.id,
    this.product,
    this.shop,
    this.attendantid,
    this.supplier,
    this.total,
    this.quantity,
    this.returned,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  String? id;
  ProductModel? product;
  ShopModel? shop;
  AttendantModel? attendantid;
  CustomerModel? supplier;
  int? total;
  int? quantity;
  bool? returned;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory SupplyOrderModel.fromJson(Map<String, dynamic> json) =>
      SupplyOrderModel(
        id: json["_id"],
        product: json["product"] == null
            ? null
            : ProductModel.fromJson(json["product"]),
        shop: json["shop"]==null|| json["shop"].toString().length<=40?null:ShopModel.fromJson(json["shop"]),
        attendantid: json["attendantId"] == null ||
                json["attendantId"].toString().length <= 40
            ? null
            : AttendantModel.fromJson(json["attendantId"]),
        supplier: json["supplier"] != null
            ? CustomerModel.fromJson(json["supplier"])
            : null,
        total: json["total"],
        quantity: json["quantity"],
        returned: json["returned"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );
}
