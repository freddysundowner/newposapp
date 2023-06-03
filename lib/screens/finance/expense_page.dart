import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:flutter/material.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/expense_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/finance/finance_page.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:pointify/widgets/pdf/expense_pdf.dart';
import 'package:pointify/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Real/Models/schema.dart';
import '../../controllers/AuthController.dart';
import '../../utils/colors.dart';
import '../../utils/dates.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/expense_card.dart';
import '../../widgets/smalltext.dart';
import 'create_expense.dart';

class ExpensePage extends StatelessWidget {
  ExpensePage({Key? key}) : super(key: key) {
    expenseController.getExpenseByDate(
      fromDate: expenseController.startdate.value,
      toDate: expenseController.enddate.value,
    );
  }

  ExpenseController expenseController = Get.find<ExpenseController>();
  ShopController shopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
        largeScreen: Scaffold(
            backgroundColor: Colors.white,
            appBar: _appBar(context),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Column(
                  children: [
                    SizedBox(height: 5),
                    Center(
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: const [
                              BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 1),
                                  blurRadius: 1.0)
                            ]),
                        child: totalsContainer(),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Obx(() {
                          return majorTitle(
                              title:
                                  "${expenseController.expenses.length} Entries",
                              color: Colors.black,
                              size: 15.0);
                        }),
                        addExpenseContainer("large")
                      ],
                    ),
                    Obx(() {
                      return expenseController.getExpenseByDateLoad.value
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : expenseController.expenses.isEmpty
                              ? noItemsFound(context, true)
                              : Container(
                                  padding: EdgeInsets.symmetric(
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
                                        DataColumn(
                                            label: Text('Name',
                                                textAlign: TextAlign.center)),
                                        DataColumn(
                                            label: Text('Category',
                                                textAlign: TextAlign.center)),
                                        DataColumn(
                                            label: Text(
                                                'Amount(${shopController.currentShop.value?.currency})',
                                                textAlign: TextAlign.center)),
                                      ],
                                      rows: List.generate(
                                          expenseController.expenses.length,
                                          (index) {
                                        ExpenseModel expenseModel =
                                            expenseController.expenses
                                                .elementAt(index);
                                        final y = expenseModel.name;
                                        final x = expenseModel.category;

                                        return DataRow(cells: [
                                          DataCell(Container(
                                              width: 75, child: Text(y!))),
                                          DataCell(Container(
                                              width: 75,
                                              child: Text(x.toString()))),
                                          DataCell(Container(
                                              width: 75,
                                              child: Text(
                                                  "${expenseModel.amount}"))),
                                        ]);
                                      }),
                                    ),
                                  ),
                                );
                    }),
                  ],
                ),
              ),
            )),
        smallScreen: Scaffold(
          appBar: _appBar(context),
          body: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: totalsContainer(),
                    ),
                  ),
                  SizedBox(height: 25),
                  Align(
                    alignment: Alignment.centerRight,
                    child: addExpenseContainer("small"),
                  ),
                  SizedBox(height: 10),
                  Obx(() {
                    return majorTitle(
                        title: "${expenseController.expenses.length} Entries",
                        color: Colors.black,
                        size: 15.0);
                  }),
                  SizedBox(
                    height: 10,
                  ),
                  Obx(() {
                    return expenseController.expenses.isEmpty
                        ? Center(
                            child: majorTitle(
                                title: "No Entries found",
                                color: Colors.grey,
                                size: 13.0),
                          )
                        : ListView.builder(
                            itemCount: expenseController.expenses.length,
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              ExpenseModel expenseModel =
                                  expenseController.expenses.elementAt(index);

                              return expenseCard(
                                  context: context, expense: expenseModel);
                            });
                  }),
                ],
              ),
            ),
          ),
        ));
  }

  totalsContainer() {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 20, 80.0, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Obx(() {
            return Text(
              "As from ${DateFormat("yyy-MM-dd").format(expenseController.startdate.value)} to ${DateFormat("yyy-MM-dd").format(expenseController.enddate.value)}",
              style: TextStyle(color: AppColors.mainColor, fontSize: 14.0),
              textAlign: TextAlign.center,
            );
          }),
          SizedBox(height: 20),
          Center(
            child: Text(
              "Totals",
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(height: 5),
          Obx(() {
            return expenseController.getExpenseByDateLoad.value
                ? Center(
                    child: minorTitle(
                        title: "Calculating...", color: AppColors.mainColor),
                  )
                : Center(
                    child: Text(
                      "${shopController.currentShop.value?.currency} ${expenseController.totalExpenses.value}",
                      style: TextStyle(color: Colors.black),
                    ),
                  );
          })
        ],
      ),
    );
  }

  showDatePicker(context) {
    return DateTimeRangePicker(
        startText: "From",
        endText: "To",
        doneText: "Yes",
        cancelText: "Cancel",
        interval: 5,
        initialStartTime: expenseController.startdate.value,
        initialEndTime: expenseController.enddate.value,
        mode: DateTimeRangePickerMode.date,
        minimumTime: DateTime.now().subtract(Duration(days: 365 * 30)),
        maximumTime: DateTime.now().add(Duration(days: 365 * 30)),
        use24hFormat: true,
        onConfirm: (start, end) {
          expenseController.startdate.value = start;
          expenseController.enddate.value = end;
          expenseController.getExpenseByDate(
            fromDate: expenseController.startdate.value,
            toDate: expenseController.enddate.value,
          );
        }).showPicker(context);
  }

  dateChoser(context) {
    return InkWell(
        onTap: () {
          showDatePicker(context);
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Choose Date Range",
                  style: TextStyle(color: Colors.black),
                ),
              ),
              Icon(
                Icons.arrow_drop_down,
                color: Colors.black,
              ),
            ],
          ),
        ));
  }

  Widget addExpenseContainer(type) {
    return InkWell(
      onTap: () {
        if (type == "large") {
          Get.find<HomeController>().selectedWidget.value = CreateExpense();
        } else {
          Get.to(() => CreateExpense());
        }
      },
      child: Container(
        padding: EdgeInsets.all(10),
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
      backgroundColor: Colors.white,
      elevation: 0.3,
      centerTitle: false,
      leading: Get.find<UserController>().user.value?.usertype == "attendant" &&
              MediaQuery.of(context).size.width > 600
          ? null
          : IconButton(
              onPressed: () {
                if (MediaQuery.of(context).size.width > 600) {
                  Get.find<HomeController>().selectedWidget.value =
                      FinancePage();
                } else {
                  Get.back();
                }
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
            ),
      title: majorTitle(title: "Expenses", color: Colors.black, size: 16.0),
      actions: [
        dateChoser(context),
        if (Get.find<UserController>().user.value?.usertype == "admin")
          InkWell(
            onTap: () {
              if (expenseController.expenses.isEmpty) {
                showSnackBar(
                    message: "No items to download", color: Colors.black);
              } else {
                ExpensePdf(
                    shop: shopController.currentShop.value!.name!,
                    expenses: expenseController.expenses);
              }
            },
            child: Icon(
              Icons.download,
              color: Colors.black,
            ),
          ),
        SizedBox(width: 10)
      ],
    );
  }
}
