import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../services/sales.dart';
import '../utils/colors.dart';
import '../widgets/snackBars.dart';

class SalesController extends GetxController {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  TextEditingController textEditingSellingPrice = TextEditingController();
  TextEditingController textEditingCredit = TextEditingController();

  RxList<ProductModel> selectedList = RxList([]);
  RxInt grandTotal = RxInt(0);
  RxInt balance = RxInt(0);
  var selecteProduct = ProductModel().obs;
  RxBool saveSaleLoad = RxBool(false);
  RxString selectedPaymentMethod = RxString("Cash");
  RxString selectedCustomer = RxString("");
  RxString selectedCustomerId = RxString("");
  var dueDate = new DateFormat('MMMM/dd/yyyy hh:mm a')
      .parse(new DateFormat('MMMM/dd/yyyy hh:mm a').format(DateTime.now()))
      .toIso8601String()
      .obs;

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
        showSnackBar(
            message: "please select customer to sell to",
            color: Colors.redAccent);
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
          color: Colors.redAccent);
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
      var response = await Sales().createSales({"sale": sale, "products": products});
      print("response is ${response}");
      if (response["status"] == true) {
        selectedList.value = [];
        grandTotal.value = 0;
        balance.value = 0;
        textEditingCredit.text = "0";
        selectedPaymentMethod.value == "Cash";
        // getSalesByDates(
        //     shopId: createShopController.currentShop.value?.id,
        //     startingDate: DateTime.now(),
        //     endingDate: DateTime.now(),
        //     type: "notcashflow");
        if (screen == "admin") {
          Get.back();
        }

        showSnackBar(message: response["message"], color: AppColors.mainColor);
      } else if (response["status"] == false &&
          selectedPaymentMethod.value == "Wallet") {
        saveSaleLoad.value = false;
        showDepositAllertDialog(context);
      } else {
        showSnackBar(message: response["message"], color: Colors.red);
      }

      saveSaleLoad.value = false;
    } catch (e) {
      saveSaleLoad.value = false;
      print(e);
    }
  }

  showSaleDatePicker(
      {required context,
      required shopId,
      required attendantsId,
      required customerIds,
      required screen}) {
    showMaterialModalBottomSheet(
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
}
