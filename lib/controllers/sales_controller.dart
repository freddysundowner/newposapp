import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/models/customer_model.dart';
import 'package:pointify/models/payment_history.dart';
import 'package:pointify/models/product_model.dart';
import 'package:pointify/models/receipt.dart';
import 'package:pointify/screens/cash_flow/wallet_page.dart';
import 'package:pointify/screens/home/home_page.dart';
import 'package:pointify/screens/sales/all_sales_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/invoice_items.dart';
import '../models/receipt_item.dart';
import '../models/sales_summary.dart';
import '../services/sales.dart';
import '../services/transactions.dart';
import '../utils/colors.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/snackBars.dart';
import 'CustomerController.dart';
import 'attendant_controller.dart';

class SalesController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  TextEditingController textEditingSellingPrice = TextEditingController();
  TextEditingController textEditingReturnProduct = TextEditingController();
  TextEditingController textEditingCredit = TextEditingController();
  RxList<SalesModel> allSales = RxList([]);
  RxnInt allSalesTotal = RxnInt(0);
  RxnInt totalSalesReturned = RxnInt(0);
  RxList<SalesModel> salesReturned = RxList([]);
  RxList<SalesModel> todaySales = RxList([]);
  RxList<SalesModel> creditSales = RxList([]);
  RxList<PayHistory> paymenHistory = RxList([]);
  Rxn<SalesSummary> profitModel = Rxn(null);

  RxInt grandTotal = RxInt(0);
  RxInt changeTotal = RxInt(0);
  RxInt balance = RxInt(0);
  RxInt totalSalesByDate = RxInt(0);
  RxInt salesInitialIndex = RxInt(0);
  var selecteProduct = ProductModel().obs;
  RxBool saveSaleLoad = RxBool(false);
  RxBool getSalesByLoad = RxBool(false);
  RxBool getPaymentHistoryLoad = RxBool(false);

  RxBool salesOrderItemLoad = RxBool(false);
  RxBool salesOnCreditLoad = RxBool(false);
  RxBool loadingSales = RxBool(false);
  RxString selectedPaymentMethod = RxString("Cash");
  RxList paymentMethods = RxList(["Cash", "Credit", "Wallet"]);
  Rxn<CustomerModel> selectedCustomer = Rxn(null);
  RxList<ReceiptItem> saleItem = RxList([]);

  RxList<InvoiceItem> salesHistory = RxList([]);

  var dueDate = new DateFormat('MMMM/dd/yyyy hh:mm a')
      .parse(new DateFormat('MMMM/dd/yyyy hh:mm a').format(DateTime.now()))
      .toIso8601String()
      .obs;

  RxString activeItem = RxString("All Sales");

  changesaleItem(ReceiptItem value) {
    var index = saleItem
        .indexWhere((element) => element.product!.id == value.product!.id);
    if (index == -1) {
      saleItem.add(value);
      index = saleItem
          .indexWhere((element) => element.product!.id == value.product!.id);
    } else {
      if (saleItem[index].quantity! >= saleItem[index].quantity! + 1) {
        var data = int.parse(saleItem[index].quantity.toString()) + 1;
        saleItem[index].quantity = data;
      }
    }
    calculateAmount(index);

    saleItem.refresh();
    saleItem.reversed;
  }

  decrementItem(index) {
    if (saleItem[index].quantity! > 1) {
      saleItem[index].quantity = saleItem[index].quantity! - 1;
      saleItem.refresh();
    }
    calculateAmount(index);
  }

  incrementItem(index) {
    saleItem[index].quantity = saleItem[index].quantity! + 1;
    calculateAmount(index);
  }

  removeFromList(index) {
    saleItem.removeAt(index);
    saleItem.refresh();
    calculateAmount(index);
  }

  calculateAmount(index) {
    grandTotal.value = 0;
    if (saleItem.isNotEmpty) {
      saleItem[index].price =
          saleItem[index].price! - saleItem[index].discount!;
      saleItem[index].total =
          saleItem[index].quantity! * saleItem[index].price!;
    }
    if (saleItem.isNotEmpty) {
      for (var element in saleItem) {
        grandTotal.value += element.total!;
      }
    }

    grandTotal.refresh();
    saleItem.refresh();
  }

  saveSale({screen, required attendantsUID, required context}) {
    String size = MediaQuery.of(context).size.width > 600 ? "large" : "small";
    if (selectedPaymentMethod.value == "Credit") {
      if (selectedCustomer.value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("please select customer to sell to")));
      } else {
        showSaleDatePicker(
            context: context,
            shopId: Get.find<ShopController>().currentShop.value?.id,
            size: size,
            attendantsId: attendantsUID,
            screen: screen);
      }
    } else if (selectedPaymentMethod.value == "Wallet" &&
        selectedCustomer.value == null) {
      showSnackBar(
          message: "please select customer to sell to",
          color: Colors.redAccent);
    } else if (selectedPaymentMethod.value == "Wallet" &&
        selectedCustomer.value != null &&
        selectedCustomer.value!.walletBalance! < grandTotal.value) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: const Text("Deposit For customer"),
              content: const Text(
                  "Wallet  balance insufficient!! deposit for customer"),
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
                      if (MediaQuery.of(context).size.width > 600) {
                        Get.find<HomeController>().selectedWidget.value =
                            WalletPage(
                          customerModel: selectedCustomer.value!,
                          page: "makesale",
                        );
                      } else {
                        Get.to(() => WalletPage(
                              customerModel: selectedCustomer.value!,
                              page: "makesale",
                            ));
                      }
                    },
                    child: Text(
                      "Okay".capitalize!,
                      style: TextStyle(color: AppColors.mainColor),
                    ))
              ],
            );
          });
    } else {
      Navigator.pop(context);
      saveSaleData(
          attendantId: attendantsUID,
          type: "noncredit",
          size: size,
          context: context,
          screen: screen);
    }
  }

  saveSaleData(
      {required attendantId,
      required type,
      required context,
      required size,
      required screen}) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: context, title: "Creating Sale", key: _keyLoader);
      var creditTotal = 0;
      if (selectedPaymentMethod.value == "Credit" ||
          selectedPaymentMethod.value == "Wallet") {
        creditTotal = changeTotal.value.abs();
      }
      var receipt = {
        "attendantId": attendantId,
        "paymentMethod": selectedPaymentMethod.value,
        "shop": Get.find<ShopController>().currentShop.value?.id,
        "creditTotal": creditTotal,
        "total": grandTotal.value,
        if (selectedCustomer.value != null)
          "customerId": selectedCustomer.value!.id,
        "duedate": type == "noncredit" ? "" : dueDate.value
      };
      print(receipt);
      var receiptitems =
          saleItem.map((element) => element.toJson(element)).toList();
      var sale = {
        "sale": receipt,
        "receiptitems": receiptitems,
      };
      print(sale);

      var response = await Sales().createSales(sale);
      print(response);

      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        saleItem.value = [];
        grandTotal.value = 0;
        balance.value = 0;
        textEditingCredit.text = "0";
        selectedPaymentMethod.value == "Cash";

        Get.find<AuthController>()
            .init(Get.find<AuthController>().usertype.value);
        if (size == "large") {
          if (screen == "allSales") {
            Get.find<HomeController>().selectedWidget.value =
                AllSalesPage(page: "AttendantLanding");
          } else {
            Get.find<HomeController>().selectedWidget.value = HomePage();
          }
        } else if (screen == "admin") {
          Get.back();
        } else {
          Get.back();
        }
      } else {
        showSnackBar(message: response["message"], color: Colors.red);
      }
    } catch (e) {}
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
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height:
                          MediaQuery.of(context).copyWith().size.height * 0.3,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.dateAndTime,
                        onDateTimeChanged: (value) {
                          dueDate.value = new DateFormat('MMMM/dd/yyyy hh:mm a')
                              .parse(new DateFormat('MMMM/dd/yyyy hh:mm a')
                                  .format(value))
                              .toIso8601String();
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
                            saveSaleData(
                                type: "credit",
                                attendantId: attendantsId,
                                size: size,
                                context: context,
                                screen: screen);
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

  showDepositAllertDialog(context) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: const Text(
              "Wallet Amount is insufficient",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Text("Would you like to deposit for customer?"),
            actions: [
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  "Cancel".toUpperCase(),
                  style: TextStyle(
                    color: AppColors.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  "Okay".toUpperCase(),
                  style: TextStyle(
                    color: AppColors.mainColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          );
        });
  }

  getSalesBySaleId({String? uid, String? productId}) async {
    try {
      salesOrderItemLoad.value = true;
      var response = await Sales().getSalesBySaleId(uid ?? "", productId ?? "");
      if (response != null) {
        List fetchedProducts = response["body"];
        List<InvoiceItem> singleProduct =
            fetchedProducts.map((e) => InvoiceItem.fromJson(e)).toList();
        salesHistory.assignAll(singleProduct);
      } else {
        salesHistory.value = [];
      }
      salesOrderItemLoad.value = false;
    } catch (e) {
      salesOrderItemLoad.value = false;
    }
  }

  getSales(
      {onCredit = false,
      String? startingDate = "",
      String? customer = "",
      String total = ""}) async {
    try {
      loadingSales.value = true;
      var response = await Sales().getSales(
          onCredit: onCredit,
          date: startingDate,
          customer: customer ?? "",
          total: total);
      if (response["status"] == true) {
        List data = response["body"];
        List<SalesModel> saleData =
            data.map((e) => SalesModel.fromJson(e)).toList();

        if (onCredit == true) {
          creditSales.value = saleData;
        }
        if (startingDate!.isNotEmpty) {
          todaySales.value = saleData;
        } else {
          if (total.isNotEmpty) {
            allSalesTotal.value = response["totalSales"];
            totalSalesReturned.value = response["totalSalesReturned"];
          }
          allSales.assignAll(saleData);
        }
      } else {
        allSales.value = [];
      }
      loadingSales.value = false;
    } catch (e) {
      allSales.clear();
      loadingSales.value = false;
    }
  }

  getProfitTransaction(
      {required start, required end, required type, required shopId}) async {
    try {
      var response = await Transactions().getProfitTransactions(
          shopId,
          DateFormat("yyyy-MM-dd").format(start),
          DateFormat("yyyy-MM-dd").format(end));
      profitModel.value = SalesSummary.fromJson(response);
    } catch (e) {
      print(e);
    }
  }

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    super.onInit();
  }

  void returnSale(InvoiceItem sale, int quatity) async {
    try {
      salesOrderItemLoad.value = true;
      var response = await Sales().retunSale(sale.id, quatity);
      if (response["status"] != false) {
        getSalesBySaleId(uid: sale.sale!.id);
      } else {
        showSnackBar(message: response["message"], color: Colors.red);
      }
      salesOrderItemLoad.value = false;
    } catch (e) {
      salesOrderItemLoad.value = false;
    }
  }

  totalSales() {
    var subTotal = 0;
    for (var element in allSales) {
      subTotal = subTotal + element.grandTotal!;
    }
    return subTotal;
  }

  payCredit({required SalesModel salesBody, required String amount}) async {
    try {
      Map<String, dynamic> body = {
        "customerId": salesBody.customerId!.id,
        "amount": int.parse(amount),
        "type": "sale"
      };
      var response =
          await Sales().createPayment(body: body, saleId: salesBody.id);
      if (response["status"] = true) {
        Get.find<CustomerController>().amountController.clear();
        salesBody.creditTotal! - int.parse(amount);
        salesHistory.refresh();
      }
    } catch (e) {
      print(e);
    }
  }

  getPaymentHistory({required String id, required type}) async {
    try {
      getPaymentHistoryLoad.value = true;
      var response = await Sales().getPaymentHistory(id: id, type: type);
      if (response != null) {
        List rawData = response;
        List<PayHistory> pay =
            rawData.map((e) => PayHistory.fromJson(e)).toList();
        paymenHistory.assignAll(pay);
      } else {
        paymenHistory.value = [];
      }
      getPaymentHistoryLoad.value = false;
    } catch (e) {
      getPaymentHistoryLoad.value = false;
      print(e);
    }
  }

  void getSalesByDate(shopId, startDate, endDate) async {
    var response = await Sales().getSalesByDate(shopId, startDate, endDate);
    totalSalesByDate.value = 0;
    if (response.length > 0) {
      totalSalesByDate.value = response[0]["totalSales"];
    }
    totalSalesByDate.refresh();
    return response;
  }
}
