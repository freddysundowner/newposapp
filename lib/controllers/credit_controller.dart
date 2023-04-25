import 'package:get/get.dart';

import '../services/credit.dart';

class CreditController extends GetxController {
  var updateCreditLoad = false.obs;
  var deleteCreditLoad = false.obs;

  void deleteCredit(uid) async {
    try {
      deleteCreditLoad.value = true;
      await Credit().deleteCredit(uid);
      deleteCreditLoad.value = false;
    } catch (e) {
      deleteCreditLoad.value = false;
    }
  }
}
