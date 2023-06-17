import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pointify/Real/schema.dart';
import 'package:realm/realm.dart';

import '../controllers/realm_controller.dart';
import '../controllers/shop_controller.dart';

class Expense {
  final RealmController realmService = Get.find<RealmController>();
  final ShopController shopController = Get.find<ShopController>();
  createExpense(ExpenseModel expenseModel) async {
    realmService.realm.write<ExpenseModel>(
        () => realmService.realm.add<ExpenseModel>(expenseModel));
  }

  RealmResults<ExpenseModel> getExpenseByDate(
      {DateTime? fromDate, DateTime? toDate, Shop? shop}) {
    RealmResults<ExpenseModel> expenses = realmService.realm.query<
            ExpenseModel>(
        'shop == \$0 AND date > ${fromDate!.millisecondsSinceEpoch} AND date < ${toDate!.millisecondsSinceEpoch}',
        [shopController.currentShop.value!.id.toString()]);
    return expenses;
  }
}
