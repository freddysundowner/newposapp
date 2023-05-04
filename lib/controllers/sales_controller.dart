import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/customer_model.dart';
import 'package:flutterpos/models/payment_history.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/models/sales_model.dart';
import 'package:flutterpos/models/sales_order_item_model.dart';
import 'package:flutterpos/screens/cash_flow/wallet_page.dart';
import 'package:flutterpos/screens/home/home_page.dart';
import 'package:flutterpos/screens/sales/all_sales_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

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
  RxList<ProductModel> selectedList = RxList([]);
  RxList<SalesModel> sales = RxList([]);
  RxList<PayHistory> paymenHistory = RxList([]);
  Rxn<SalesSummary> profitModel = Rxn(null);

  RxInt grandTotal = RxInt(0);
  RxInt balance = RxInt(0);
  RxInt totalSalesByDate = RxInt(0);
  RxInt salesInitialIndex = RxInt(0);
  var selecteProduct = ProductModel().obs;
  RxBool saveSaleLoad = RxBool(false);
  RxBool getSalesByLoad = RxBool(false);
  RxBool getPaymentHistoryLoad = RxBool(false);

  RxBool salesOrderItemLoad = RxBool(false);
  RxBool salesOnCreditLoad = RxBool(false);
  RxBool salesByShopLoad = RxBool(false);
  RxString selectedPaymentMethod = RxString("Cash");
  Rxn<CustomerModel> selectedCustomer = Rxn(null);

  RxList<SaleOrderItemModel> salesHistory = RxList([]);

  var dueDate = new DateFormat('MMMM/dd/yyyy hh:mm a')
      .parse(new DateFormat('MMMM/dd/yyyy hh:mm a').format(DateTime.now()))
      .toIso8601String()
      .obs;

  RxString activeItem = RxString("All Sales");

  changeSelectedList(value) {
    var index = selectedList.indexWhere((element) => element.id == value.id);
    if (index == -1) {
      selectedList.add(value);
      index = selectedList.indexWhere((element) => element.id == value.id);
    } else {
      if (selectedList[index].cartquantity! >=
          selectedList[index].cartquantity! + 1) {
        var data =
            int.parse(selectedList[index].cartquantity.toString()) + 1; // +=1;
        selectedList[index].cartquantity = data;
      }
    }
    calculateAmount(index);

    selectedList.refresh();
    selectedList.reversed;
  }

  decrementItem(index) {
    if (selectedList[index].cartquantity! > 1) {
      selectedList[index].cartquantity = selectedList[index].cartquantity! - 1;
      selectedList.refresh();
    }
    calculateAmount(index);
  }

  incrementItem(index) {
    if (selectedList[index].quantity! > selectedList[index].cartquantity!) {
      selectedList[index].cartquantity = selectedList[index].cartquantity! + 1;
      selectedList.refresh();
    }
    calculateAmount(index);
  }

  removeFromList(index) {
    selectedList.removeAt(index);
    selectedList.refresh();
    calculateAmount(index);
  }

  calculateAmount(index) {
    grandTotal.value = 0;
    if (selectedList.isNotEmpty) {
      selectedList[index].amount =
          (selectedList[index].cartquantity! * selectedList[index].selling!) -
              selectedList[index].allowedDiscount!;
    }
    if (selectedList.isNotEmpty) {
      selectedList.forEach((element) {
        grandTotal.value =
            grandTotal.value + int.parse(element.amount.toString());
      });
    }

    grandTotal.refresh();
    selectedList.refresh();
  }

  saveSale(
      {required attendantsUID,
      required shopUID,
      required context,
      required screen}) {
    String size = MediaQuery.of(context).size.width > 600 ? "large" : "small";
    if (selectedPaymentMethod.value == "Credit") {
      if (selectedCustomer.value == null) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("please select customer to sell to")));
      } else {
        showSaleDatePicker(
            context: context,
            shopId: shopUID,
            size: size,
            attendantsId: attendantsUID,
            screen: screen);
      }
    } else if (selectedPaymentMethod.value == "Wallet" &&
        selectedCustomer.value == null) {
      showSnackBar(
          message: "please select customer to sell to",
          color: Colors.redAccent,
          context: context);
    } else if (selectedPaymentMethod.value == "Wallet" &&
        selectedCustomer.value != null &&
        selectedCustomer.value!.walletBalance! < grandTotal.value) {
      showDialog(
          context: context,
          builder: (_) {
            return AlertDialog(
              title: Text("Deposit For customer"),
              content:
                  Text("Wallet  balance insufficient!! deposit for customer"),
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
      saveSaleData(
          attendantId: attendantsUID,
          shopId: shopUID,
          type: "noncredit",
          size: size,
          context: context,
          screen: screen);
    }
  }

  saveSaleData(
      {required attendantId,
      required shopId,
      required type,
      required context,
      required size,
      required screen}) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: context, title: "Creating Sale", key: _keyLoader);

      var totaldiscount = 0;
      selectedList.forEach((element) {
        totaldiscount += int.parse(element.allowedDiscount.toString());
      });
      var sale = {
        "quantity": selectedList.length,
        "total": grandTotal.value,
        "attendantId": attendantId,
        "paymentMethod": selectedPaymentMethod.value,
        "totaldiscount": totaldiscount,
        "shop": shopId,
        "creditTotal": balance.value,
        if (selectedCustomer.value != null)
          "customerId": selectedCustomer.value!.id,
        "duedate": type == "noncredit" ? "" : dueDate.value
      };
      var products = selectedList.map((element) => element).toList();
      var response = await Sales().createSales({
        "sale": sale,
        "products": products,
        "date": DateFormat("yyyy-MM-dd").format(DateTime.now()),
      });

      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        selectedList.value = [];
        grandTotal.value = 0;
        balance.value = 0;
        textEditingCredit.text = "0";
        selectedPaymentMethod.value == "Cash";
        getSalesByShop(
            id: Get.find<ShopController>().currentShop.value?.id,
            attendantId: Get.find<AuthController>().usertype == "admin"
                ? ""
                : Get.find<AttendantController>().attendant.value!.id,
            onCredit: "",
            startingDate: "${DateFormat("yyyy-MM-dd").format(DateTime.now())}");

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
        showSnackBar(
            message: response["message"], color: Colors.red, context: context);
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
                                shopId: shopId,
                                size: size,
                                context: context,
                                screen: screen);
                          },
                          child: Text(
                            "Ok".toUpperCase(),
                            style: TextStyle(
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
            title: Text(
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
      salesHistory.clear();
      var response = await Sales().getSalesBySaleId(
          uid == null ? "" : uid, productId == null ? "" : productId);
      if (response != null) {
        List fetchedProducts = response["body"];
        List<SaleOrderItemModel> singleProduct =
            fetchedProducts.map((e) => SaleOrderItemModel.fromJson(e)).toList();
        salesHistory.assignAll(singleProduct);
      } else {
        salesHistory.value = [];
      }
      salesOrderItemLoad.value = false;
    } catch (e) {
      salesOrderItemLoad.value = false;
    }
  }

  getSalesByShop(
      {required id,
      String? attendantId,
      required onCredit,
      String? startingDate,
      String? customer}) async {
    try {
      salesByShopLoad.value = true;
      var response = await Sales().getShopSales(
          shopId: id,
          attendantId: attendantId,
          onCredit: onCredit,
          date: startingDate,
          customer: customer ?? "");
      if (response["status"] == true) {
        List data = response["body"];

        List<SalesModel> saleData =
            data.map((e) => SalesModel.fromJson(e)).toList();
        sales.assignAll(saleData);
        if (startingDate != null) {
          totalSalesByDate.value = 0;
          for (var i = 0; i < saleData.length; i++) {
            totalSalesByDate += int.parse("${saleData[i].grandTotal}");
          }
        }
      } else {
        sales.value = [];
      }
      salesByShopLoad.value = false;
    } catch (e) {
      sales.clear();
      salesByShopLoad.value = false;
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

  void returnSale(id, salesId, context) async {
    try {
      salesOrderItemLoad.value = true;
      var response = await Sales().retunSale(id);
      if (response["status"] != false) {
        getSalesBySaleId(uid: salesId);
      } else {
        showSnackBar(
            message: response["message"], color: Colors.red, context: context);
      }
      salesOrderItemLoad.value = false;
    } catch (e) {
      salesOrderItemLoad.value = false;
    }
  }

  totalSales() {
    var subTotal = 0;
    sales.forEach((element) {
      subTotal = subTotal + element.grandTotal!;
    });
    return subTotal;
  }

  calculateSalesAmount() {
    var subTotal = 0;
    selectedList.forEach((element) {
      subTotal = subTotal +
          (int.parse(element.sellingPrice![0]) * element.cartquantity!);
    });
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
        var index = sales.indexWhere((element) => element.id == salesBody.id);
        sales[index].creditTotal =
            sales[index].creditTotal! - int.parse(amount);
        sales.refresh();
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
}
