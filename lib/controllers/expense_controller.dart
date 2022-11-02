import 'package:get/get.dart';

import '../models/expense_model.dart';

class ExpenseController extends GetxController {
  var startdate = DateTime.now().obs;
  var enddate = DateTime.now().add(Duration(days: 1)).obs;
  RxBool getExpenseByDateLoad = RxBool(false);
  RxInt totalExpenses = RxInt(0);
  RxList<ExpenseModel> expenses = RxList([]);
}
