import 'package:pointify/models/shop_model.dart';

class AdminModel {
  AdminModel({
    this.id,
    this.name,
    this.email,
    this.phonenumber,
    this.attendantId,
    this.shops,
  });

  String? id;
  String? attendantId;
  String? name;
  String? email;
  String? phonenumber;
  List<ShopModel>? shops;

  factory AdminModel.fromJson(Map<String, dynamic> json) => AdminModel(
        id: json["_id"],
        attendantId: json["attendantid"],
        name: json["name"],
        email: json["email"],
        shops: List<ShopModel>.from(
            json["shops"].map((x) => ShopModel.fromJson(x))),
        phonenumber: json["phonenumber"],
      );
}
