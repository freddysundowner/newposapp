// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointify/controllers/cashflow_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/widgets/snackBars.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/shop_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/alert.dart';
import '../../widgets/bigtext.dart';
import 'cash_flow_manager.dart';

class CashOutLayout extends StatelessWidget {
  DateTime? date;

  CashOutLayout({Key? key, this.date}) : super(key: key) {
    cashFlowController.selectedcashOutGroups.value = null;
    cashFlowController.cashFlowCategories.clear();
    cashFlowController.getCategory(
        "cash-out", Get.find<ShopController>().currentShop.value);
  }

  CashflowController cashFlowController = Get.find<CashflowController>();
  ShopController createShopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    cashFlowController.getCategory(
        "cash-out", Get.find<ShopController>().currentShop.value);
    return WillPopScope(
      onWillPop: () async {
        cashFlowController.clearInputs();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.3,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          titleSpacing: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black),
          centerTitle: false,
          title: Text("Add Cash Out"),
          leading: IconButton(
              onPressed: () {
                if (MediaQuery.of(context).size.width > 600) {
                  Get.find<HomeController>().selectedWidget.value =
                      CashFlowManager();
                } else {
                  Get.back();
                }
                cashFlowController.clearInputs();
              },
              icon: Icon(Icons.arrow_back_ios)),
          actions: [
            if (!isSmallScreen(context))
              InkWell(
                onTap: () {
                  saveFunction(context: context);
                },
                child: Container(
                  margin:
                      EdgeInsets.symmetric(vertical: 10).copyWith(right: 10),
                  height: kTextTabBarHeight * 0.5,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      border: Border.all(color: AppColors.mainColor),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    "Save",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: inputFields(context),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          height: isSmallScreen(context) ? kToolbarHeight * 1.5 : 0,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: InkWell(
            onTap: () {
              saveFunction(context: context);
            },
            child: Container(
              padding: EdgeInsets.all(10),
              width: MediaQuery.of(context).size.width > 600
                  ? 300
                  : double.infinity,
              decoration: BoxDecoration(
                  border: Border.all(width: 3, color: AppColors.mainColor),
                  borderRadius: BorderRadius.circular(40)),
              child: Center(
                  child: majorTitle(
                      title: "Save", color: AppColors.mainColor, size: 18.0)),
            ),
          ),
        )),
      ),
    );
  }

  Widget inputFields(context) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(5)),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Category", style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            if (cashFlowController.cashFlowCategories.isEmpty) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content:
                                          Text("Add Category to continue."),
                                      actions: [
                                        TextButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            Get.back();
                                          },
                                        )
                                      ],
                                    );
                                  });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                      children: List.generate(
                                          cashFlowController
                                              .cashFlowCategories.length,
                                          (index) => SimpleDialogOption(
                                                onPressed: () {
                                                  cashFlowController
                                                          .selectedcashOutGroups
                                                          .value =
                                                      cashFlowController
                                                          .cashFlowCategories
                                                          .elementAt(index);
                                                  if (cashFlowController
                                                          .cashFlowCategories
                                                          .elementAt(index)
                                                          .key!
                                                          .toLowerCase() !=
                                                      "bank") {
                                                    cashFlowController
                                                            .textEditingControllerName
                                                            .text =
                                                        cashFlowController
                                                            .selectedcashOutGroups
                                                            .value!
                                                            .name!;
                                                  }
                                                  if (cashFlowController
                                                          .selectedcashOutGroups
                                                          .value!
                                                          .name!
                                                          .toLowerCase() ==
                                                      "bank") {
                                                    cashFlowController
                                                        .textEditingControllerName
                                                        .clear();
                                                    cashFlowController
                                                        .fetchCashAtBank();
                                                  }
                                                  Get.back();
                                                },
                                                child: Text(
                                                    "${cashFlowController.cashFlowCategories.elementAt(index).name}"),
                                              )),
                                    );
                                  });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() => Text(cashFlowController
                                        .selectedcashOutGroups.value?.name ??
                                    "Select category")),
                                Icon(Icons.arrow_drop_down, color: Colors.grey)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: TextButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Add Category"),
                                content: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: TextFormField(
                                      controller: cashFlowController
                                          .textEditingControllerCategory,
                                      decoration: InputDecoration(
                                          hintText: "eg.Personal use etc",
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ))),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      "Cancel".toUpperCase(),
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      if (cashFlowController
                                          .textEditingControllerCategory
                                          .text
                                          .isEmpty) {
                                        showSnackBar(
                                            message:
                                                "Please enter category name",
                                            color: Colors.black);
                                      } else {
                                        cashFlowController
                                            .createCategory("cash-out");
                                      }
                                    },
                                    child: Text(
                                      "Save now".toUpperCase(),
                                      style: TextStyle(color: Colors.blue),
                                    ),
                                  ),
                                ],
                              );
                            });
                      },
                      child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.2),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomRight: Radius.circular(10))),
                          child: Text(
                            "+ Add",
                            style: TextStyle(color: Colors.green),
                          )),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Obx(() {
                return cashFlowController.selectedcashOutGroups.value != null &&
                        cashFlowController.selectedcashOutGroups.value!.key ==
                            "bank"
                    ? Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Select Bank",
                                    style: TextStyle(color: Colors.grey)),
                                SizedBox(height: 10),
                                InkWell(
                                  onTap: () {
                                    if (cashFlowController
                                        .cashAtBanks.isEmpty) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content:
                                                  Text("Add bank to continue."),
                                              actions: [
                                                TextButton(
                                                  child: Text("OK"),
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                )
                                              ],
                                            );
                                          });
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SimpleDialog(
                                              children: List.generate(
                                                  cashFlowController
                                                      .cashAtBanks.length,
                                                  (index) => SimpleDialogOption(
                                                        onPressed: () {
                                                          cashFlowController
                                                                  .selectedBank
                                                                  .value =
                                                              cashFlowController
                                                                  .cashAtBanks
                                                                  .elementAt(
                                                                      index);

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            "${cashFlowController.cashAtBanks.elementAt(index).name}"),
                                                      )),
                                            );
                                          });
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Obx(() {
                                          return Text(cashFlowController
                                                  .selectedBank.value?.name ??
                                              "");
                                        }),
                                        Icon(Icons.arrow_drop_down,
                                            color: Colors.grey)
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Add Bank Name"),
                                        content: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: TextFormField(
                                              controller: cashFlowController
                                                  .textEditingControllerBankName,
                                              decoration: InputDecoration(
                                                  hintText: "eg. Equity",
                                                  border: OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                  ))),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Cancel".toUpperCase(),
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                              if (cashFlowController
                                                  .textEditingControllerBankName
                                                  .text
                                                  .isEmpty) {
                                                showSnackBar(
                                                    message:
                                                        "Please enter bank name",
                                                    color: Colors.black);
                                              } else {
                                                cashFlowController
                                                    .createBankNames();
                                              }
                                            },
                                            child: Text(
                                              "Save now".toUpperCase(),
                                              style:
                                                  TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10))),
                                  child: Text(
                                    "+ Add",
                                    style: TextStyle(color: Colors.green),
                                  )),
                            ),
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Text("Name", style: TextStyle(color: Colors.grey)),
                            SizedBox(height: 2),
                            TextField(
                              controller:
                                  cashFlowController.textEditingControllerName,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                            SizedBox(height: 5)
                          ]);
              }),
              SizedBox(height: 20),
              Text("Amount", style: TextStyle(color: Colors.grey)),
              SizedBox(height: 10),
              TextField(
                controller: cashFlowController.textEditingControllerAmount,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  saveFunction({required BuildContext context}) {
    if (cashFlowController.textEditingControllerAmount.text.isEmpty ||
        (cashFlowController.selectedcashOutGroups.value!.key != "bank" &&
            cashFlowController.textEditingControllerName.text.isEmpty)) {
      isSmallScreen(context)
          ? showSnackBar(message: "please fill all fields", color: Colors.black)
          : generalAlert(title: "Error", message: "please fill all fields");
    } else {
      cashFlowController.createTransaction(type: "cash-out");
    }
  }
}
