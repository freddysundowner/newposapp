class ProfitSummary {
  int? profit;
  int? sales;
  int? expenses;

  ProfitSummary({this.sales, this.expenses, this.profit});

  factory ProfitSummary.fromJson(Map<String, dynamic> json) => ProfitSummary(
        sales: json["sales"],
        expenses: json["expenses"],
        profit: json["profit"],
      );
}
