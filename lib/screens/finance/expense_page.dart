import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/expense_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/expense_model.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/expense_card.dart';
import '../../widgets/smalltext.dart';
import 'create_expense.dart';

class ExpensePage extends StatelessWidget {
  ExpensePage({Key? key}) : super(key: key);
  ExpenseController expenseController = Get.find<ExpenseController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0.3,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: majorTitle(title: "Expenses", color: Colors.black, size: 16.0),
        actions: [
          InkWell(
              onTap: () {
                DateTimeRangePicker(
                    startText: "From",
                    endText: "To",
                    doneText: "Yes",
                    cancelText: "Cancel",
                    interval: 5,
                    initialStartTime: expenseController.startdate.value,
                    initialEndTime: expenseController.enddate.value,
                    mode: DateTimeRangePickerMode.date,
                    minimumTime:
                        DateTime.now().subtract(Duration(days: 365 * 30)),
                    maximumTime: DateTime.now().add(Duration(days: 365 * 30)),
                    use24hFormat: true,
                    onConfirm: (start, end) {
                      expenseController.startdate.value = start;
                      expenseController.enddate.value = end;
                    }).showPicker(context);
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
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
              ))
        ],
      ),
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
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(80.0, 20, 80.0, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() {
                          return majorTitle(
                              title:
                                  "As from ${DateFormat("yyy-MM-dd").format(expenseController.startdate.value)} to ${DateFormat("yyy-MM-dd").format(expenseController.enddate.value)}",
                              color: AppColors.mainColor,
                              size: 14.0);
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
                                      title: "Calculating...",
                                      color: AppColors.mainColor),
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
                  ),
                ),
              ),
              SizedBox(height: 25),
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    Get.to(() => CreateExpense());
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(50),
                        border:
                            Border.all(color: AppColors.mainColor, width: 3)),
                    child: majorTitle(
                        title: "Add Expenses",
                        color: AppColors.mainColor,
                        size: 12.0),
                  ),
                ),
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
                return expenseController.getExpenseByDateLoad.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : expenseController.expenses.length == 0
                        ? Center(
                            child: majorTitle(
                                title: "No Entries found",
                                color: Colors.grey,
                                size: 13.0),
                          )
                        : ListView.builder(
                            itemCount: expenseController.expenses.length,
                            physics: NeverScrollableScrollPhysics(),
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
    );
  }
}
