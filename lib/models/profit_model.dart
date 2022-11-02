
import 'dart:convert';
ProfitModel profitFromJson(String str) => ProfitModel.fromJson(json.decode(str));
class ProfitModel {
  ProfitModel({
    this.profit,
    this.totalsales,
    this.badstock,
    this.expense,
    this.shopProfit
  });

  List<Badstock> ?profit;
  List<Badstock>? totalsales;
  List<Badstock>? badstock;
  List<Badstock> ?expense;
  int ?shopProfit;

  factory ProfitModel.fromJson(Map<String, dynamic> json) => ProfitModel(

      profit: List<Badstock>.from(json["profit"].map((x) => Badstock.fromJson(x))),
      totalsales: List<Badstock>.from(json["totalsales"].map((x) => Badstock.fromJson(x))),
      badstock: List<Badstock>.from(json["badstock"].map((x) => Badstock.fromJson(x))),
      expense: List<Badstock>.from(json["expense"].map((x) => Badstock.fromJson(x))),
      shopProfit: json["shopProfit"]
  );
}

class Badstock {
  Badstock({
    this.id,
    this.totalAmount,
  });

  String? id;
  int ?totalAmount;

  factory Badstock.fromJson(Map<String, dynamic> json) => Badstock(
    id: json["_id"],
    totalAmount: json["totalAmount"],
  );

}
