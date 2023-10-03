import 'package:flutter/material.dart';
import 'package:pointify/controllers/cashflow_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/expense_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/finance/financial_page.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:pointify/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Real/schema.dart';
import '../../controllers/AuthController.dart';
import '../../utils/colors.dart';
import '../../utils/dates.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/expense_card.dart';
import '../../widgets/smalltext.dart';
import 'create_expense.dart';

class ExpensePage extends StatelessWidget {
  ExpensePage({Key? key}) : super(key: key);
  SalesController salesController = Get.find<SalesController>();
  CashflowController cashflowController = Get.find<CashflowController>();
  ShopController shopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    cashflowController.getCashFlowTransactions(
      fromDate: DateTime.parse(DateFormat("yyyy-MM-dd").format(cashflowController.fromDate.value)),
      toDate: DateTime.parse(DateFormat("yyyy-MM-dd").format(cashflowController.toDate.value))
          .add(const Duration(days: 1)),
    );
    
    return Scaffold(
      appBar: _appBar(context),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: totalsContainer(),
            ),
            const SizedBox(height: 25),
            Container(
              padding: const EdgeInsets.only(right: 10, left: 10),
              child: Align(
                alignment: Alignment.centerRight,
                child: addExpenseContainer(),
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Obx(() {
                return majorTitle(
                    title: "${cashflowController.cashOutflowOtherTransactions.length} Entries",
                    color: Colors.black,
                    size: 15.0);
              }),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(() {
              return cashflowController.cashOutflowOtherTransactions.isEmpty
                  ? Center(
                      child: majorTitle(
                          title: "No Entries found",
                          color: Colors.grey,
                          size: 13.0),
                    )
                  : isSmallScreen(context)
                      ? ListView.builder(
                          itemCount: cashflowController.cashOutflowOtherTransactions.length,
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            CashFlowTransaction expenseModel =
                                cashflowController.cashOutflowOtherTransactions.elementAt(index);

                            return expenseCard(
                                context: context, expense: expenseModel);
                          })
                      : Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          width: double.infinity,
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.grey),
                            child: DataTable(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                width: 1,
                                color: Colors.black,
                              )),
                              columnSpacing: 30.0,
                              columns: [
                                const DataColumn(
                                    label: Text('Name',
                                        textAlign: TextAlign.center)),
                                const DataColumn(
                                    label: Text('Category',
                                        textAlign: TextAlign.center)),
                                DataColumn(
                                    label: Text(
                                        'Amount(${shopController.currentShop.value?.currency})',
                                        textAlign: TextAlign.center)),
                              ],
                              rows: List.generate(
                                  cashflowController.cashOutflowOtherTransactions.length, (index) {
                                CashFlowTransaction expenseModel =
                                    cashflowController.cashOutflowOtherTransactions.elementAt(index);
                                final y = expenseModel.bank!.name;
                                final x = expenseModel.cashFlowCategory!.name;

                                return DataRow(cells: [
                                  DataCell(Text(y!)),
                                  DataCell(Text(x.toString())),
                                  DataCell(Text("${expenseModel.amount}")),
                                ]);
                              }),
                            ),
                          ),
                        );
            }),
          ],
        ),
      ),
    );
  }

  totalsContainer() {
    return Container(
      height: MediaQuery.of(Get.context!).size.height * 0.2,
      color: AppColors.mainColor,
      child: Column(
        children: [
          const SizedBox(height: 30),
          Center(
              child: Text(
            "From ${DateFormat("yyy-MM-dd").format(cashflowController.fromDate.value)} to ${DateFormat("yyy-MM-dd").format(cashflowController.toDate.value)}",
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold),
          )),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {},
                child: Container(
                  padding: const EdgeInsets.only(
                      top: 5, bottom: 5, left: 10, right: 15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.white.withOpacity(0.2)),
                  child: Row(
                    children: [
                      const Icon(Icons.credit_card, color: Colors.white),
                      const SizedBox(width: 10),
                      Obx(
                        () => Text(
                          htmlPrice(cashflowController.cashOutflowOtherTransactions.fold(0, (previousValue, element) => previousValue + element.amount!)),
                          style: const TextStyle(color: Colors.white),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget addExpenseContainer() {
    return InkWell(
      onTap: () {
        if (isSmallScreen(Get.context)) {
          Get.to(() => CreateExpense());
        } else {
          Get.find<HomeController>().selectedWidget.value = CreateExpense(from: "ExpensePage",);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: AppColors.mainColor, width: 3)),
        child: majorTitle(
            title: "Add Expenses", color: AppColors.mainColor, size: 12.0),
      ),
    );
  }

  AppBar _appBar(context) {
    return AppBar(
      elevation: 0.3,
      centerTitle: false,
      leading: IconButton(
        onPressed: () {
          if (!isSmallScreen(context)) {
            Get.find<HomeController>().selectedWidget.value = FinancialPage();
          } else {
            Get.back();
          }

          salesController.filterStartDate.value =
              DateTime.parse(DateFormat("yyy-MM-dd").format(DateTime.now()));
          salesController.filterEndDate.value = DateTime.parse(
              DateFormat("yyy-MM-dd")
                  .format(DateTime.now().add(const Duration(days: 1))));
          salesController.getFinanceSummary(
              fromDate: salesController.filterStartDate.value,
              toDate: salesController.filterEndDate.value);
        },
        icon: const Icon(
          Icons.arrow_back_ios,
          color: Colors.white,
        ),
      ),
      title: majorTitle(title: "Expenses", color: Colors.white, size: 16.0),
      actions: [
        InkWell(
            onTap: () async {
              final picked = await showDateRangePicker(
                context: context,
                lastDate: DateTime(2079),
                firstDate: DateTime(2019),
              );
              cashflowController.fromDate.value = picked!.start;
              cashflowController.toDate.value = picked.end;
              Get.find<SalesController>().getProfitTransaction(
                  fromDate: picked.start, toDate: picked.end);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Row(
                  children: [
                    Text(
                      "Filter",
                      style: TextStyle(
                          color: AppColors.mainColor,
                          fontWeight: FontWeight.bold),
                    ),
                    Icon(
                      Icons.filter_list_alt,
                      color: AppColors.mainColor,
                      size: 20,
                    )
                  ],
                ),
              ),
            )),
        if (Get.find<UserController>().user.value?.usertype == "admin")
          InkWell(
            onTap: () {
              if (cashflowController.cashOutflowOtherTransactions.isEmpty) {
                showSnackBar(
                    message: "No items to download", color: Colors.black);
              } else {
                // ExpensePdf(
                //     shop: shopController.currentShop.value!.name!,
                //     expenses: cashflowController.cashOutflowOtherTransactions);
              }
            },
            child: const Icon(
              Icons.download,
              color: Colors.white,
            ),
          ),
        const SizedBox(width: 10)
      ],
    );
  }
}
