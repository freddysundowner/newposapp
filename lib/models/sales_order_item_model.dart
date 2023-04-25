import 'package:flutterpos/models/attendant_model.dart';
import 'package:flutterpos/models/customer_model.dart';
import 'package:flutterpos/models/product_model.dart';


class SaleOrderItemModel {
  SaleOrderItemModel({
    this.id,
    this.product,
    this.shop,
    this.attendantid,
    this.customerId,
    this.total,
    this.itemCount,
    this.price,
    this.sale,
    this.returned,
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
  int? price;
  String? sale;
  bool? returned;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  factory SaleOrderItemModel.fromJson(Map<String, dynamic> json) =>
      SaleOrderItemModel(
        id: json["_id"],
        product: json["product"] == null
            ? null
            : ProductModel.fromJson(json["product"]),
        shop: json["shop"],
        attendantid: json["attendantId"] == null
            ? null
            : AttendantModel.fromJson(json["attendantId"]),
        customerId: json["customerId"] == null
            ? null
            : CustomerModel.fromJson(json["customerId"]),
        total: json["total"],
        itemCount: json["itemCount"],
        price: json["price"],
        sale: json["sale"],
        returned: json["returned"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );
}
