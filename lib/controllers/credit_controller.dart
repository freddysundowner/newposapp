import 'package:flutterpos/models/attendant_model.dart';
import 'package:flutterpos/models/customer_model.dart';
import 'package:flutterpos/models/sales_model.dart';
import 'package:flutterpos/models/shop_model.dart';
import 'package:get/get.dart';

import '../services/credit.dart';

class CreditController extends GetxController {
  var getCreditLoad = false.obs;
  var updateCreditLoad = false.obs;
  var deleteCreditLoad = false.obs;
  RxList<SalesModel> credit = RxList([]);

  getCustomerCredit(attendantId, shopId, uid) async {
    try {
      getCreditLoad.value = true;
      credit.clear();
      var response = await Credit().getCredit(attendantId, shopId, uid);
      if (response != null) {
        List fetchedCredit = response["body"];
        List<SalesModel> credits =
            fetchedCredit.map((e) => SalesModel.fromJson(e)).toList();

        credit.assignAll(credits);
      } else {
        credit.value = [];
      }
      getCreditLoad.value = false;
    } catch (e) {
      SalesModel salesModel = SalesModel(
          id: "124356",
          receiptNumber: "rtyui234uy",
          shop: ShopModel(),
          attendantId: AttendantModel(),
          customerId: CustomerModel(),
          grandTotal: 2000,
          creditTotal: 300,
          totalDiscount: 20,
          quantity: 20,
          paymentMethod: "cash",
          dueDate: "",
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());

      credit.add(salesModel);
      credit.add(salesModel);
      getCreditLoad.value = false;
    }
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
