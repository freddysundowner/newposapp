import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/controllers/attendant_controller.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/screens/finance/expense_page.dart';
import 'package:flutterpos/widgets/loading_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/expense_model.dart';
import '../services/expense.dart';
import '../utils/colors.dart';
import '../widgets/snackBars.dart';

class ExpenseController extends GetxController {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var startdate = DateTime.now().obs;
  var enddate = DateTime.now().add(Duration(days: 1)).obs;
  RxBool getExpenseByDateLoad = RxBool(false);
  RxInt totalExpenses = RxInt(0);
  RxList<ExpenseModel> expenses = RxList([]);
  RxBool loadingExpensesCategory = RxBool(false);

  TextEditingController textEditingControllerAmount = TextEditingController();
  TextEditingController textEditingControllerCategory = TextEditingController();
  TextEditingController textEditingControllerName = TextEditingController();

  RxString selectedExpense = RxString("");

  saveExpense({required shopId, required attendantId, required context}) async {
    if (textEditingControllerName.text == "") {
      showSnackBar(
          message: "Enter expense name", color: Colors.red, context: context);
    } else if (textEditingControllerAmount.text == "") {
      showSnackBar(
          message: "Enter expense amount", color: Colors.red, context: context);
    } else {
      try {
        LoadingDialog.showLoadingDialog(
            context: context, key: _keyLoader, title: "Creating expense");
        Map<String, dynamic> body = {
          "category": selectedExpense.value == ""
              ? "Not Categorized"
              : selectedExpense.value,
          "amount": int.parse(textEditingControllerAmount.text),
          "shop": shopId,
          "name": textEditingControllerName.text,
          "attendantId": attendantId,
          "date": DateFormat("yyyy-dd-MM").format(DateTime.now()),
        };
        var response = await Expense().createExpense(body: body);
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        if (response["status"] == true) {
          textEditingControllerName.text = "";
          textEditingControllerAmount.text = "";
          selectedExpense.value = "";
          getExpenseByDate(
              shopId: "${shopId}",
              startingDate: startdate.value,
              endingDate: enddate.value,
              attendant: Get.find<AuthController>().usertype == "admin"
                  ? ""
                  : Get.find<AttendantController>().attendant.value!.id);

          if (MediaQuery.of(context).size.width > 600) {
            Get.find<HomeController>().selectedWidget.value = ExpensePage();
          } else {
            Get.back();
          }
        } else {
          showSnackBar(
              message: response["message"],
              color: AppColors.mainColor,
              context: context);
        }
      } catch (e) {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        print(e);
      }
    }
  }

  getExpenseByDate(
      {required shopId,
      required endingDate,
      required startingDate,
      String? attendant}) async {
    try {
      expenses.clear();
      totalExpenses.value = 0;
      getExpenseByDateLoad.value = true;
      var response = await Expense().getExpenseByDate(
          shopId: shopId,
          startDate: DateFormat("yyyy-MM-dd").format(startingDate),
          endDate: DateFormat("yyyy-MM-dd").format(endingDate),
          attendant: attendant);
      if (response["status"] == true) {
        List fetchedList = response["body"];
        List<ExpenseModel> expenseBody =
            fetchedList.map((e) => ExpenseModel.fromJson(e)).toList();
        for (var i = 0; i < expenseBody.length; i++) {
          totalExpenses.value += int.parse("${expenseBody[i].amount}");
        }
        expenses.assignAll(expenseBody);
      } else {
        expenses.value = [];
      }
      getExpenseByDateLoad.value = false;
    } catch (e) {
      print(e);
      getExpenseByDateLoad.value = false;
    }
  }
}
