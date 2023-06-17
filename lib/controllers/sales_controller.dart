import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pointify/controllers/expense_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/wallet_controller.dart';
import 'package:pointify/main.dart';
import 'package:pointify/screens/cash_flow/wallet_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pointify/screens/sales/components/sales_receipt.dart';
import 'package:pointify/widgets/alert.dart';
import 'package:realm/realm.dart';

import '../Real/schema.dart';
import '../functions/functions.dart';
import '../services/customer.dart';
import '../services/expense.dart';
import '../services/payment.dart';
import '../services/product.dart';
import '../services/sales.dart';
import '../utils/colors.dart';

class SalesData {
  SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class SalesController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  TextEditingController textEditingSellingPrice = TextEditingController();
  TextEditingController textEditingReturnProduct = TextEditingController();
  TextEditingController textEditingCredit = TextEditingController();
  TextEditingController amountPaid = TextEditingController();
  RxList<SalesModel> allSales = RxList([]);
  RxnInt allSalesTotal = RxnInt(0);
  RxnInt netProfit = RxnInt(0);
  RxnInt totalbadStock = RxnInt(0);
  RxnInt totalSalesReturned = RxnInt(0);
  RxList<SalesModel> todaySales = RxList([]);
  RxList<SalesReturn> returns = RxList([]);
  Rxn<SalesModel> currentReceipt = Rxn(null);
  RxList<ReceiptItem> currentReceiptReturns = RxList([]);
  RxList<ReceiptItem> productSales = RxList([]);
  RxList<SalesModel> creditSales = RxList([]);
  RxList<PayHistory> paymenHistory = RxList([]);
  RxList<SalesData> listSalesData = RxList([]);
  Rxn<SalesSummary> salesSummary = Rxn(null);
  RxInt grossProfit = RxInt(0);
  RxInt currentYear = RxInt(DateTime.now().year);
  var filterStartDate =
      DateTime.parse(DateFormat("yyy-MM-dd").format(DateTime.now())).obs;
  var filterEnndStartDate = DateTime.parse(
          DateFormat("yyy-MM-dd").format(DateTime.now().add(Duration(days: 1))))
      .obs;
  TextEditingController searchProductController = TextEditingController();

  RxInt totalSalesByDate = RxInt(0);
  RxInt salesInitialIndex = RxInt(0);
  Rxn<Product> selecteProduct = Rxn(null);
  RxBool saveSaleLoad = RxBool(false);
  RxBool getSalesByLoad = RxBool(false);
  RxBool getPaymentHistoryLoad = RxBool(false);

  RxBool salesOrderItemLoad = RxBool(false);
  RxBool salesOnCreditLoad = RxBool(false);
  RxBool loadingSales = RxBool(false);
  RxList paymentMethods = RxList(["Cash", "Credit"]);
  Rxn<SalesModel> receipt = Rxn(null);
  RxList<SalesData> salesdata = RxList([]);
  RxList<SalesData> expensesdata = RxList([]);
  RxList<SalesData> profitdata = RxList([]);

  RxList<InvoiceItem> salesHistory = RxList([]);

  RxString activeItem = RxString("All Sales");
  RxString titleFilter = RxString("Filter by ~");

  getGraphSales({
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    if (fromDate == null) {
      int y = DateTime.now().year;
      DateTime now = DateTime(y, 1);
      fromDate = DateTime(now.year, now.month, 1);
      DateTime now2 = DateTime(y, 12);
      toDate = DateTime(now2.year, now2.month + 1, 0);
    }
    print(fromDate);
    print(toDate);
    Shop shop = Get.find<ShopController>().currentShop.value!;
    RealmResults<ReceiptItem> sales =
        Sales().getSaleReceipts(shop: shop, fromDate: fromDate, toDate: toDate);
    salesdata.value = [
      SalesData('Jan', 0),
      SalesData('Feb', 0),
      SalesData('Mar', 0),
      SalesData('Apr', 0),
      SalesData('May', 0),
      SalesData('Jun', 0),
      SalesData('Jul', 0),
      SalesData('Aug', 0),
      SalesData('Sept', 0),
      SalesData('Oct', 0),
      SalesData('Nov', 0),
      SalesData('Dec', 0),
    ];
    for (var element in sales) {
      var month = DateFormat("MMM")
          .format(DateTime.fromMillisecondsSinceEpoch(element.soldOn!));
      int i = salesdata.indexWhere((element) => element.year == month);
      if (i == -1) {
        salesdata.add(SalesData(month,
            double.parse((element.quantity! * element.price!).toString())));
      } else {
        salesdata[i] = SalesData(
            month,
            salesdata[i].sales +
                double.parse((element.quantity! * element.price!).toString()));
      }
    }
    listSalesData.addAll(salesdata);
    profitdata.value = [
      SalesData('Jan', 0),
      SalesData('Feb', 0),
      SalesData('Mar', 0),
      SalesData('Apr', 0),
      SalesData('May', 0),
      SalesData('Jun', 0),
      SalesData('Jul', 0),
      SalesData('Aug', 0),
      SalesData('Sept', 0),
      SalesData('Oct', 0),
      SalesData('Nov', 0),
      SalesData('Dec', 0),
    ];
    for (var element in sales) {
      var month = DateFormat("MMM")
          .format(DateTime.fromMillisecondsSinceEpoch(element.soldOn!));
      int i = profitdata.indexWhere((element) => element.year == month);
      double total = double.parse((((element.quantity! * element.price!) -
              element.quantity! * element.product!.buyingPrice!))
          .toString());
      if (i == -1) {
        profitdata.add(SalesData(month, total));
      } else {
        profitdata[i] = SalesData(month, profitdata[i].sales + total);
      }
      profitdata.refresh();
      titleFilter.refresh();
    }
    listSalesData.addAll(profitdata);

    RealmResults<ExpenseModel> response = Expense()
        .getExpenseByDate(shop: shop, fromDate: fromDate, toDate: toDate);
    expensesdata.value = [
      SalesData('Jan', 0),
      SalesData('Feb', 0),
      SalesData('Mar', 0),
      SalesData('Apr', 0),
      SalesData('May', 0),
      SalesData('Jun', 0),
      SalesData('Jul', 0),
      SalesData('Aug', 0),
      SalesData('Sept', 0),
      SalesData('Oct', 0),
      SalesData('Nov', 0),
      SalesData('Dec', 0),
    ];
    for (var element in response) {
      var month = DateFormat("MMM")
          .format(DateTime.fromMillisecondsSinceEpoch(element.date!));
      int i = expensesdata.indexWhere((element) => element.year == month);
      double total = double.parse(element.amount!.toString());
      if (i == -1) {
        expensesdata.add(SalesData(month, total));
      } else {
        expensesdata[i] = SalesData(month, expensesdata[i].sales + total);
      }
      int ei = profitdata.indexWhere((element) => element.year == month);
      if (ei != -1) {
        profitdata[ei] =
            SalesData(month, profitdata[ei].sales - expensesdata[i].sales);
      }
    }
    listSalesData.addAll(expensesdata);

    print("listSalesData ${listSalesData[2]}");
  }

  getTableVieData() {}

  getFinanceSummary({
    String? date = "",
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    print(fromDate);
    print(toDate);
    RealmResults<ReceiptItem> sales =
        Sales().getSaleReceipts(date: date, fromDate: fromDate, toDate: toDate);
    grossProfit.value = sales.fold(
        0,
        (previousValue, element) =>
            previousValue +
            ((element.price! * element.quantity!) -
                (element.quantity! * element.product!.buyingPrice!)));

    Get.find<ExpenseController>().getExpenseByDate(
      fromDate: fromDate,
      toDate: toDate,
    );
  }

  changesaleItem(ReceiptItem value) {
    var index = -1;
    if (receipt.value != null) {
      index = receipt.value!.items
          .indexWhere((element) => element.product!.id == value.product!.id);
    }
    if (index == -1) {
      if (receipt.value == null) {
        receipt.value =
            SalesModel(ObjectId(), items: [value], paymentMethod: "Cash");
      } else {
        receipt.value = SalesModel(receipt.value!.id,
            items: [...receipt.value!.items, value]);
      }
      index =
          receipt.value!.items.indexWhere((element) => element.id == value.id);
    } else {
      ReceiptItem receiptItem = receipt.value!.items[index];
      var newqty =
          int.parse(receipt.value!.items[index].quantity.toString()) + 1;
      if (newqty > receiptItem.product!.quantity!) {
        return;
      }
      receipt.value?.items[index].quantity = newqty;
    }
    calculateAmount(index);
    receipt.refresh();
  }

  decrementItem(index) {
    if (receipt.value!.items[index].quantity! > 1) {
      receipt.value?.items[index].quantity =
          receipt.value!.items[index].quantity! - 1;
      receipt.refresh();
    }
    calculateAmount(index);
  }

  incrementItem(index) {
    var increment = (receipt.value!.items[index].quantity! + 1);
    receipt.value?.items[index].quantity =
        increment > receipt.value!.items[index].product!.quantity!
            ? receipt.value!.items[index].quantity
            : increment;
    receipt.refresh();

    calculateAmount(index);
  }

  calculateAmount(index) {
    receipt.value!.grandTotal = 0;
    receipt.value!.creditTotal = 0;
    amountPaid.text = "0";

    receipt.value!.grandTotal = receipt.value!.items.fold(
        0,
        (previousValue, element) =>
            previousValue! +
            ((element.product!.selling! - element.discount!) *
                element.quantity!));

    amountPaid.text = receipt.value!.grandTotal.toString();

    receipt.value!.creditTotal =
        receipt.value!.grandTotal! - int.parse(amountPaid.text);
    if (index == -1) {
      return;
    }

    receipt.value?.items[index].price =
        (receipt.value!.items[index].product!.selling! -
            receipt.value!.items[index].discount!);

    receipt.value?.items[index].total =
        (receipt.value!.items[index].product!.selling! -
                receipt.value!.items[index].discount!) *
            receipt.value!.items[index!].quantity!;
    receipt.refresh();
  }

  removeFromList(index) {
    receipt.value?.items.removeAt(index);
    receipt.refresh();
    calculateAmount(-1);
  }

  saveSale({screen}) {
    String size =
        MediaQuery.of(Get.context!).size.width > 600 ? "large" : "small";
    if (_paymentType(receipt.value!) == "Credit") {
      if (receipt.value?.customerId == null) {
        generalAlert(
            title: "Error!", message: "please select customer to sell to");
        return;
      }
      if ((receipt.value!.customerId!.walletBalance == null ||
          receipt.value!.customerId!.walletBalance! <
              receipt.value!.grandTotal!)) {
        showDialog(
            context: Get.context!,
            builder: (_) {
              return AlertDialog(
                content: const Text(
                    "Customer Credit balance is insufficient!! credit the account?"),
                actions: [
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        "Cancel".capitalize!,
                        style: TextStyle(color: AppColors.mainColor),
                      )),
                  TextButton(
                      onPressed: () {
                        Get.back();
                        if (MediaQuery.of(Get.context!).size.width > 600) {
                          Get.find<HomeController>().selectedWidget.value =
                              WalletPage(
                            customerModel: receipt.value!.customerId!,
                            page: "makesale",
                          );
                        } else {
                          Get.to(() => WalletPage(
                                customerModel: receipt.value!.customerId!,
                                page: "makesale",
                              ));
                        }
                      },
                      child: Text(
                        "Credit".capitalize!,
                        style: TextStyle(color: AppColors.mainColor),
                      )),
                  TextButton(
                      onPressed: () {
                        if (receipt.value?.dueDate == null) {
                          showSaleDatePicker(
                              context: Get.context!,
                              shopId: Get.find<ShopController>()
                                  .currentShop
                                  .value
                                  ?.id,
                              size: size,
                              attendantsId:
                                  Get.find<UserController>().user.value?.id,
                              screen: screen);
                        } else {
                          Get.back();
                          saveReceipt();
                        }
                      },
                      child: Text(
                        "Continue anyway",
                        style: TextStyle(color: AppColors.mainColor),
                      ))
                ],
              );
            });
        return;
      } else {
        Get.back();
        saveReceipt();
      }
      return;
    }

    Get.back();
    saveReceipt();
  }

  _onCredit(SalesModel salesModel) => _paymentType(salesModel) == "Credit";

  void saveReceipt() {
    SalesModel receiptData = receipt.value!;
    receiptData.shop = Get.find<ShopController>().currentShop.value;
    receiptData.attendantId = Get.find<UserController>().user.value;
    receiptData.receiptNumber = getRandomString(10);
    receiptData.dated = DateTime.now().millisecondsSinceEpoch;
    receiptData.createdAt = DateTime.now();
    receiptData.totalDiscount = receiptData.items.fold(
        0,
        (previousValue, element) =>
            previousValue! + (element.discount! * element.quantity!));
    receiptData.quantity = receiptData.items.fold(
        0, (previousValue, element) => previousValue! + element.quantity!);
    receiptData.paymentMethod = _paymentType(receiptData);

    //debit customer wallet
    if (_onCredit(receiptData)) {
      var walletbalanace = (receiptData.customerId!.walletBalance ?? 0);
      if (receiptData.creditTotal == 0) {
        receiptData.creditTotal = receiptData.grandTotal! * -1;
      }
      var amountPaid = 0;
      if (receiptData.creditTotal!.abs() > walletbalanace) {
        amountPaid = receiptData.creditTotal!;
        receiptData.creditTotal = (walletbalanace + receiptData.creditTotal!);
      } else {
        receiptData.creditTotal = 0;
        amountPaid = receiptData.grandTotal!;
      }
      Get.find<WalletController>().WalletTransaction(
          customerModel: receiptData.customerId!,
          amount: amountPaid,
          type: "usage",
          salesModel: receiptData);
    }

    //save purchase invoice
    Sales().createSale(receiptData);
    if (_onCredit(receiptData)) {
      var amountPaid = receiptData.grandTotal! - receiptData.creditTotal!.abs();
      if (amountPaid > 0) {
        PayHistory paymentHistory = PayHistory(ObjectId(),
            attendant: Get.find<UserController>().user.value,
            amountPaid: amountPaid,
            balance: receiptData.creditTotal,
            receipt: receipt.value);
        Payment().createPayHistory(paymentHistory);
      }
    }

    //update product quantities
    for (var element in receiptData.items) {
      var itemsqtybalance = element.product!.quantity! - element.quantity!;
      Products().updateProductPart(
          product: element.product!, quantity: itemsqtybalance);
      //create product history
      ProductHistoryModel productHistoryModel = ProductHistoryModel(ObjectId(),
          quantity: element.product!.quantity!,
          customer: receipt.value?.customerId,
          shop: receiptData.shop!.id.toString(),
          product: element.product,
          type: "purchases");
      Products().createProductHistory(productHistoryModel);
    }
    Get.back();
    Get.to(() => SalesReceipt(
          salesModel: receiptData,
          type: "",
        ));
    receipt.value = null;
    refresh();
  }

  _paymentType(SalesModel salesModel) {
    if (salesModel.creditTotal! < 0) {
      return salesModel.paymentMethod != "Wallet"
          ? "Credit"
          : salesModel.paymentMethod;
    }
    return salesModel.paymentMethod ?? "Cash";
  }

  showSaleDatePicker(
      {required context,
      required shopId,
      required attendantsId,
      required size,
      required screen}) {
    showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: MediaQuery.of(context).copyWith().size.height * 0.50,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Text(
                        "Select Due date".capitalize!,
                        style: const TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height:
                          MediaQuery.of(context).copyWith().size.height * 0.3,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.dateAndTime,
                        onDateTimeChanged: (value) {
                          receipt.value!.dueDate =
                              DateFormat('MMMM/dd/yyyy hh:mm a')
                                  .parse(DateFormat('MMMM/dd/yyyy hh:mm a')
                                      .format(value))
                                  .toIso8601String();
                          receipt.refresh();
                        },
                        initialDateTime: DateTime.now(),
                        minimumYear: 2022,
                        maximumYear: 2050,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Cancel".toUpperCase(),
                            style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.back();
                            if (receipt.value!.dueDate == null) {
                              receipt.value!.dueDate =
                                  DateFormat('MMMM/dd/yyyy hh:mm a')
                                      .parse(DateFormat('MMMM/dd/yyyy hh:mm a')
                                          .format(DateTime.now()))
                                      .toIso8601String();
                            }
                            Get.back();
                            saveReceipt();
                          },
                          child: Text(
                            "Ok".toUpperCase(),
                            style: const TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2)
                  ]),
            ));
  }

  getSalesBySaleId({ObjectId? id}) async {
    SalesModel? receipt = Sales().getSalesBySaleId(id!);
    currentReceipt.value = receipt;
  }

  getSalesByProductId({Product? product}) async {
    productSales.clear();
    RealmResults<ReceiptItem>? receipt = Sales().getSalesByProductId(product!);
    productSales.addAll(receipt!.map((e) => e).toList());
    print(productSales.length);
  }

  getSales(
      {onCredit = false,
      DateTime? fromDate,
      DateTime? toDate,
      CustomerModel? customer,
      String total = "",
      String receipt = ""}) async {
    RealmResults<SalesModel> sales = Sales().getSales(
        fromDate: fromDate,
        receipt: receipt,
        toDate: toDate,
        onCredit: onCredit,
        customer: customer);
    allSales.clear();
    allSales.addAll(sales.map((e) => e).toList());
  }

  getProfitTransaction({
    DateTime? fromDate,
    DateTime? toDate,
    String? fromDatee,
    String? toDatee,
  }) async {
    if (fromDatee != null) {
      fromDate = DateTime.parse(fromDatee);
      toDate = DateTime.parse(toDatee!);
    }
    RealmResults<ReceiptItem> sales =
        Sales().getSaleReceipts(fromDate: fromDate, toDate: toDate);
    allSalesTotal.value = sales.fold(
        0,
        (previousValue, element) =>
            previousValue! + (element.price! * element.quantity!));

    getFinanceSummary(fromDate: fromDate, toDate: toDate);

    RealmResults<BadStock> badstock =
        Products().getBadStock(fromDate: fromDate, toDate: toDate);
    totalbadStock.value = badstock.fold(
        0,
        (previousValue, element) =>
            previousValue! +
            (element.product!.buyingPrice! * element.quantity!));

    Get.find<ExpenseController>()
        .getExpenseByDate(fromDate: fromDate, toDate: toDate);
  }

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    super.onInit();
  }

  void returnSale(ReceiptItem receiptItem, int quatity) async {
    var amount = quatity * receiptItem.price!; // amount to be returned
    ReceiptItem returnedReceipt = ReceiptItem(ObjectId(),
        quantity: quatity,
        product: receiptItem.product,
        total: amount,
        discount: receiptItem.discount,
        price: receiptItem.price,
        type: "return",
        receipt: currentReceipt.value,
        customerId: currentReceipt.value!.customerId);
    Sales().createSaleReceiptItem(returnedReceipt);
    //refund to the wallet if its was a wallet sale
    //if it was credit sale return the paid amount to the wallet
    if (_onCredit(currentReceipt.value!)) {
      //what was already paid
      var totalPaid = (amount - currentReceipt.value!.creditTotal!.abs());
      var totalRemoveFromWallet =
          totalPaid + currentReceipt.value!.creditTotal!.abs();

      Get.find<WalletController>().WalletTransaction(
          customerModel: currentReceipt.value!.customerId!,
          newbalance:
              _onCredit(currentReceipt.value!) ? totalRemoveFromWallet : amount,
          amount: amount,
          type: "deposit",
          salesModel: currentReceipt.value!);
    }

    //increate product quantity
    Products().updateProductPart(
        product: receiptItem.product!,
        quantity: receiptItem.product!.quantity! + quatity);

    //update receit item sold items qty and total
    var newqty = receiptItem.quantity! - quatity;
    Sales().updateReceiptItem(
        receiptItem: receiptItem,
        quantity: newqty,
        total: newqty * receiptItem.price!);

    // update receipt qty returned and re-calculate the total
    Sales().updateReceipt(
        receipt: currentReceipt.value!,
        total: currentReceipt.value!.items.fold(
            0,
            (previousValue, element) =>
                previousValue! + (element.quantity! * element.price!)),
        returnedquantity: quatity,
        creditBalance: (currentReceipt.value!.creditTotal!.abs() - amount) * -1,
        returnedItems: returnedReceipt);
    getSalesBySaleId(id: currentReceipt.value!.id);
    currentReceipt.refresh();
  }

  totalSales() {
    var subTotal = 0;
    for (var element in allSales) {
      subTotal = subTotal + element.grandTotal!;
    }
    return subTotal;
  }

  payCredit({required SalesModel salesBody, required int amount}) async {
    var newbalance = salesBody.creditTotal!.abs() - amount;
    Sales().updateReceipt(receipt: salesBody, creditBalance: -newbalance);
    PayHistory payHistory = PayHistory(ObjectId(),
        attendant: Get.find<UserController>().user.value,
        amountPaid: amount,
        balance: newbalance,
        receipt: salesBody,
        createdAt: DateTime.now());
    Payment().createPayHistory(payHistory);

    //deduct from wallet debt
    Customer().updateCustomerWalletbalance(salesBody.customerId!,
        amount: (salesBody.customerId!.walletBalance ?? 0) + amount);

    getSalesBySaleId(id: salesBody.id);
    currentReceipt.refresh();
  }

  void getSalesByDate({DateTime? fromDate, DateTime? toDate}) {
    todaySales.clear();
    RealmResults<SalesModel> response =
        Sales().getSales(fromDate: fromDate, toDate: toDate);
    totalSalesByDate.value = response.fold(
        0, (previousValue, element) => previousValue + element.grandTotal!);
    todaySales.addAll(response.map((e) => e).toList());
  }

  void getReturns({CustomerModel? customerModel, SalesModel? salesModel}) {
    currentReceiptReturns.clear();
    RealmResults<ReceiptItem> response = Sales()
        .getSaleReceipts(salesModel: salesModel, customerModel: customerModel);
    List<ReceiptItem> salesReturn = response.map((e) => e).toList();
    for (var e in salesReturn) {
      if (currentReceiptReturns
              .indexWhere((element) => element.receipt!.id == e.receipt!.id) ==
          -1) {
        print(e.receipt!.id);
        currentReceiptReturns.add(e);
      }
    }
  }
}
