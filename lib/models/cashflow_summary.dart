class CashflowSummary {
  int? totalExpenses;
  int? cashinhand;
  int? totalbanked;
  int? totalSales;
  int? totalpurchases;
  int? totalwallet;
  int? creditTotal;
  int? totalcashin;
  int? totalcashout;

  CashflowSummary(
      {this.cashinhand,
      this.totalbanked,
      this.creditTotal,
      this.totalExpenses,
      this.totalpurchases,
      this.totalSales,
      this.totalwallet,
      this.totalcashin,
      this.totalcashout});

  factory CashflowSummary.fromJson(Map<String, dynamic> json) =>
      CashflowSummary(
          totalExpenses: json["totalExpenses"],
          cashinhand: json["cashinhand"],
          creditTotal: json["creditTotal"],
          totalbanked: json["totalbanked"],
          totalSales: json["totalSales"],
          totalpurchases: json["totalpurchases"],
          totalwallet: json["totalwallet"],
          totalcashin: json["totalcashin"],
          totalcashout: json["totalcashout"]);
}
