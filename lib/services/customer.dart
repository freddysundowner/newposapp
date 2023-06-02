import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pointify/Real/Models/schema.dart';
import 'package:pointify/services/apiurls.dart';
import 'package:pointify/services/client.dart';
import 'package:realm/realm.dart';

import '../controllers/realm_controller.dart';
import '../controllers/shop_controller.dart';

class Customer {
  final RealmController realmService = Get.find<RealmController>();
  final ShopController shopController = Get.find<ShopController>();
  createCustomer(CustomerModel customerModel) async {
    realmService.realm.write<CustomerModel>(
        () => realmService.realm.add<CustomerModel>(customerModel));
  }

  RealmResults<CustomerModel> getCustomersByShopId(String type) {
    RealmResults<CustomerModel> customers = realmService.realm
        .query<CustomerModel>(
            r'shopId == $0 AND TRUEPREDICATE SORT(createdAt DESC)',
            [shopController.currentShop.value]);
    if (type == "debtors") {
      return customers.query("walletBalance < 0 ");
    }
    return customers;
  }

  getCustomersById(CustomerModel customerModel) {
    RealmResults<CustomerModel> customer = realmService.realm
        .query<CustomerModel>(r'_id == $0', [customerModel.id]);
    print(customer.first.walletBalance);
    return customer.first;
  }

  updateCustomerWalletbalance(CustomerModel customerModel,
      {int? amount}) async {
    realmService.realm.write(() {
      if (amount != null) {
        customerModel.walletBalance = amount;
      }
    });
  }

  updateCustomer(CustomerModel customerModel) async {
    realmService.realm.write<CustomerModel>(() =>
        realmService.realm.add<CustomerModel>(customerModel, update: true));
  }

  deleteCustomer({required CustomerModel customerModel}) async {
    realmService.realm.write(() {
      realmService.realm.delete(customerModel);
    });
  }

  getPurchases({
    required uid,
    required operation,
    required attendantId,
  }) async {
    var response = await DbBase()
        .databaseRequest(customerPurchase + uid, DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }

  getReturns({String? uid, ObjectId? attendantId}) async {
    var response = await DbBase().databaseRequest(
        "$customerReturns?customer=$uid&attendant=$attendantId",
        DbBase().getRequestType);
    var data = jsonDecode(response);
    return data;
  }
}
