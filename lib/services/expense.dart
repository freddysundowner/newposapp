import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pointify/Real/Models/schema.dart';
import 'package:pointify/services/apiurls.dart';
import 'package:realm/realm.dart';

import '../controllers/realm_controller.dart';
import '../controllers/shop_controller.dart';
import 'client.dart';

class Expense {
  final RealmController realmService = Get.find<RealmController>();
  final ShopController shopController = Get.find<ShopController>();
  createExpense(ExpenseModel expenseModel) async {
    realmService.realm.write<ExpenseModel>(
        () => realmService.realm.add<ExpenseModel>(expenseModel));
  }

  RealmResults<ExpenseModel> getExpenseByDate({
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    RealmResults<ExpenseModel> expenses = realmService.realm.query<
            ExpenseModel>(
        'date > ${fromDate!.millisecondsSinceEpoch} AND date < ${toDate!.millisecondsSinceEpoch}',
        [customer]);
    print("expenses ${expenses.length}");
    return expenses;
  }
}
