import 'package:f_datetimerangepicker/f_datetimerangepicker.dart';
import 'package:flutter/animation.dart';
import 'package:flutterpos/controllers/expense_controller.dart';
import 'package:get/get.dart';

showDatePickers({required context ,required VoidCallback function}) {
  ExpenseController expenseController=Get.find<ExpenseController>();
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
        function();
      }).showPicker(context);
}