import 'package:flutter/material.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/cashflow_controller.dart';
import 'package:pointify/controllers/expense_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/finance/expense_page.dart';
import 'package:get/get.dart';

import '../../Real/schema.dart';
import '../../controllers/AuthController.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';

enum ColorLabel {
  blue('Blue', Colors.blue),
  pink('Pink', Colors.pink),
  green('Green', Colors.green),
  yellow('Yellow', Colors.yellow),
  grey('Grey', Colors.grey);

  const ColorLabel(this.label, this.color);

  final String label;
  final Color color;
}

enum IconLabel {
  smile('Smile', Icons.sentiment_satisfied_outlined),
  cloud(
    'Cloud',
    Icons.cloud_outlined,
  ),
  brush('Brush', Icons.brush_outlined),
  heart('Heart', Icons.favorite);

  const IconLabel(this.label, this.icon);

  final String label;
  final IconData icon;
}

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
        "cash-out", Get.find<ShopController>().currentShop.value);
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
          title: majorTitle(
              title: " Add Expenses", color: Colors.black, size: 16.0),
        ),
        body: Container(
          padding:
              EdgeInsets.symmetric(horizontal: isSmallScreen(context) ? 0 : 10)
                  .copyWith(right: isSmallScreen(context) ? 0 : 50),
          child: ListView(children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: expenseCreateCard(context),
            ),
            const SizedBox(height: 10),
          ]),
        )
        );
  }

  Widget expenseCreateCard(context) {
    final List<DropdownMenuEntry<CashFlowCategory>> cashFlowCategories =
        <DropdownMenuEntry<CashFlowCategory>>[];
    for (final CashFlowCategory c in cashflowController.cashFlowCategories) {
      cashFlowCategories
          .add(DropdownMenuEntry<CashFlowCategory>(value: c, label: c.name!));
    }

    return Form(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Category",
                        style: TextStyle(color: Colors.grey)),
                    const SizedBox(height: 10),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownMenu<CashFlowCategory>(
                        width: MediaQuery.of(context).size.width * 0.65,
                        enableFilter: true,
                        requestFocusOnTap: true,
                        hintText: 'Select category',
                        dropdownMenuEntries: cashFlowCategories,
                        inputDecorationTheme: const InputDecorationTheme(
                          filled: false,
                          contentPadding: EdgeInsets.zero,
                          border: InputBorder.none,
                        ),
                        onSelected: (CashFlowCategory? c) {
                          expenseController.selectedExpense.value = c!.name!;
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0),
                child: TextButton(
                  onPressed: () {
                    _addCategory(context);
                  },
                  child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: AppColors.mainColor, width: 2)),
                      child: Text(
                        "+ Add",
                        style: TextStyle(color: AppColors.mainColor),
                      )),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Description", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              TextField(
                controller: expenseController.textEditingControllerName,
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Amount", style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 10),
              TextField(
                controller: expenseController.textEditingControllerAmount,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    border: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10))),
              ),
            ],
          ),
          const SizedBox(height: 100),
          Center(
            child: InkWell(
              onTap: () {
                expenseController.saveExpense();
              },
              child: Container(
                  padding:
                      const EdgeInsets.only(top: 10, bottom: 10, left: 60, right: 60),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.mainColor, width: 2)),
                  child: majorTitle(
                      title: "Save", color: AppColors.mainColor, size: 13.0)),
            ),
          )
        ],
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
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  cashflowController.createCategory("cash-out");
                },
                child: Text(
                  "Save now".toUpperCase(),
                  style: const TextStyle(color: Colors.blue),
                ),
              ),
            ],
          );
        });
  }
}
