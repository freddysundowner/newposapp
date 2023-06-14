import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/screens/finance/expense_page.dart';
import 'package:pointify/widgets/alert.dart';
import 'package:pointify/widgets/loading_dialog.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';

import '../Real/schema.dart';
import '../services/expense.dart';

class ExpenseController extends GetxController {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  var filterStartDate =
      DateTime.parse(DateFormat("yyy-MM-dd").format(DateTime.now())).obs;
  var filterEnndStartDate = DateTime.parse(
          DateFormat("yyy-MM-dd").format(DateTime.now().add(Duration(days: 1))))
      .obs;
  RxBool getExpenseByDateLoad = RxBool(false);
  RxInt totalExpenses = RxInt(0);
  RxList<ExpenseModel> expenses = RxList([]);
  RxBool loadingExpensesCategory = RxBool(false);

  TextEditingController textEditingControllerAmount = TextEditingController();
  TextEditingController textEditingControllerCategory = TextEditingController();
  TextEditingController textEditingControllerName = TextEditingController();

  RxString selectedExpense = RxString("");

  saveExpense() async {
    if (textEditingControllerName.text == "") {
      generalAlert(
        title: "Error",
        message: "Enter expense name",
      );
    } else if (textEditingControllerAmount.text == "") {
      generalAlert(
        title: "Error",
        message: "Enter expense amount",
      );
    } else {
      try {
        ExpenseModel expenseModel = ExpenseModel(ObjectId(),
            category: selectedExpense.value,
            amount: int.parse(textEditingControllerAmount.text),
            shop: Get.find<ShopController>().currentShop.value!.id.toString(),
            name: textEditingControllerName.text,
            attendantId: Get.find<UserController>().user.value,
            createdAt: DateTime.now(),
            date: DateTime.now().millisecondsSinceEpoch);
        await Expense().createExpense(expenseModel);
        textEditingControllerAmount.clear();
        textEditingControllerAmount.clear();
        selectedExpense.value = '';
        getExpenseByDate(
          fromDate: filterStartDate.value,
          toDate: filterEnndStartDate.value,
        );
        Get.back();
      } catch (e) {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        print(e);
      }
    }
  }

  getExpenseByDate({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    expenses.clear();
    if (fromDate == null) {
      fromDate =
          DateTime.parse(DateFormat("yyy-MM-dd").format(filterStartDate.value));
      toDate = DateTime.parse(
          DateFormat("yyy-MM-dd").format(filterEnndStartDate.value));
    }

    RealmResults<ExpenseModel> response = await Expense().getExpenseByDate(
      fromDate: fromDate,
      toDate: toDate,
    );
    expenses.value = response.map((e) => e).toList();
    totalExpenses.value = expenses.fold(
        0, (previousValue, element) => previousValue + element.amount!);
  }
}
