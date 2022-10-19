import 'package:flutterpos/controllers/attendant_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:get/get.dart';

import 'controllers/AuthController.dart';

class AuthBinding extends Bindings{
  @override
  void dependencies() {
   Get.put<AuthController>(AuthController(),permanent: true);
   Get.put<AttendantController>(AttendantController(),permanent: true);
   Get.put<ShopController>(ShopController(),permanent: true);
  }
}

