import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

import '../Real/schema.dart';
import '../controllers/sales_controller.dart';
import '../screens/finance/profit_page.dart';
import '../screens/product/tabs/bad_stock_history.dart';
import '../screens/product/tabs/receipts_sales.dart';
import '../screens/product/tabs/stockin_history.dart';
import '../screens/sales/all_sales.dart';
import 'colors.dart';

class DateFilter extends StatelessWidget {
  final String from;
  final String? page;
  final String? headline;
  Function? function;
  Product? product;
  int? i;

  DateFilter(
      {Key? key,
      this.function,
      this.product,
      this.i,
      required this.from,
      this.page,
      this.headline})
      : super(key: key);
  SalesController salesController = Get.find<SalesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            isSmallScreen(context) ? AppColors.mainColor : Colors.white,
        elevation: 0.2,
        leading: IconButton(
            onPressed: () {
              isSmallScreen(context) ? Get.back() : backPress();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: isSmallScreen(context) ? Colors.white : Colors.black,
            )),
      ),
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

            if (isSmallScreen(context)) {
              Get.back();
            } else {
              backPress();
            }
            ;
            // }
          }),
    );
  }

  backPress() {
    print("object");
    if (from == "ProductReceiptsSales") {
      Get.find<HomeController>().selectedWidget.value =
          ProductReceiptsSales(product: product!, i: i!);
    } else if (from == "ProductStockHistory") {
      Get.find<HomeController>().selectedWidget.value =
          ProductStockHistory(product: product!, i: i!);
    } else if (from == "ProfitPage") {
      Get.find<HomeController>().selectedWidget.value = ProfitPage(
        page: page,
        headline: headline,
      );
    } else if (from == "AllSalesPage") {
      Get.find<HomeController>().selectedWidget.value = AllSalesPage(
        page: page,
      );
    } else {
      Get.find<HomeController>().selectedWidget.value =
          BadStockHistory(product: product!, i: i!);
    }
  }
}
