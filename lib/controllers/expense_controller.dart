import 'package:flutter/material.dart';
import 'package:flutterpos/widgets/loading_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/expense_category_model.dart';
import '../models/expense_model.dart';
import '../services/categories.dart';
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

  TextEditingController textEditingControllerAmount = TextEditingController();
  TextEditingController textEditingControllerCategory = TextEditingController();
  TextEditingController textEditingControllerName = TextEditingController();

  RxString selectedExpense = RxString("");
  RxList<ExpenseCategoryModel> categories = RxList([]);

  createExpenseCategory(shopId, context) async {
    try {
      if (textEditingControllerCategory.text == "") {
        showSnackBar(
            message: "please enter expense name", color: Colors.redAccent);
      }
      Map<String, dynamic> body = {
        "type": "cash-out",
        "name": textEditingControllerCategory.text,
        "shop": shopId,
      };
      // LoadingDialog.showLoadingDialog(
      //     context: context, key: _keyLoader, title: "creating category");
      var response = await Categories().createExpenseCategories(body: body);
      // Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        textEditingControllerCategory.text = "";
        showSnackBar(message: "Category created", color: AppColors.mainColor);
        await getCategories(shopId, "cash-out");
      } else {
        showSnackBar(message: "Category created", color: Colors.red);
      }
    } catch (e) {
      // Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }

  getCategories(shopId, type) async {
    try {
      var response = await Categories().getExpenseCategories(id: shopId);
      categories.clear();
      if (response["status"] == true) {
        List fetchedData = response["body"];
        List<ExpenseCategoryModel> categoryData =
            fetchedData.map((e) => ExpenseCategoryModel.fromJson(e)).toList();
        categories.assignAll(categoryData);
        if (selectedExpense.value == "") {
          selectedExpense.value = categoryData[0].name!;
        }
      } else {
        categories.value = [];
      }
    } catch (e) {}
  }

  saveExpense({required shopId, required attendantId, required context}) async {
    if (textEditingControllerName.text == "") {
      showSnackBar(message: "Enter expense name", color: Colors.red);
    } else if (textEditingControllerAmount.text == "") {
      showSnackBar(message: "Enter expense amount", color: Colors.red);
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
          "attendantId": attendantId
        };
        var response = await Expense().createExpense(body: body);
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        if (response["status"] == true) {
          textEditingControllerName.text = "";
          textEditingControllerAmount.text = "";
          await getExpenseByDate(
              shopId: "${shopId}",
              startingDate: startdate.value,
              endingDate: enddate.value,
              type: "notcashflow");
          Get.back();
          showSnackBar(
              message: response["message"], color: AppColors.mainColor);
        } else {
          showSnackBar(
              message: response["message"], color: AppColors.mainColor);
        }
      } catch (e) {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      }
    }
  }

  getExpenseByDate(
      {required shopId,
      required endingDate,
      required startingDate,
      required type}) async {
    try {
      totalExpenses.value = 0;
      expenses.clear();
      getExpenseByDateLoad.value = true;
      var now = type != "cashflow" ? endingDate : DateTime.now();
      var tomm = now.add(new Duration(days: 1));
      var today = new DateFormat('yyyy-MM-dd')
          .parse(new DateFormat('yyyy-MM-dd')
              .format(type != "cashflow" ? startingDate : now))
          .toIso8601String();
      var tomorrow = new DateFormat('yyyy-MM-dd')
          .parse(new DateFormat('yyyy-MM-dd').format(tomm));
      var response = await Expense().getExpenseByDate(
          shopId: shopId,
          startDate: type == "cashflow" ? startingDate : today,
          endDate: type == "cashflow" ? endingDate : tomorrow);
      print("expense response is $response");

      if (response["status"] == true) {
        List fetchedList = response["body"];
        List<ExpenseModel> expenseBody = fetchedList.map((e) => ExpenseModel.fromJson(e)).toList();
        for (var i = 0; i < expenseBody.length; i++) {
          totalExpenses.value += int.parse("${expenseBody[i].amount}");
        }
        expenses.assignAll(expenseBody);
      } else {
        expenses.value = [];
      }
      getExpenseByDateLoad.value = false;
    } catch (e) {
      getExpenseByDateLoad.value = false;
    }
  }
}
