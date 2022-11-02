import 'package:flutterpos/controllers/CustomerController.dart';
import 'package:flutterpos/controllers/attendant_controller.dart';
import 'package:flutterpos/controllers/expense_controller.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/product_controller.dart';
import 'package:flutterpos/controllers/product_history_controller.dart';
import 'package:flutterpos/controllers/purchase_controller.dart';
import 'package:flutterpos/controllers/sales_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/controllers/stock_transfer_controller.dart';
import 'package:flutterpos/controllers/supplierController.dart';
import 'package:get/get.dart';

import 'controllers/AuthController.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<AuthController>(AuthController(), permanent: true);
    Get.put<AttendantController>(AttendantController(), permanent: true);
    Get.put<ShopController>(ShopController(), permanent: true);
    Get.put<HomeController>(HomeController(), permanent: true);
    Get.put<ProductController>(ProductController(), permanent: true);
    Get.put<CustomerController>(CustomerController(), permanent: true);
    Get.put<SupplierController>(SupplierController(), permanent: true);
    Get.put<ProductHistoryController>(ProductHistoryController(),
        permanent: true);
    Get.put<SalesController>(SalesController(), permanent: true);
    Get.put<PurchaseController>(PurchaseController(), permanent: true);
    Get.put<StockTransferController>(StockTransferController(),
        permanent: true);
    Get.put<ExpenseController>(ExpenseController(), permanent: true);
  }
}
