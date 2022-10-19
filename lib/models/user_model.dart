import 'package:flutterpos/models/shop_model.dart';

class UserModel {
  UserModel({
    this.id,
    this.name,
    this.email,
    this.phonenumber,
    this.shops,
  });

  String? id;
  String? name;
  String? email;
  String? phonenumber;
  List<ShopModel>? shops;

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        name: json["name"],
        email: json["email"],
        shops: List<ShopModel>.from(
            json["shops"].map((x) => ShopModel.fromJson(x))),
        phonenumber: json["phonenumber"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "email": email,
        "phonenumber": phonenumber,
      };
}
