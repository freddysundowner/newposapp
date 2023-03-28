// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/cashflow_controller.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/shop_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import 'cash_flow_manager.dart';

class CashOutLayout extends StatelessWidget {
  CashOutLayout({Key? key}) : super(key: key) {
    cashFlowController.selectedCashFlowCategories.value = null;
    cashFlowController.cashFlowCategories.clear();
    cashFlowController.getCategory(
        "cash-out", createShopController.currentShop.value!.id);
  }

  CashflowController cashFlowController = Get.find<CashflowController>();
  ShopController createShopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {

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
        ),
        body: ResponsiveWidget(
          largeScreen: Container(
            width: MediaQuery.of(context).size.width * 0.35,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                inputFields(context),
                SizedBox(height: 50),
                Center(child: saveButton(context)),
              ],
            ),
          ),
          smallScreen: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: inputFields(context),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
            child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          height: MediaQuery.of(context).size.width > 600
              ? 0
              : kToolbarHeight * 1.5,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: saveButton(context),
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
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Category", style: TextStyle(color: Colors.grey)),
                        SizedBox(height: 2),
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
                                                          .selectedCashFlowCategories
                                                          .value =
                                                      cashFlowController
                                                          .cashFlowCategories
                                                          .elementAt(index);
                                                  if (cashFlowController
                                                          .cashFlowCategories
                                                          .elementAt(index)
                                                          .name!
                                                          .toLowerCase() !=
                                                      "bank") {
                                                    cashFlowController
                                                            .textEditingControllerName
                                                            .text =
                                                        cashFlowController
                                                            .selectedCashFlowCategories
                                                            .value!
                                                            .name!;
                                                  }
                                                  if (cashFlowController
                                                          .selectedCashFlowCategories
                                                          .value!
                                                          .name!
                                                          .toLowerCase() ==
                                                      "bank") {
                                                    cashFlowController
                                                        .textEditingControllerName
                                                        .clear();
                                                    cashFlowController
                                                        .fetchCashAtBank(
                                                            createShopController
                                                                .currentShop
                                                                .value!
                                                                .id);
                                                  }
                                                  Navigator.pop(context);
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
                                        .selectedCashFlowCategories
                                        .value
                                        ?.name ??
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
                                        controller: cashFlowController
                                            .textEditingControllerCategory,
                                        decoration: InputDecoration(
                                            hintText: "eg.Personaal use etc",
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
                                              color: Colors.black,
                                              context: context);
                                        } else {
                                          cashFlowController.createCategory(
                                              "cash-out",
                                              createShopController
                                                  .currentShop.value!.id!,
                                              context);
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
                  ),
                ],
              ),
              SizedBox(height: 5),
              Obx(() {
                return cashFlowController.selectedCashFlowCategories.value !=
                            null &&
                        cashFlowController
                                .selectedCashFlowCategories.value!.name!
                                .toLowerCase() ==
                            "bank"
                    ? Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Select Bank",
                                  style: TextStyle(color: Colors.grey)),
                              InkWell(
                                onTap: () {
                                  if (cashFlowController.cashAtBanks.isEmpty) {
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
                                          padding:
                                              const EdgeInsets.all(5.0),
                                          child: TextFormField(
                                              controller: cashFlowController
                                                  .textEditingControllerBankName,
                                              decoration: InputDecoration(
                                                  hintText: "eg. Equity",
                                                  border:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius
                                                            .circular(10),
                                                  ))),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Cancel".toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.blue),
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
                                                    color: Colors.black,
                                                    context: context);
                                              } else {
                                                cashFlowController
                                                    .createBankNames(
                                                        shopId:
                                                            createShopController
                                                                .currentShop
                                                                .value
                                                                ?.id,
                                                        context: context);
                                              }
                                            },
                                            child: Text(
                                              "Save now".toUpperCase(),
                                              style: TextStyle(
                                                  color: Colors.blue),
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
                                          bottomRight:
                                              Radius.circular(10))),
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
                          Text("Name",
                              style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 2),
                          TextField(
                            controller: cashFlowController
                                .textEditingControllerName,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.grey),
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                          SizedBox(height: 5)
                        ]);
              }),

              Text("Amount",
                  style: TextStyle(color: Colors.grey)),
              TextField(
                controller: cashFlowController
                    .textEditingControllerAmount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Widget saveButton(context) {
    return InkWell(
      onTap: () {
        if (cashFlowController.textEditingControllerAmount.text.isEmpty ||
            (cashFlowController.selectedCashFlowCategories.value!.name!
                        .toLowerCase() !=
                    "bank" &&
                cashFlowController.textEditingControllerName.text.isEmpty)) {
          showSnackBar(
              message: "please fill all fields",
              color: Colors.black,
              context: context);
        } else {
          cashFlowController.createTransaction(
              shopId: createShopController.currentShop.value!.id,
              context: context,
              type: "cash-out");
        }
      },
      child: Container(
          child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width > 600 ? 300 : double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 3, color: AppColors.mainColor),
            borderRadius: BorderRadius.circular(40)),
        child: Center(
            child: majorTitle(
                title: "Save", color: AppColors.mainColor, size: 18.0)),
      )),
    );
  }
}
