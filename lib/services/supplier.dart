import 'dart:convert';

import 'package:get/get.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/services/apiurls.dart';
import 'package:pointify/services/client.dart';
import 'package:realm/realm.dart';

import '../Real/Models/schema.dart';
import '../controllers/realm_controller.dart';
import '../controllers/shop_controller.dart';

class SupplierService {
  final RealmController realmService = Get.find<RealmController>();
  createSupplier(Supplier body) async {
    realmService.realm
        .write<Supplier>(() => realmService.realm.add<Supplier>(body));
  }

  RealmResults<Supplier> getSuppliersByShopId({String type = ""}) {
    RealmResults<Supplier> suppliers = realmService.realm.query<Supplier>(
        r'shopId == $0 AND TRUEPREDICATE SORT(createdAt DESC)',
        [Get.find<ShopController>().currentShop.value!.id.toString()]);
    if (type == "debtors") {
      RealmResults<Supplier> suppliersd =
          suppliers.query("balance < 0 AND TRUEPREDICATE SORT(createdAt DESC)");
      print("suppliersd ${suppliersd.length}");
      return suppliersd;
    }
    print("suppliers ${suppliers.length}");
    return suppliers;
  }

  getSupplierById(id) async {
    var response =
        await DbBase().databaseRequest(supplier + id, DbBase().getRequestType);
    return jsonDecode(response);
  }

  updateSupplier({required Map<String, dynamic> body, id}) async {
    var response = await DbBase()
        .databaseRequest(supplier + id, DbBase().patchRequestType, body: body);
    return jsonDecode(response);
  }

  deleteSupplier(Supplier supplier) async {
    realmService.realm.write(() {
      realmService.realm.delete(supplier);
    });
  }

  deleteStockProduct(String productId) async {
    var response = await DbBase().databaseRequest(
        product + "deletestockin/${productId}", DbBase().getRequestType);

    var data = jsonDecode(response);
    return data;
  }

  paySupplyCredit() {
    //   StockInCredit stockInCredit, Map<String, dynamic> body) async {
    // var response = await DbBase().databaseRequest(
    //     supplier + "pay/${stockInCredit.id}", DbBase().patchRequestType,
    //     body: body);
    // return jsonDecode(response);
    return {};
  }

  updateSupplierWalletbalance(Supplier supplier, {int? amount}) async {
    realmService.realm.write(() {
      if (amount != null) {
        supplier.balance = amount;
      }
    });
  }

  getCredit(shopId, uid) async {
    var response = await DbBase().databaseRequest(
        supplier + "stockinhistory/${shopId}/${uid}", DbBase().getRequestType);
    return jsonDecode(response);
  }

  getSupplierSupplies({required supplierId, required returned}) async {
    var attendantId = Get.find<UserController>().user.value?.usertype == "admin"
        ? ""
        : Get.find<UserController>().user.value!.id;

    var response = await DbBase().databaseRequest(
        "${supplier}supplier/returns?supplier=$supplierId&attendant=$attendantId&returned=$returned",
        DbBase().getRequestType);
    return jsonDecode(response);
  }
}
