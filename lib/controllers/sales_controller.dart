import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/models/profit_summary.dart';
import 'package:flutterpos/models/sales_model.dart';
import 'package:flutterpos/models/sales_order_item_model.dart';
import 'package:flutterpos/screens/home/home_page.dart';
import 'package:flutterpos/screens/sales/all_sales_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../services/sales.dart';
import '../services/transactions.dart';
import '../utils/colors.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/snackBars.dart';

class SalesController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  TextEditingController textEditingSellingPrice = TextEditingController();
  TextEditingController textEditingCredit = TextEditingController();
  RxList<ProductModel> selectedList = RxList([]);
  RxList<SalesModel> sales = RxList([]);
  Rxn<ProfitSummary> profitModel = Rxn(null);

  RxInt grandTotal = RxInt(0);
  RxInt balance = RxInt(0);
  RxInt totalSalesByDate = RxInt(0);
  RxInt salesInitialIndex = RxInt(0);
  var selecteProduct = ProductModel().obs;
  RxBool saveSaleLoad = RxBool(false);
  RxBool getSalesByDateLoad = RxBool(false);
  RxBool todaySalesLoad = RxBool(false);
  RxBool salesOrderItemLoad = RxBool(false);
  RxBool salesOnCreditLoad = RxBool(false);
  RxBool salesByShopLoad = RxBool(false);
  RxString selectedPaymentMethod = RxString("Cash");
  RxString selectedCustomer = RxString("");
  RxString selectedCustomerId = RxString("");
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
      var data =
          int.parse(selectedList[index].cartquantity.toString()) + 1; // +=1;
      selectedList[index].cartquantity = data;
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
      required customerId,
      required context,
      required screen}) {
    if (selectedPaymentMethod.value == "Credit") {
      if (customerId == "") {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("please select customer to sell to")));
      } else {
        showSaleDatePicker(
            context: context,
            customerIds: customerId,
            shopId: shopUID,
            attendantsId: attendantsUID,
            screen: screen);
      }
    } else if (selectedPaymentMethod.value == "Wallet" && customerId == "") {
      showSnackBar(
          message: "please select customer to sell to",
          color: Colors.redAccent,
          context: context);
    } else {
      saveSaleData(
          customerId: customerId,
          attendantId: attendantsUID,
          shopId: shopUID,
          type: "noncredit",
          context: context,
          screen: screen);
    }
  }

  saveSaleData(
      {required attendantId,
      required shopId,
      required customerId,
      required type,
      required context,
      required screen}) async {
    try {
      if (MediaQuery.of(context).size.width > 600) {
        LoadingDialog.showLoadingDialog(
            context: context, title: "Creating Sale", key: _keyLoader);
      }
      saveSaleLoad.value = true;
      var totaldiscount = 0;
      selectedList.forEach((element) {
        totaldiscount += int.parse(element.allowedDiscount.toString());
      });
      var sale = {
        "quantity": selectedList.length,
        "total": grandTotal.value,
        "attendantid": attendantId,
        "paymentMethod": selectedPaymentMethod.value,
        "totaldiscount": totaldiscount,
        "shop": shopId,
        "creditTotal": balance.value,
        "customerId": customerId,
        "duedate": type == "noncredit" ? "" : dueDate.value
      };
      var products = selectedList.map((element) => element).toList();
      var response = await Sales().createSales({
        "sale": sale,
        "products": products,
        "date":
            DateTime.parse(DateTime.now().toString()).millisecondsSinceEpoch,
      });
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        selectedList.value = [];
        grandTotal.value = 0;
        balance.value = 0;
        textEditingCredit.text = "0";
        selectedPaymentMethod.value == "Cash";
        await getSalesByDates(
            shopId: Get.find<ShopController>().currentShop.value?.id,
            startingDate: DateTime.now(),
            endingDate: DateTime.now(),
            type: "notcashflow");
        if (MediaQuery.of(context).size.width > 600) {
          if (screen == "allSales") {
            Get.find<HomeController>().selectedWidget.value =
                AllSalesPage(page: "AttendantLanding");
          } else {
            Get.find<HomeController>().selectedWidget.value = HomePage();
          }
        }
        if (screen == "admin") {
          Get.back();
        }
      } else if (response["status"] == false &&
          selectedPaymentMethod.value == "Wallet") {
        saveSaleLoad.value = false;
        showDepositAllertDialog(context);
      } else {
        showSnackBar(
            message: response["message"], color: Colors.red, context: context);
      }

      saveSaleLoad.value = false;
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      saveSaleLoad.value = false;
    }
  }

  showSaleDatePicker(
      {required context,
      required shopId,
      required attendantsId,
      required customerIds,
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
                                customerId: customerIds,
                                shopId: shopId,
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

  getSalesByDates(
      {required shopId,
      required startingDate,
      required endingDate,
      required type}) async {
    try {
      todaySalesLoad.value = true;

      totalSalesByDate.value = 0;
      var now = type != "cashflow" ? endingDate : DateTime.now();
      var tomm = now.add(new Duration(days: 1));
      var today = new DateFormat('yyyy-MM-dd')
          .parse(new DateFormat('yyyy-MM-dd')
              .format(type != "cashflow" ? startingDate : now))
          .toIso8601String();
      var tomorrow = new DateFormat('yyyy-MM-dd')
          .parse(new DateFormat('yyyy-MM-dd').format(tomm));
      var response = await Sales().getSalesByDate(
          shopId,
          "${type != "cashflow" ? today : startingDate}",
          "${type != "cashflow" ? tomorrow : endingDate}");

      if (response["status"] == true) {
        sales.value = RxList([]);
        List fetchedProducts = response["body"];

        List<SalesModel> listProducts =
            fetchedProducts.map((e) => SalesModel.fromJson(e)).toList();
        for (var i = 0; i < listProducts.length; i++) {
          totalSalesByDate += int.parse("${listProducts[i].grandTotal}");
        }
        sales.assignAll(listProducts);
      } else {
        sales.value = [];
      }

      todaySalesLoad.value = false;
    } catch (e) {
      todaySalesLoad.value = false;
    }
  }

  getSalesBySaleId(uid) async {
    try {
      salesOrderItemLoad.value = true;
      salesHistory.value = [];
      var response = await Sales().getSalesBySaleId(uid);
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

  getSalesByShop({required id}) async {
    try {
      salesByShopLoad.value = true;
      var response = await Sales().getShopSales(id);
      if (response["status"] == true) {
        List data = response["body"];
        List<SalesModel> saleData =
            data.map((e) => SalesModel.fromJson(e)).toList();
        sales.assignAll(saleData);
      } else {
        sales.value = [];
      }
      salesByShopLoad.value = false;
    } catch (e) {
      List sal = [
        {
          "_id": "6400455b8b658aafbf4e3817",
          "receiptNumber": "REY3IL182RZ",
          "shop": {
            "_id": "63fa08bc46721b7480474bee",
            "name": "kim",
            "location": "naivasha",
            "owner": "63f9efe3879e16801054a0b0",
            "type": "ele",
            "currency": "BDT",
            "createdAt": "2023-02-25T13:10:20.721Z",
            "updatedAt": "2023-02-27T10:53:24.721Z",
            "__v": 0
          },
          "attendantId": null,
          "customerId": {
            "_id": "63fdd3d88b658aafbf4e2350",
            "fullName": "trial",
            "phoneNumber": "09876543",
            "shopId": {
              "_id": "63fa08bc46721b7480474bee",
              "name": "kim",
              "location": "naivasha",
              "owner": "63f9efe3879e16801054a0b0",
              "type": "ele",
              "currency": "BDT",
              "createdAt": "2023-02-25T13:10:20.721Z",
              "updatedAt": "2023-02-27T10:53:24.721Z",
              "__v": 0
            },
            "walletBalance": 0,
            "credit": 1930,
            "onCredit": true,
            "gender": "",
            "email": "",
            "address": "",
            "createdAt": "2023-02-28T10:13:44.213Z",
            "updatedAt": "2023-03-02T06:42:35.410Z",
            "__v": 0
          },
          "grandTotal": 130,
          "creditTotal": 130,
          "totalDiscount": 0,
          "date": "1677739354239",
          "quantity": 1,
          "paymentMethod": "Credit",
          "dueDate": "2023-03-02T09:38:00.000",
          "createdAt": "2023-03-02T06:42:35.403Z",
          "updatedAt": "2023-03-02T06:42:35.403Z",
          "__v": 0
        },
        {
          "_id": "63fdff368b658aafbf4e2887",
          "receiptNumber": "REY5Q7CQE6N",
          "shop": {
            "_id": "63fa08bc46721b7480474bee",
            "name": "kim",
            "location": "naivasha",
            "owner": "63f9efe3879e16801054a0b0",
            "type": "ele",
            "currency": "BDT",
            "createdAt": "2023-02-25T13:10:20.721Z",
            "updatedAt": "2023-02-27T10:53:24.721Z",
            "__v": 0
          },
          "attendantId": null,
          "customerId": {
            "_id": "63fdd3d88b658aafbf4e2350",
            "fullName": "trial",
            "phoneNumber": "09876543",
            "shopId": {
              "_id": "63fa08bc46721b7480474bee",
              "name": "kim",
              "location": "naivasha",
              "owner": "63f9efe3879e16801054a0b0",
              "type": "ele",
              "currency": "BDT",
              "createdAt": "2023-02-25T13:10:20.721Z",
              "updatedAt": "2023-02-27T10:53:24.721Z",
              "__v": 0
            },
            "walletBalance": 0,
            "credit": 1930,
            "onCredit": true,
            "gender": "",
            "email": "",
            "address": "",
            "createdAt": "2023-02-28T10:13:44.213Z",
            "updatedAt": "2023-03-02T06:42:35.410Z",
            "__v": 0
          },
          "grandTotal": 780,
          "creditTotal": 0,
          "totalDiscount": 0,
          "date": "1677590323714",
          "quantity": 1,
          "paymentMethod": "Cash",
          "dueDate": "",
          "createdAt": "2023-02-28T13:18:46.030Z",
          "updatedAt": "2023-02-28T13:18:46.030Z",
          "__v": 0
        },
        {
          "_id": "63fdeba08b658aafbf4e2606",
          "receiptNumber": "REDYXSJWC4X",
          "shop": {
            "_id": "63fa08bc46721b7480474bee",
            "name": "kim",
            "location": "naivasha",
            "owner": "63f9efe3879e16801054a0b0",
            "type": "ele",
            "currency": "BDT",
            "createdAt": "2023-02-25T13:10:20.721Z",
            "updatedAt": "2023-02-27T10:53:24.721Z",
            "__v": 0
          },
          "attendantId": null,
          "customerId": {
            "_id": "63fdd3d88b658aafbf4e2350",
            "fullName": "trial",
            "phoneNumber": "09876543",
            "shopId": {
              "_id": "63fa08bc46721b7480474bee",
              "name": "kim",
              "location": "naivasha",
              "owner": "63f9efe3879e16801054a0b0",
              "type": "ele",
              "currency": "BDT",
              "createdAt": "2023-02-25T13:10:20.721Z",
              "updatedAt": "2023-02-27T10:53:24.721Z",
              "__v": 0
            },
            "walletBalance": 0,
            "credit": 1930,
            "onCredit": true,
            "gender": "",
            "email": "",
            "address": "",
            "createdAt": "2023-02-28T10:13:44.213Z",
            "updatedAt": "2023-03-02T06:42:35.410Z",
            "__v": 0
          },
          "grandTotal": 4800,
          "creditTotal": 1800,
          "totalDiscount": 0,
          "date": "1677585310359",
          "quantity": 1,
          "paymentMethod": "Credit",
          "dueDate": "2023-02-28T14:54:00.000",
          "createdAt": "2023-02-28T11:55:12.535Z",
          "updatedAt": "2023-02-28T11:55:12.535Z",
          "__v": 0
        },
        {
          "_id": "63fde5458b658aafbf4e25c2",
          "receiptNumber": "REDJLC7YGNH",
          "shop": {
            "_id": "63fa08bc46721b7480474bee",
            "name": "kim",
            "location": "naivasha",
            "owner": "63f9efe3879e16801054a0b0",
            "type": "ele",
            "currency": "BDT",
            "createdAt": "2023-02-25T13:10:20.721Z",
            "updatedAt": "2023-02-27T10:53:24.721Z",
            "__v": 0
          },
          "attendantId": null,
          "customerId": {
            "_id": "63fdd3d88b658aafbf4e2350",
            "fullName": "trial",
            "phoneNumber": "09876543",
            "shopId": {
              "_id": "63fa08bc46721b7480474bee",
              "name": "kim",
              "location": "naivasha",
              "owner": "63f9efe3879e16801054a0b0",
              "type": "ele",
              "currency": "BDT",
              "createdAt": "2023-02-25T13:10:20.721Z",
              "updatedAt": "2023-02-27T10:53:24.721Z",
              "__v": 0
            },
            "walletBalance": 0,
            "credit": 1930,
            "onCredit": true,
            "gender": "",
            "email": "",
            "address": "",
            "createdAt": "2023-02-28T10:13:44.213Z",
            "updatedAt": "2023-03-02T06:42:35.410Z",
            "__v": 0
          },
          "grandTotal": 6400,
          "creditTotal": 0,
          "totalDiscount": 0,
          "date": "1677583683152",
          "quantity": 1,
          "paymentMethod": "Cash",
          "dueDate": "",
          "createdAt": "2023-02-28T11:28:05.147Z",
          "updatedAt": "2023-02-28T11:28:05.147Z",
          "__v": 0
        },
        {
          "_id": "63fdd3dd8b658aafbf4e2354",
          "receiptNumber": "REPTZHXZQ7V",
          "shop": {
            "_id": "63fa08bc46721b7480474bee",
            "name": "kim",
            "location": "naivasha",
            "owner": "63f9efe3879e16801054a0b0",
            "type": "ele",
            "currency": "BDT",
            "createdAt": "2023-02-25T13:10:20.721Z",
            "updatedAt": "2023-02-27T10:53:24.721Z",
            "__v": 0
          },
          "attendantId": null,
          "customerId": {
            "_id": "63fdd3d88b658aafbf4e2350",
            "fullName": "trial",
            "phoneNumber": "09876543",
            "shopId": {
              "_id": "63fa08bc46721b7480474bee",
              "name": "kim",
              "location": "naivasha",
              "owner": "63f9efe3879e16801054a0b0",
              "type": "ele",
              "currency": "BDT",
              "createdAt": "2023-02-25T13:10:20.721Z",
              "updatedAt": "2023-02-27T10:53:24.721Z",
              "__v": 0
            },
            "walletBalance": 0,
            "credit": 1930,
            "onCredit": true,
            "gender": "",
            "email": "",
            "address": "",
            "createdAt": "2023-02-28T10:13:44.213Z",
            "updatedAt": "2023-03-02T06:42:35.410Z",
            "__v": 0
          },
          "grandTotal": 6000,
          "creditTotal": 0,
          "totalDiscount": 0,
          "date": "1677579227357",
          "quantity": 1,
          "paymentMethod": "Cash",
          "dueDate": "",
          "createdAt": "2023-02-28T10:13:49.629Z",
          "updatedAt": "2023-02-28T10:13:49.629Z",
          "__v": 0
        }
      ];

      List data = sal;
      List<SalesModel> saleData =
          data.map((e) => SalesModel.fromJson(e)).toList();
      sales.assignAll(saleData);
      salesByShopLoad.value = false;
    }
  }

  getSalesOnCredit({String? shopId}) async {
    try {
      salesOnCreditLoad.value = true;
      var response = await Sales().getSalesOnCredit(shopId);

      if (response["status"] == true) {
        sales.clear();

        List fetchedProducts = response["body"];
        List<SalesModel> listProducts =
            fetchedProducts.map((e) => SalesModel.fromJson(e)).toList();
        sales.assignAll(listProducts);
      } else {
        sales.value = [];
      }

      salesOnCreditLoad.value = false;
    } catch (e) {
      salesOnCreditLoad.value = false;
    }
  }

  getProfitTransaction(
      {required start, required end, required type, required shopId}) async {
    try {
      var now = type == "finance" ? DateTime.now() : start;
      var tomm = now.add(new Duration(days: 1));
      var today = new DateFormat('yyyy-MM-dd')
          .parse(new DateFormat('yyyy-MM-dd')
              .format(type == "finance" ? DateTime.now() : end))
          .toIso8601String();
      var tomorrow = new DateFormat('yyyy-MM-dd')
          .parse(new DateFormat('yyyy-MM-dd').format(tomm));

      var response = await Transactions().getProfitTransactions(
          shopId,
          type == "finance"
              ? DateTime.parse(start).millisecondsSinceEpoch
              : DateTime.parse(today).millisecondsSinceEpoch,
          type == "finance"
              ? DateTime.parse(end).millisecondsSinceEpoch
              : DateTime.parse(tomorrow.toString()).millisecondsSinceEpoch);

      if (response["status"] == true) {
        profitModel.value = ProfitSummary.fromJson(response);
      } else {
        profitModel.value = ProfitSummary();
      }
    } catch (e) {}
  }

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    super.onInit();
  }

  void returnSale(historyBody, salesId) {}

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
}
