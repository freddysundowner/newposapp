import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

import '../models/expense_model.dart';

class ExpenseController extends GetxController {
  var startdate = DateTime.now().obs;
  var enddate = DateTime.now().add(Duration(days: 1)).obs;
  RxBool getExpenseByDateLoad = RxBool(false);
  RxInt totalExpenses = RxInt(0);
  RxList<ExpenseModel> expenses = RxList([]);

  TextEditingController textEditingControllerAmount = TextEditingController();
  TextEditingController textEditingControllerCategory = TextEditingController();
  TextEditingController textEditingControllerName = TextEditingController();

  RxString selectedExpense = RxString("");
  RxList categories = RxList([]);


}
