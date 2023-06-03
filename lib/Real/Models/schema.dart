import 'package:realm/realm.dart';
part 'schema.g.dart';

@RealmModel()
class _Invoice {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  _Supplier? supplier;
  _Shop? shop;
  _UserModel? attendantId;
  int? balance;
  int? total;
  String? receiptNumber;
  bool? onCredit;
  int? productCount;
  late List<_InvoiceItem> items;
  late List<_InvoiceItem> returneditems;
  DateTime? createdAt;
  DateTime? updatedAt;
}

@RealmModel()
class _Supplier {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  String? fullName;
  String? phoneNumber;
  String? shopId;
  String? emailAddress;
  String? location;
  @Ignored()
  int? email;
  @Ignored()
  int? address;
  String? credit;
  int? balance;
  bool? onCredit;
  DateTime? createdAt;
}

@RealmModel()
class _Shop {
  @MapTo('_id')
  @PrimaryKey()
  ObjectId? id;
  String? name;
  String? location;
  _ShopTypes? type;
  String? owner;
  String? currency;
}

@RealmModel()
class _UserModel {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  String? fullnames;
  String? phonenumber;
  _Shop? shop;
  late List<_RolesModel> roles;
  late String? usertype;
}

@RealmModel()
class _RolesModel {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  String? key;
  String? name;
}

@RealmModel()
class _ShopTypes {
  String? title;
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
}

@RealmModel()
class _Product {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  String? name;
  int? quantity;
  _ProductCategory? category;
  int? stockLevel;
  late List<String> sellingPrice;
  _Shop? shop;
  int? discount;
  _UserModel? attendant;
  int? buyingPrice;
  int? minPrice;
  int? badstock;
  String? description;
  String? unit;
  bool? deleted;
  bool? counted;
  String? supplier;

  int? cartquantity;
  int? amount;
  int? selling;

  String? counteddate;
  String? date;
  DateTime? createdAt;
  DateTime? updatedAt;
}

@RealmModel()
class _ProductCategory {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  String? name;
  _Shop? shop;
  DateTime? createdAt;
  DateTime? updatedAt;
}

@RealmModel()
class _BadStock {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  String? description;
  int? quantity;
  int? date;
  DateTime? createdAt;
  DateTime? updatedAt;
  _Product? product;
  _UserModel? attendantId;
  _Shop? shop;
}

@RealmModel()
class _BankModel {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  String? shop;
  String? name;
  int? amount;
  DateTime? createdAt;
  DateTime? updatedAt;
}

@RealmModel()
class _BankTransactions {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  String? shop;
  String? category;
  int? amount;
  DateTime? createdAt;
}

@RealmModel()
class _CashFlowCategory {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  String? name;
  int? amount;
  String? type;
  String? shop;
  DateTime? createdAt;
}

@RealmModel()
class _CashflowSummary {
  int? totalExpenses;
  int? cashinhand;
  int? totalbanked;
  int? totalSales;
  int? totalpurchases;
  int? totalwallet;
  int? creditTotal;
  int? totalcashin;
  int? totalcashout;
}

@RealmModel()
class _CustomerModel {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  String? fullName;
  String? phoneNumber;
  int? walletBalance;
  bool? onCredit;
  int? credit;
  _Shop? shopId;
  String? gender;
  String? email;
  String? address;
  DateTime? createdAt;
}

@RealmModel()
class _DepositModel {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  _CustomerModel? customer;
  @Ignored()
  String? customerId;
  int? amount;
  _SalesModel? receipt;
  String? recieptNumber;
  String? type;
  _UserModel? attendant;
  DateTime? createdAt;
  DateTime? updatedAt;
}

@RealmModel()
class _ExpenseModel {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  String? category;
  int? amount;
  String? shop;
  String? name;
  _UserModel? attendantId;
  int? date;
  DateTime? createdAt;
  DateTime? updatedAt;
}

@RealmModel()
class _InvoiceItem {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  _Product? product;
  String? type;
  String? shop;
  _Supplier? supplier;
  _Invoice? invoice;
  _UserModel? attendantid;
  @Ignored()
  _CustomerModel? customerId;
  int? total;
  int? itemCount;
  int? returnedItems;
  int? price;
  @Ignored()
  _SalesModel? sale;
  DateTime? createdAt;
  DateTime? updatedAt;
}

@RealmModel()
class _PayHistory {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  _UserModel? attendant;
  @Ignored()
  late _CustomerModel customerr;
  @Ignored()
  String? customer;
  int? amountPaid;
  int? balance;
  _Invoice? invoice;
  _SalesModel? receipt;
  DateTime? createdAt;
}

@RealmModel()
class _Plan {
  late String title;
  late double price;
  late String description;
  late int shops;
  late int time;
}

@RealmModel()
class _ProductCountModel {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  _Product? product;
  int? quantity;
  int? initialquantity;
  _UserModel? attendantId;
  _Shop? shopId;
  @Ignored()
  String? shop;
  DateTime? createdAt;
  DateTime? updatedAt;
}

@RealmModel()
class _ProductHistoryModel {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  _Product? product;
  ObjectId? stockTransferHistory;
  String? type;
  int? quantity;
  String? shop;
  String? supplier;
  _Shop? toShop;
  _CustomerModel? customer;
  DateTime? createdAt;
}

@RealmModel()
class _ProductTransferHistories {
  _Product? product;
  int? quantity;
  DateTime? createdAt;
}

@RealmModel()
class _ProfitModel {
  late List<_BadStock> profit;
  late List<_BadStock> totalsales;
  late List<_BadStock> badstock;
  late List<_BadStock> expense;
  int? shopProfit;
}

@RealmModel()
class _ProfitSummary {
  int? profit;
  int? sales;
  int? expenses;
}

@RealmModel()
class _PurchaseReturn {
  _InvoiceItem? saleOrderItemModel;
  _UserModel? attendant;
  _Supplier? supplier;
  int? count;
  _Product? productModel;
  DateTime? createdAt;
  DateTime? updatedAt;
}

@RealmModel()
class _SalesModel {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  String? receiptNumber;
  _Shop? shop;
  _UserModel? attendantId;
  _CustomerModel? customerId;
  int? grandTotal;
  int? creditTotal;
  late int? returnsCount;
  late List<_ReceiptItem> items;
  late List<_ReceiptItem> returneditems;
  int? totalDiscount;
  int? quantity;
  String? paymentMethod;
  int? dated;
  String? date;
  String? dueDate;
  DateTime? createdAt;
  DateTime? updatedAt;
}

@RealmModel()
class _ReceiptItem {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  _Product? product;
  _SalesModel? receipt;
  _CustomerModel? customerId;
  int? quantity;
  _Shop? shop;
  String? type;
  String? date;
  int? soldOn;
  int? total;
  int? discount;
  @Ignored()
  int? itemCount;
  int? price;
  DateTime? createdAt;
  DateTime? updatedAt;
}

@RealmModel()
class _SalesReturn {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  _ReceiptItem? receiptItem;
  _SalesModel? sale;
  @Ignored()
  _InvoiceItem? saleOrderItemModel;
  _UserModel? attendant;
  int? count;
  _Product? productModel;
}

@RealmModel()
class _SalesSummary {
  int? grossProfit;
  int? totalExpense;
  int? sales;
  int? profitOnSales;
  int? badStockValue;
}

@RealmModel()
class _StockInCredit {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  String? supplier;
  String? shop;
  String? attendant;
  int? balance;
  int? total;
  String? recietNumber;
  DateTime? createdAt;
  DateTime? updatedAt;
}

@RealmModel()
class _StockTransferHistory {
  @PrimaryKey()
  @MapTo("_id")
  ObjectId? id;
  _Shop? from;
  _UserModel? attendant;
  _Shop? to;
  late List<String> product;
  String? type;
  DateTime? createdAt;
  DateTime? updatedAt;
}
