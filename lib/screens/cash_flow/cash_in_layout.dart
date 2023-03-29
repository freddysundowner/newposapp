// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/cashflow_controller.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/cash_flow/cash_flow_manager.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';

import '../../controllers/shop_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';

class CashInLayout extends StatelessWidget {
  CashInLayout({Key? key}) : super(key: key) {
    cashflowController.selectedCashFlowCategories.value = null;
    cashflowController.cashFlowCategories.clear();
    cashflowController.getCategory(
        "cash-in", createShopController.currentShop.value!.id);
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
          title: Text("Add Cash In ", style: TextStyle(fontSize: 14)),
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
        ),
        body: ResponsiveWidget(
          largeScreen: Scaffold(
            backgroundColor: Colors.white,
            body: Container(
              width: MediaQuery.of(context).size.width * 0.5,
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
          ),
        ),
      ),
    );
  }

  Widget saveButton(context) {
    return InkWell(
      onTap: () {
        if (cashflowController.textEditingControllerName.text.isEmpty ||
            cashflowController.textEditingControllerAmount.text.isEmpty) {
          showSnackBar(
              message: "Please fill all fields",
              color: Colors.black,
              context: context);
        } else {
          cashflowController.createTransaction(
              shopId: createShopController.currentShop.value!.id,
              context: context,
              type: "cash-in");
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width > 600 ? 300 : double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 3, color: AppColors.mainColor),
            borderRadius: BorderRadius.circular(40)),
        child: Center(
            child: majorTitle(
                title: "Save", color: AppColors.mainColor, size: 18.0)),
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
                        InkWell(
                          onTap: () {
                            if (cashflowController.cashFlowCategories.length ==
                                0) {
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
                                                          .selectedCashFlowCategories
                                                          .value =
                                                      cashflowController
                                                          .cashFlowCategories
                                                          .elementAt(index);
                                                  cashflowController
                                                          .textEditingControllerName
                                                          .text =
                                                      cashflowController
                                                          .selectedCashFlowCategories
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
                                              .selectedCashFlowCategories
                                              .value ==
                                          null
                                      ? "Select Category"
                                      : "${cashflowController.selectedCashFlowCategories.value!.name}"),
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
                                        cashflowController.createCategory(
                                            "cash-in",
                                            shopController
                                                .currentShop.value!.id!,
                                            context);
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

                  // Expanded(
                  //   flex: 1,
                  //   child: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       Text("Date", style: TextStyle(color: Colors.grey)),
                  //       TextField(
                  //         enabled: false,
                  //         decoration: InputDecoration(
                  //             hintText:
                  //                 "${DateFormat("dd-MMM-yyyy").format(DateTime.now())}",
                  //             border: OutlineInputBorder(
                  //                 borderSide: BorderSide(color: Colors.grey),
                  //                 borderRadius: BorderRadius.circular(10))),
                  //       ),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
        ));
  }
}
