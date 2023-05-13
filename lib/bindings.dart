import 'package:pointify/controllers/CustomerController.dart';
import 'package:pointify/controllers/attendant_controller.dart';
import 'package:pointify/controllers/cashflow_controller.dart';
import 'package:pointify/controllers/expense_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/product_history_controller.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/controllers/stock_transfer_controller.dart';
import 'package:pointify/controllers/supplierController.dart';
import 'package:pointify/controllers/wallet_controller.dart';
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
    Get.put<StockTransferController>(StockTransferController(),
        permanent: true);
    Get.put<CashflowController>(CashflowController(), permanent: true);
    Get.put<ExpenseController>(ExpenseController(), permanent: true);
    Get.put<WalletController>(WalletController(), permanent: true);
  }
}
