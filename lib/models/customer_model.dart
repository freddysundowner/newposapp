import 'package:flutterpos/models/shop_model.dart';

class CustomerModel {
  CustomerModel(
      {this.id,
      this.fullName,
      this.phoneNumber,
      this.shopId,
      this.gender,
      this.email,
      this.address,
      this.wallet,
      this.onCredit,
      this.credit});

  String? id;
  String? fullName;
  String? phoneNumber;
  int? wallet;
  bool? onCredit;
  int? credit;
  ShopModel? shopId;
  String? gender;
  String? email;
  String? address;

  factory CustomerModel.fromJson(Map<String, dynamic> json) => CustomerModel(
      id: json["_id"],
      fullName: json["fullName"],
      phoneNumber: json["phoneNumber"],
      shopId: ShopModel.fromJson(json["shopId"]),
      gender: json["gender"] ?? "",
      email: json["email"] ?? "",
      address: json["address"] ?? "",
      wallet: json["wallet"],
      onCredit: json["onCredit"],
      credit: json["credit"]);

}
