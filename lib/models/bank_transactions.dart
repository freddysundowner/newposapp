class BankTransactions {
  String? id;
  String? shop;
  String? category;
  int? amount;
  DateTime? createdAt;

  BankTransactions(
      {this.id, this.amount, this.shop, this.createdAt, this.category});

  factory BankTransactions.fromJson(Map<String, dynamic> json) =>
      BankTransactions(
          id: json["id"],
          shop: json["shop"],
          category: json["category"],
          amount: json["amount"],
          createdAt: DateTime.parse(json["createdAt"]));
}
