import 'package:flutterpos/models/roles_model.dart';
import 'package:flutterpos/models/shop_model.dart';

class AttendantModel {
  AttendantModel({
    this.id,
    this.fullnames,
    this.attendid,
    this.phonenumber,
    this.shop,
    this.roles,
  });
  String? id;
  String? fullnames;
  String? phonenumber;
  int? attendid;
  ShopModel? shop;
  List<RolesModel>? roles;

  factory AttendantModel.fromJson(Map<String, dynamic> json) {
    return AttendantModel(
      id: json["_id"],
      fullnames: json["fullnames"],
      attendid: json["attendid"],
      phonenumber: json["phonenumber"],
      shop: json["shop"] == null ? null : ShopModel.fromJson(json["shop"]),
      roles: List<RolesModel>.from(json["roles"].map((x) => RolesModel.fromJson(x))),
    );
  }
}
