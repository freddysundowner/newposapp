import 'package:get/get.dart';

import 'controllers/AuthController.dart';

class AuthBinding extends Bindings{
  @override
  void dependencies() {
   Get.put<AuthController>(AuthController(),permanent: true);
  }
}

