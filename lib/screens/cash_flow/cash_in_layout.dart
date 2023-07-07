// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:pointify/controllers/cashflow_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/cash_flow/cash_flow_manager.dart';
import 'package:pointify/widgets/alert.dart';
import 'package:pointify/widgets/snackBars.dart';
import 'package:get/get.dart';

import '../../controllers/shop_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';

class CashInLayout extends StatelessWidget {
  CashInLayout({Key? key}) : super(key: key) {
    cashflowController.selectedcashOutGroups.value = null;
    cashflowController.cashFlowCategories.clear();
    cashflowController.getCategory(
        "cash-in", Get.find<ShopController>().currentShop.value);
  }

  ShopController createShopController = Get.find<ShopController>();

  CashflowController cashflowController = Get.find<CashflowController>();

  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        cashflowController.clearInputs();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.3,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          titleSpacing: 0.0,
          centerTitle: false,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black),
          title: Text("AddCash In ", style: TextStyle(fontSize: 14)),
          leading: IconButton(
              onPressed: () {
                if (MediaQuery.of(context).size.width > 600) {
                  Get.find<HomeController>().selectedWidget.value =
                      CashFlowManager();
                } else {
                  Get.back();
                }
                cashflowController.clearInputs();
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
            height: isSmallScreen(context) ? kToolbarHeight * 1.5 : 0.0,
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
          ),
        ),
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
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Category", style: TextStyle(color: Colors.grey)),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            if (cashflowController.cashFlowCategories.isEmpty) {
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
                                          cashflowController
                                              .cashFlowCategories.length,
                                          (index) => SimpleDialogOption(
                                                onPressed: () {
                                                  cashflowController
                                                          .selectedcashOutGroups
                                                          .value =
                                                      cashflowController
                                                          .cashFlowCategories
                                                          .elementAt(index);
                                                  cashflowController
                                                          .textEditingControllerName
                                                          .text =
                                                      cashflowController
                                                          .selectedcashOutGroups
                                                          .value!
                                                          .name!;
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                    "${cashflowController.cashFlowCategories.elementAt(index).name}"),
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
                                Obx(
                                  () => Text(cashflowController
                                              .selectedcashOutGroups.value ==
                                          null
                                      ? "Select Category"
                                      : "${cashflowController.selectedcashOutGroups.value!.name}"),
                                ),
                                Icon(Icons.arrow_drop_down, color: Colors.grey)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Padding(
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
                                        controller: cashflowController
                                            .textEditingControllerCategory,
                                        decoration: InputDecoration(
                                            hintText:
                                                "eg.Loan,Capital,Contribution etc",
                                            hintStyle: TextStyle(fontSize: 12),
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
                                        cashflowController
                                            .createCategory("cash-in");
                                        Navigator.pop(context);
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
                  ),
                ],
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Name", style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 2),
                        TextField(
                          controller:
                              cashflowController.textEditingControllerName,
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
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Amount", style: TextStyle(color: Colors.grey)),
                        TextField(
                          controller:
                              cashflowController.textEditingControllerAmount,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }

  saveFunction({required context}) {
    if (cashflowController.textEditingControllerName.text.isEmpty ||
        cashflowController.textEditingControllerAmount.text.isEmpty) {
      isSmallScreen(context)
          ? showSnackBar(message: "Please fill all fields", color: Colors.black)
          : generalAlert(title: "Error", message: "Please fill all fields");
    } else {
      if (cashflowController.selectedcashOutGroups.value == null) {
        isSmallScreen(context)
            ? showSnackBar(message: "Select Category", color: Colors.black)
            : generalAlert(title: "Error", message: "Select Category");
      } else {
        cashflowController.createTransaction(
          type: "cash-in",
        );
      }
    }
    cashflowController.textEditingControllerName.clear();
    cashflowController.textEditingControllerAmount.clear();
  }
}
