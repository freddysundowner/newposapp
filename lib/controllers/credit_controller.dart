import 'package:flutterpos/models/sales_model.dart';
import 'package:get/get.dart';

import '../services/credit.dart';

class CreditController extends GetxController {
  var getCreditLoad = false.obs;
  var updateCreditLoad = false.obs;
  var deleteCreditLoad = false.obs;
  RxList<SalesModel> credit =RxList([]);

  getCustomerCredit(attendantId, shopId, uid) async {
    try {
      getCreditLoad.value = true;
      credit.clear();
      var response = await Credit().getCredit(attendantId, shopId, uid);
      if (response != null) {
        List fetchedCredit = response["body"];
        List<SalesModel> credits = fetchedCredit.map((e) => SalesModel.fromJson(e)).toList();

        credit.assignAll(credits);
      } else {
        credit.value = [];
      }
      getCreditLoad.value = false;
    } catch (e) {
      getCreditLoad.value = false;

    }
  }

  void updateCredit(uid) {
    // if (namesController.text != "" || contactController.text != "") {
    //   updateCustomerToApi(customer);
    // }
  }

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