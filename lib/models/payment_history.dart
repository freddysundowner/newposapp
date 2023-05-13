import 'package:pointify/models/attendant_model.dart';

class PayHistory {
  AttendantModel? attendant;
  String? customer;
  int? amountPaid;
  int? balance;
  String? sale;
  DateTime? createdAt;

  PayHistory(
      {this.customer,
      this.sale,
      this.attendant,
      this.amountPaid,
      this.balance,
      this.createdAt});

  factory PayHistory.fromJson(Map<String, dynamic> json) => PayHistory(
        customer: json["customer"],
        attendant: json["attendant"] == null ||
                json["attendant"].toString().length <= 40
            ? AttendantModel()
            : AttendantModel.fromJson(json["attendant"]),
        amountPaid: json["amountPaid"],
        balance: json["balance"],
        sale: json["sale"],
        createdAt: DateTime.parse(json["createdAt"]),
      );
}
