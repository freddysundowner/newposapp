import 'package:flutter/material.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/cashflow_controller.dart';
import 'package:pointify/controllers/expense_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/finance/expense_page.dart';
import 'package:get/get.dart';

import '../../controllers/AuthController.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';

class CreateExpense extends StatelessWidget {
  CreateExpense({Key? key}) : super(key: key);
  ExpenseController expenseController = Get.find<ExpenseController>();
  ShopController shopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();
  UserController attendantController = Get.find<UserController>();
  CashflowController cashflowController = Get.find<CashflowController>();

  @override
  Widget build(BuildContext context) {
    cashflowController.getCategory(
        "cash-out", shopController.currentShop.value?.id);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        elevation: 0.3,
        leading: IconButton(
          onPressed: () {
            if (MediaQuery.of(context).size.width > 600) {
              Get.find<HomeController>().selectedWidget.value = ExpensePage();
            } else {
              Get.back();
            }
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title:
            majorTitle(title: " Add Expenses", color: Colors.black, size: 16.0),
      ),
      body: ResponsiveWidget(
          largeScreen: Scaffold(
            backgroundColor: Colors.white,
            body: Align(
              alignment: Alignment.topLeft,
              child: Container(
                  color: Colors.white,
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: expenseCreateCard(context)),
            ),
          ),
          smallScreen: SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: expenseCreateCard(context),
              ),
              const SizedBox(height: 10),
            ]),
          )),
    );
  }

  Widget expenseCreateCard(context) {
    return Card(
      elevation: MediaQuery.of(context).size.width > 600 ? 0 : 2,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width > 600 ? 80 : 10.0,
            vertical: 20),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
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
                        const Text("Category",
                            style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 10),
                        InkWell(
                          onTap: () {
                            if (cashflowController.cashFlowCategories.isEmpty &&
                                cashflowController
                                        .loadingCashFlowCategories.value !=
                                    true) {
                              _addCategory(context);
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return SimpleDialog(
                                      elevation: 10,
                                      children: List.generate(
                                        cashflowController
                                            .cashFlowCategories.length,
                                        (index) => SimpleDialogOption(
                                          onPressed: () {
                                            expenseController
                                                    .selectedExpense.value =
                                                cashflowController
                                                    .cashFlowCategories
                                                    .elementAt(index)
                                                    .name!;
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                              "${cashflowController.cashFlowCategories.elementAt(index).name}"),
                                        ),
                                      ),
                                    );
                                  });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() {
                                  return Text(
                                      "${expenseController.selectedExpense}");
                                }),
                                const Icon(Icons.arrow_drop_down,
                                    color: Colors.grey)
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
                          _addCategory(context);
                        },
                        child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: AppColors.mainColor, width: 2)),
                            child: Text(
                              "+ Add",
                              style: TextStyle(color: AppColors.mainColor),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Name", style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 10),
                  TextField(
                    controller: expenseController.textEditingControllerName,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
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
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Amount", style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 10),
                  TextField(
                    controller: expenseController.textEditingControllerAmount,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ],
              ),
              SizedBox(height: 100),
              Center(
                child: InkWell(
                  onTap: () {
                    expenseController.saveExpense();
                  },
                  child: Container(
                      padding: EdgeInsets.only(
                          top: 10, bottom: 10, left: 60, right: 60),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border:
                              Border.all(color: AppColors.mainColor, width: 2)),
                      child: majorTitle(
                          title: "Save",
                          color: AppColors.mainColor,
                          size: 13.0)),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _addCategory(context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Add Category"),
            content: Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextFormField(
                  controller: cashflowController.textEditingControllerCategory,
                  decoration: InputDecoration(
                      hintText: "eg, rent",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
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
                  cashflowController.createCategory("cash-out");
                },
                child: Text(
                  "Save now".toUpperCase(),
                  style: TextStyle(color: Colors.blue),
                ),
              ),
            ],
          );
        });
  }
}
