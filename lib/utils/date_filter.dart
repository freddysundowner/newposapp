import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../controllers/sales_controller.dart';
import 'colors.dart';

class DateFilter extends StatelessWidget {
  Function? function;
  DateFilter({Key? key, this.function}) : super(key: key);
  SalesController salesController = Get.find<SalesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SfDateRangePicker(
          showActionButtons: true,
          confirmText: "Filter",
          selectionMode: DateRangePickerSelectionMode.range,
          monthViewSettings: DateRangePickerMonthViewSettings(),
          headerStyle: DateRangePickerHeaderStyle(
              textAlign: TextAlign.center,
              textStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.mainColor,
                  fontSize: 18)),
          onSubmit: (value) {
            // print(value);
            function!(value);

            Get.back();
            // }
          }),
    );
  }
}
