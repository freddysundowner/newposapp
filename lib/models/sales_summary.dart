class SalesSummary {
  int? grossProfit;
  int? totalExpense;
  int? sales;
  int? profitOnSales;
  int? badStockValue;

  SalesSummary(
      {this.grossProfit,
      this.totalExpense,
      this.badStockValue,
      this.sales,
      this.profitOnSales});

  factory SalesSummary.fromJson(Map<String, dynamic> json) => SalesSummary(
        grossProfit: json["grossProfit"],
        totalExpense: json["totalExpenses"],
        sales: json["sales"],
        profitOnSales: json["profitOnSales"],
        badStockValue: json["badStockValue"],
      );
}
