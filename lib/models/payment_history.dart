class PayHistory {
  String? customer;
  int? amountPaid;
  int? balance;
  String? sale;
  DateTime? createdAt;

  PayHistory(
      {this.customer,
      this.sale,
      this.amountPaid,
      this.balance,
      this.createdAt});

  factory PayHistory.fromJson(Map<String, dynamic> json) => PayHistory(
        customer: json["customer"],
        amountPaid: json["amountPaid"],
        balance: json["balance"],
        sale: json["sale"],
        createdAt: DateTime.parse(json["createdAt"]),
      );
}
