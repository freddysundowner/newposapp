import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pointify/controllers/expense_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/wallet_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
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
import 'cashflow_controller.dart';

class SalesData {
  SalesData(this.year, this.sales);

  final String year;
  final double sales;
}

class ChartData {
  ChartData(this.x, this.y);

  final String x;
  final double y;
}

class HomeCard {
  final double? total;
  final String? name;
  final String? key;
  final Color? color;
  final IconData? iconData;

  HomeCard({this.total, this.name, this.key, this.color, this.iconData});
}

class SalesController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  TextEditingController textEditingSellingPrice = TextEditingController();
  TextEditingController textEditingReturnProduct = TextEditingController();
  TextEditingController textEditingCredit = TextEditingController();
  TextEditingController amountPaid = TextEditingController();
  TextEditingController amountController = TextEditingController();
  RxList<SalesModel> allSales = RxList([]);
  RxList<ReceiptItem> allSalesReturns = RxList([]);
  RxnInt allSalesTotal = RxnInt(0);
  RxnInt change = RxnInt(0);
  RxString changeText = RxString("Change: ");
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
  Rxn<SalesSummary> salesSummary = Rxn(null);
  RxInt grossProfit = RxInt(0);
  RxInt currentYear = RxInt(DateTime.now().year);
  var filterStartDate =
      DateTime.parse(DateFormat("yyy-MM-dd").format(DateTime.now())).obs;
  var filterEndDate = DateTime.parse(
          DateFormat("yyy-MM-dd").format(DateTime.now().add(Duration(days: 1))))
      .obs;
  TextEditingController searchProductController = TextEditingController();

  RxInt totalSalesByDate = RxInt(0);
  RxInt salesInitialIndex = RxInt(0);
  RxInt tableInitialIndex = RxInt(0);
  Rxn<Product> selecteProduct = Rxn(null);
  RxBool saveSaleLoad = RxBool(false);
  RxBool getSalesByLoad = RxBool(false);
  RxBool getPaymentHistoryLoad = RxBool(false);

  RxBool salesOrderItemLoad = RxBool(false);
  RxBool salesOnCreditLoad = RxBool(false);
  RxBool loadingSales = RxBool(false);
  RxList paymentMethods = RxList(["Cash", "Credit", "Wallet"]);
  RxList receiptpaymentMethods = RxList(["Cash", "Wallet"]);
  Rxn<SalesModel> receipt = Rxn(null);
  RxList<SalesData> salesdata = RxList([]);
  RxList<ChartData> dailySales = RxList([]);
  RxList<SalesData> expensesdata = RxList([]);
  RxList<ChartData> productsDatadata = RxList([]);
  RxList<ChartData> productSalesAnalysis = RxList([]);
  RxList<ChartData> productSalesByAttendantsAnalysis = RxList([]);
  RxList<SalesData> profitdata = RxList([]);
  RxList<HomeCard> homecards = RxList([]);

  RxList<InvoiceItem> salesHistory = RxList([]);

  RxString paynowMethod = RxString("Cash");
  RxString activeItem = RxString("All Sales");
  RxString filterTitle = RxString("Filter by ~");
  RxInt selectedMonth = RxInt(1);

  getDailySalesGraph({
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    dailySales.clear();
    if (fromDate == null) {
      int y = DateTime.now().year;
      DateTime now = DateTime(y, 1);
      fromDate = DateTime(now.year, now.month, 1);
      DateTime now2 = DateTime(y, 12);
      toDate = DateTime(now2.year, now2.month + 1, 0);
    }
    Shop shop = Get.find<ShopController>().currentShop.value!;
    RealmResults<ReceiptItem> sales =
        Sales().getSaleReceipts(shop: shop, fromDate: fromDate, toDate: toDate);
    for (var element in sales) {
      var day = DateFormat("MMM-dd")
          .format(DateTime.fromMillisecondsSinceEpoch(element.soldOn!));
      int i = dailySales.indexWhere((element) => element.x == day);
      if (i == -1) {
        dailySales.add(ChartData(day,
            double.parse((element.quantity! * element.price!).toString())));
      } else {
        dailySales[i] = ChartData(
            day,
            dailySales[i].y +
                double.parse((element.quantity! * element.price!).toString()));
      }
    }
  }

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
    }

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
        netProfit.value =
            SalesData(month, profitdata[ei].sales - expensesdata[i].sales)
                .sales
                .toInt();
      }
    }
  }

  getProductComparison({DateTime? fromDate, DateTime? toDate}) {
    productsDatadata.clear();
    productSalesAnalysis.clear();
    productSalesByAttendantsAnalysis.clear();
    if (fromDate == null) {
      int y = DateTime.now().year;
      DateTime now = DateTime(y, 1);
      fromDate = DateTime(now.year, now.month, 1);
      DateTime now2 = DateTime(y, 12);
      toDate = DateTime(now2.year, now2.month + 1, 0);
    }
    Shop shop = Get.find<ShopController>().currentShop.value!;
    RealmResults<ReceiptItem> sales =
        Sales().getSaleReceipts(shop: shop, fromDate: fromDate, toDate: toDate);
    for (var e in sales) {
      int i = productsDatadata
          .indexWhere((element) => element.x == e.product!.name);

      if (i == -1) {
        productsDatadata
            .add(ChartData(e.product!.name!, e.quantity!.toDouble()));
        productSalesAnalysis
            .add(ChartData(e.product!.name!, e.quantity!.toDouble()));
      } else {
        productsDatadata[i] = ChartData(
            e.product!.name!, (productsDatadata[i].y + e.quantity!).toDouble());
        productSalesAnalysis[i] = ChartData(e.product!.name!,
            (productSalesAnalysis[i].y + e.quantity!).toDouble());
      }

      int ai = productSalesByAttendantsAnalysis
          .indexWhere((element) => element.x == e.attendantId?.username);
      if (ai == -1) {
        productSalesByAttendantsAnalysis.add(ChartData(e.attendantId!.username!,
            (e.quantity!.toDouble() * e.price!.toDouble())));
      } else {
        productSalesByAttendantsAnalysis[ai] = ChartData(
            e.attendantId!.username!,
            (productSalesByAttendantsAnalysis[ai].y +
                (e.quantity!.toDouble() * e.price!.toDouble())));
      }
    }
    productsDatadata.refresh();
    productSalesByAttendantsAnalysis.refresh();
    productSalesAnalysis.refresh();
    filterTitle.refresh();
  }

  getFinanceSummary({
    String? date = "",
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    RealmResults<ReceiptItem> sales =
        Sales().getSaleReceipts(date: date, fromDate: fromDate, toDate: toDate);
    grossProfit.value = sales.fold(
        0,
        (previousValue, element) =>
            previousValue +
            ((element.price! * element.quantity!) -
                (element.quantity! * element.product!.buyingPrice!)));

    Get.find<CashflowController>().getCashFlowTransactions(
        fromDate: fromDate, toDate: toDate, type: "cash-out");
  }

  changeSaleItem(ReceiptItem value) {
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
      receipt.value!.items[index].receiptId = receipt.value?.id;
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

  getTotalCredit() {
    var amountPaidTotal =
        int.parse(amountPaid.value.text.isEmpty ? "0" : amountPaid.value.text);
    if (amountPaidTotal > 0) {
      receipt.value!.creditTotal = receipt.value!.grandTotal! - amountPaidTotal;
    } else {
      receipt.value!.creditTotal = receipt.value!.grandTotal;
    }
    change.value = amountPaidTotal - receipt.value!.grandTotal!;
    if (receipt.value!.grandTotal! < amountPaidTotal) {
      changeText.value = "Change: ";
      receipt.value!.creditTotal = 0;
    } else {
      changeText.value = "Credit Total: ";
    }
  }

  calculateAmount(index) {
    receipt.value!.grandTotal = 0;
    receipt.value!.creditTotal = 0;

    receipt.value!.grandTotal = receipt.value!.items.fold(
        0,
        (previousValue, element) =>
            previousValue! +
            ((element.product!.selling! - element.discount!) *
                element.quantity!));

    getTotalCredit();
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
    if (receipt.value?.paymentMethod == "Cash" &&
        receipt.value!.grandTotal! >
            int.parse(amountPaid.text.isEmpty ? "0" : amountPaid.text)) {
      generalAlert(title: "Error!", message: "pay full amount");
      return;
    }
    if (_paymentType(receipt.value!) == "Credit") {
      if (receipt.value?.customerId == null) {
        generalAlert(
            title: "Error!", message: "please select customer to sell to");
        return;
      }
      if (receipt.value?.dueDate == null) {
        showSaleDatePicker(
            context: Get.context!,
            shopId: Get.find<ShopController>().currentShop.value?.id,
            attendantsId: Get.find<UserController>().user.value?.id,
            screen: screen);
      } else {
        Get.back();
        saveReceipt();
      }
      // if ((receipt.value!.customerId!.walletBalance == null ||
      //     receipt.value!.customerId!.walletBalance! <
      //         receipt.value!.grandTotal!)) {
      //   showDialog(
      //       context: Get.context!,
      //       builder: (_) {
      //         return AlertDialog(
      //           content: const Text(
      //               "Customer Credit balance is insufficient!! credit the account?"),
      //           actions: [
      //             TextButton(
      //                 onPressed: () {
      //                   Get.back();
      //                 },
      //                 child: Text(
      //                   "Cancel".capitalize!,
      //                   style: TextStyle(color: AppColors.mainColor),
      //                 )),
      //             TextButton(
      //                 onPressed: () {
      //                   Get.back();
      //
      //                   if (!isSmallScreen(Get.context)) {
      //                     Get.back();
      //                     Get.find<HomeController>().selectedWidget.value =
      //                         WalletPage(
      //                       customerModel: receipt.value!.customerId!,
      //                       page: "makesale",
      //                     );
      //                   } else {
      //                     Get.to(() => WalletPage(
      //                           customerModel: receipt.value!.customerId!,
      //                           page: "makesale",
      //                         ));
      //                   }
      //                 },
      //                 child: Text(
      //                   "Credit".capitalize!,
      //                   style: TextStyle(color: AppColors.mainColor),
      //                 )),
      //             TextButton(
      //                 onPressed: () {
      //                   if (receipt.value?.dueDate == null) {
      //                     showSaleDatePicker(
      //                         context: Get.context!,
      //                         shopId: Get.find<ShopController>()
      //                             .currentShop
      //                             .value
      //                             ?.id,
      //                         attendantsId:
      //                             Get.find<UserController>().user.value?.id,
      //                         screen: screen);
      //                   } else {
      //                     Get.back();
      //                     saveReceipt();
      //                   }
      //                 },
      //                 child: Text(
      //                   "Continue anyway",
      //                   style: TextStyle(color: AppColors.mainColor),
      //                 ))
      //           ],
      //         );
      //       });
      //   return;
      // }
      // else {
      //   Get.back();
      //   Get.back();
      //   saveReceipt(page: screen);
      // }
      return;
    }
    if (_paymentType(receipt.value!) == "Wallet" &&
        (receipt.value!.customerId!.walletBalance == null ||
            receipt.value!.customerId!.walletBalance! <
                receipt.value!.grandTotal!)) {
      showDialog(
          context: Get.context!,
          builder: (_) {
            return AlertDialog(
              content: const Text(
                  "Customer Wallet balance is insufficient!! credit the account?"),
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

                      if (!isSmallScreen(Get.context)) {
                        Get.back();
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
              ],
            );
          });

      return;
    }

    Get.back();
    saveReceipt();
  }

  _onCredit(SalesModel salesModel) => _paymentType(salesModel) == "Credit";

  _onWallet(SalesModel salesModel) => _paymentType(salesModel) == "Wallet";

  void saveReceipt({String? page}) {
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
    if (_onWallet(receiptData)) {
      if (receiptData.customerId == null) {
        generalAlert(title: "Error", message: "Select Customer");
        return;
      }
      var walletbalanace = (receiptData.customerId?.walletBalance ?? 0);
      if (receiptData.creditTotal == 0) {
        receiptData.creditTotal = receiptData.grandTotal;
      }
      var amountPaid = 0;
      if (receiptData.creditTotal!.abs() > walletbalanace) {
        if (walletbalanace < 0) {
          amountPaid = receiptData.creditTotal!.abs();
        } else {
          receiptData.creditTotal =
              (walletbalanace - receiptData.creditTotal!.abs()).abs();
          amountPaid = (walletbalanace - receiptData.creditTotal!.abs());
        }
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
      var amt = int.parse(amountPaid.text.isEmpty ? "0" : amountPaid.text);
      var amountPaidd =
          receiptData.creditTotal! > 0 ? amt : receiptData.creditTotal;
      if (amountPaidd! > 0) {
        PayHistory paymentHistory = PayHistory(ObjectId(),
            attendant: Get.find<UserController>().user.value,
            amountPaid: amountPaidd,
            balance: receiptData.creditTotal,
            shop: receiptData.shop,
            receipt: receipt.value);
        Payment().createPayHistory(paymentHistory);
      }
      if (receipt.value!.customerId != null) {
        Customer().updateCustomer(receipt.value!.customerId!, onCredit: true);
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
    if (isSmallScreen(Get.context!)) {
      Get.to(() => SalesReceipt(
            salesModel: receiptData,
            type: "",
          ));
    } else {
      Get.find<HomeController>().selectedWidget.value = SalesReceipt(
        salesModel: receiptData,
        type: "invoicepage",
      );
    }

    receipt.value = null;
    amountPaid.text = "";
    refresh();
    getSalesByDate(type: "today");
  }

  _paymentType(SalesModel salesModel) {
    if (salesModel.creditTotal! > 0) {
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
      required screen}) {
    showModalBottomSheet(
        context: context,
        backgroundColor:
            isSmallScreen(context) ? Colors.white : Colors.transparent,
        builder: (context) => Container(
              color: Colors.white,
              margin: EdgeInsets.only(
                  left: isSmallScreen(context)
                      ? 0
                      : MediaQuery.of(context).size.width * 0.2),
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

  getSalesByProductId(
      {Product? product, DateTime? fromDate, DateTime? toDate}) async {
    productSales.clear();

    if (fromDate == null) {
      fromDate = DateTime.parse(DateFormat("yyy-MM-dd").format(DateTime.now()));
      toDate = DateTime.parse(DateFormat("yyy-MM-dd")
          .format(DateTime.now().add(const Duration(days: 1))));
    }
    RealmResults<ReceiptItem>? receipt = Sales()
        .getSaleReceipts(product: product, fromDate: fromDate, toDate: toDate);
    productSales.addAll(receipt.map((e) => e).toList());
  }

  getSales(
      {onCredit = false,
      DateTime? fromDate,
      DateTime? toDate,
      CustomerModel? customer,
      String total = "",
      String receipt = ""}) async {
    if (fromDate == null) {
      fromDate = filterStartDate.value;
      toDate = filterEndDate.value;
    }
    RealmResults<SalesModel> sales = Sales().getSales(
        fromDate: fromDate,
        receipt: receipt,
        toDate: toDate,
        onCredit: onCredit,
        customer: customer);
    allSales.clear();
    if (receipt.isNotEmpty) {
      allSales.addAll(sales
          .where((e) =>
              e.items.fold(
                      0,
                      (previousValue, element) =>
                          previousValue + element.quantity!) >
                  0 &&
              e.receiptNumber
                  .toString()
                  .toLowerCase()
                  .contains(receipt.toString().toLowerCase()))
          .toList());
    } else {
      allSales.addAll(sales
          .where((e) =>
              e.items.fold(
                  0,
                  (previousValue, element) =>
                      previousValue + element.quantity!) >
              0)
          .toList());
    }
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

    Get.find<CashflowController>().getCashFlowTransactions(
        fromDate: fromDate, toDate: toDate, type: "cash-in");
  }

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    super.onInit();
  }

  void returnSale(ReceiptItem receiptItem, int quatity,
      {Product? product}) async {
    var amount = quatity * receiptItem.price!; // amount to be returned
    ReceiptItem returnedReceipt = ReceiptItem(ObjectId(),
        quantity: quatity,
        product: receiptItem.product,
        total: amount,
        discount: receiptItem.discount,
        price: receiptItem.price,
        type: "return",
        soldOn: receiptItem.soldOn,
        receipt: currentReceipt.value,
        shop: receiptItem.shop,
        customerId: currentReceipt.value?.customerId);
    Sales().createSaleReceiptItem(returnedReceipt);
    //refund to the wallet if its was a wallet sale
    //if it was credit sale return the paid amount to the wallet
    if (_onWallet(currentReceipt.value!)) {
      //what was already paid
      var totalPaid = (amount - currentReceipt.value!.creditTotal!.abs());
      var totalRemoveFromWallet =
          totalPaid + currentReceipt.value!.creditTotal!.abs();

      Get.find<WalletController>().WalletTransaction(
          customerModel: currentReceipt.value!.customerId!,
          newbalance: totalRemoveFromWallet,
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
        creditBalance: currentReceipt.value!.paymentMethod == "Credit"
            ? (currentReceipt.value!.creditTotal! > 0
                ? currentReceipt.value!.creditTotal! - amount
                : 0)
            : currentReceipt.value!.creditTotal,
        returnedItems: returnedReceipt);
    getSalesBySaleId(id: currentReceipt.value!.id);
    if (product != null) {
      getSalesByProductId(
          fromDate: filterStartDate.value,
          toDate: filterEndDate.value,
          product: product);
      Get.back();
      productSales.refresh();
    }
    getSalesByDate(type: "today");
    currentReceipt.refresh();
  }

  deleteReceiptItem(ReceiptItem receiptItem, {Product? product}) {
    var amount =
        receiptItem.quantity! * receiptItem.price!; // amount to be returned
    if (_onWallet(currentReceipt.value!)) {
      //what was already paid
      var totalPaid = (amount - currentReceipt.value!.creditTotal!.abs());
      var totalRemoveFromWallet =
          totalPaid + currentReceipt.value!.creditTotal!.abs();

      Get.find<WalletController>().WalletTransaction(
          customerModel: currentReceipt.value!.customerId!,
          newbalance: totalRemoveFromWallet,
          amount: amount,
          type: "deposit",
          salesModel: currentReceipt.value!);
    }

    //increate product quantity
    Products().updateProductPart(
        product: receiptItem.product!,
        quantity: receiptItem.product!.quantity! + receiptItem.quantity!);
    // update receipt qty returned and re-calculate the total
    if (currentReceipt.value!.items.length == 1) {
      Sales().deleteReceipt(currentReceipt.value!);
    } else {
      Sales().updateReceipt(
          receipt: currentReceipt.value!,
          total: currentReceipt.value!.grandTotal! - amount,
          creditBalance: currentReceipt.value!.paymentMethod == "Credit"
              ? (currentReceipt.value!.creditTotal!.abs() - amount) * -1
              : currentReceipt.value!.creditTotal);
    }
    Sales().deleteReceiptItem(receiptItem);
    if (product != null) {
      getSalesByProductId(
          fromDate: filterStartDate.value,
          toDate: filterEndDate.value,
          product: product);
      productSales.refresh();
    }

    //check if customer has other receipts not paid
    if (onCredit(currentReceipt.value!)) {
      RealmResults<SalesModel> sales = Sales()
          .getSales(customer: currentReceipt.value!.customerId, onCredit: true);
      Customer().updateCustomer(currentReceipt.value!.customerId!,
          onCredit: sales.isEmpty);
    }
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
    var walletBalance = (salesBody.customerId!.walletBalance ?? 0);

    Sales().updateReceipt(receipt: salesBody, creditBalance: newbalance);
    PayHistory payHistory = PayHistory(ObjectId(),
        attendant: Get.find<UserController>().user.value,
        amountPaid: amount,
        balance: newbalance,
        receipt: salesBody,
        shop: salesBody.shop,
        createdAt: DateTime.now());
    Payment().createPayHistory(payHistory);

    //deduct from wallet debt
    if (paynowMethod.value == "Wallet" || walletBalance < 0) {
      print(walletBalance.abs() - amount);
      Get.find<WalletController>().WalletTransaction(
          customerModel: salesBody.customerId!,
          amount: amount.abs(),
          type: "usage",
          salesModel: salesBody);
    }

    getSalesBySaleId(id: salesBody.id);
    currentReceipt.refresh();
    amountController.clear();
  }

  _generateHomeCard(
      {required String type,
      required double total,
      required String name,
      required IconData icon,
      required Color color}) {
    int i = homecards.indexWhere((element) => element.key == type);
    if (i != -1) homecards.removeAt(i);
    homecards.add(HomeCard(
        total: total, name: name, key: type, color: color, iconData: icon));
  }

  void getSalesByDate(
      {DateTime? fromDate, DateTime? toDate, String? type, Shop? shop}) {
    todaySales.clear();
    allSales.clear();
    if (type == "today") {
      fromDate = DateTime.parse(DateFormat("yyy-MM-dd").format(DateTime.now()));
      toDate = DateTime.parse(DateFormat("yyy-MM-dd")
          .format(DateTime.now().add(const Duration(hours: 24))));
    }
    RealmResults<SalesModel> response =
        Sales().getSales(fromDate: fromDate, toDate: toDate, shop: shop);

    if (type == "today") {
      _generateHomeCard(
          type: type!,
          total: response.fold(0,
              (previousValue, element) => previousValue + element.grandTotal!),
          name: "Today Sales",
          color: Color(0xffbe741f),
          icon: Icons.auto_graph_rounded); //0xff34a8e0 //ffbe741f

      Get.find<CashflowController>().getCashFlowTransactions(
          fromDate: fromDate, toDate: toDate, type: "cash-in");
      if (checkPermission(category: "accounts", permission: "analysis")) {
        _generateHomeCard(
            type: "profit",
            total: response.fold(
                    0,
                    (previousValue, element) =>
                        previousValue +
                        ((element.items.fold(
                            0,
                            (previousValue, element) =>
                                previousValue +
                                (element.price! * element.quantity! -
                                    element.product!.buyingPrice! *
                                        element.quantity!))))) -
                Get.find<ExpenseController>().totalExpenses.value.toDouble(),
            name: "Today Profit",
            color: const Color(0xff08a52c).withOpacity(0.7),
            icon: Icons.stacked_line_chart); //0x
      } else {
        int i = homecards.indexWhere((element) => element.key == "profit");
        if (i != -1) homecards.removeAt(i);
      }
      if (checkPermission(category: "accounts", permission: "expenses")) {
        _generateHomeCard(
            type: "expenses",
            total: Get.find<ExpenseController>().totalExpenses.value.toDouble(),
            name: "Today Expenses",
            color: const Color(0xff3a3055),
            icon: Icons.bar_chart);
      } else {
        int i = homecards.indexWhere((element) => element.key == "expenses");
        if (i != -1) homecards.removeAt(i);
      }
    }
    totalSalesByDate.value = response.fold(
        0, (previousValue, element) => previousValue + element.grandTotal!);
    todaySales.addAll(response.map((e) => e).toList());
    allSales.addAll(response.map((e) => e).toList());

    print("allSales ${allSales.length}");
    allSales.refresh();
    todaySales.refresh();
  }

  void getReturns(
      {CustomerModel? customerModel,
      SalesModel? salesModel,
      Product? product,
      DateTime? fromDate,
      String? type,
      DateTime? toDate}) {
    currentReceiptReturns.clear();
    allSalesReturns.clear();
    RealmResults<ReceiptItem> response = Sales().getSaleReceipts(
        salesModel: salesModel,
        customerModel: customerModel,
        product: product,
        type: type,
        fromDate: fromDate,
        toDate: toDate);
    List<ReceiptItem> salesReturn = response.map((e) => e).toList();
    allSalesReturns.value = salesReturn;

    for (var e in salesReturn) {
      if (currentReceiptReturns.indexWhere((element) =>
              element.receipt != null &&
              element.receipt!.id == e.receipt!.id) ==
          -1) {
        currentReceiptReturns.add(e);
      }
      print("length is ${currentReceiptReturns.length}");
    }
  }
}
