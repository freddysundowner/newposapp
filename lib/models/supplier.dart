import 'package:pointify/models/shop_model.dart';

class SupplierModel {
  SupplierModel(
      {this.id,
      this.fullName,
      this.phoneNumber,
      this.shopId,
      this.gender,
      this.email,
      this.address,
      this.walletBalance,
      this.onCredit,
      this.credit});

  String? id;
  String? fullName;
  String? phoneNumber;
  int? walletBalance;
  bool? onCredit;
  int? credit;
  ShopModel? shopId;
  String? gender;
  String? email;
  String? address;

  factory SupplierModel.fromJson(Map<String, dynamic> json) => SupplierModel(
      id: json["_id"],
      fullName: json["fullName"],
      phoneNumber: json["phoneNumber"],
      shopId: json["shopId"] == null || json["shopId"].toString().length <= 40
          ? ShopModel()
          : ShopModel.fromJson(json["shopId"]),
      gender: json["gender"] ?? "",
      email: json["email"] ?? "",
      address: json["address"] ?? "",
      walletBalance: json["walletBalance"],
      onCredit: json["onCredit"],
      credit: json["credit"] == null ? 0 : json["credit"]);
}
