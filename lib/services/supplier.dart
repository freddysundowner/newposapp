import 'dart:convert';

import 'package:get/get.dart';
import 'package:realm/realm.dart';

import '../Real/schema.dart';
import '../controllers/realm_controller.dart';
import '../controllers/shop_controller.dart';

class SupplierService {
  final RealmController realmService = Get.find<RealmController>();
  createSupplier(Supplier body) async {
    realmService.realm
        .write<Supplier>(() => realmService.realm.add<Supplier>(body));
  }

  RealmResults<Supplier> getSuppliersByShopId({String type = "", Shop? shop}) {
    RealmResults<Supplier> suppliers = realmService.realm.query<Supplier>(
        r'shopId == $0 AND TRUEPREDICATE SORT(createdAt DESC)',
        [shop!.id.toString()]);
    if (type == "debtors") {
      RealmResults<Supplier> suppliersd =
          suppliers.query("balance < 0 AND TRUEPREDICATE SORT(createdAt DESC)");
      return suppliersd;
    }
    return suppliers;
  }

  updateSupplier(
    Supplier supplier, {
    String? fullname,
    String? phoneNumber,
    String? emailAddress,
    String? location,
  }) async {
    realmService.realm.write(() {
      if (fullname != null) {
        supplier.fullName = fullname;
      }
      if (phoneNumber != null) {
        supplier.phoneNumber = phoneNumber;
      }
      if (emailAddress != null) {
        supplier.emailAddress = emailAddress;
      }
      if (location != null) {
        supplier.location = location;
      }
    });

    realmService.realm.write<Supplier>(
        () => realmService.realm.add<Supplier>(supplier, update: true));
  }

  deleteSupplier(Supplier supplier) async {
    realmService.realm.write(() {
      realmService.realm.delete(supplier);
    });
  }

  deleteSuppliers(List<Supplier> supplier) async {
    realmService.realm.write(() {
      realmService.realm.deleteMany(supplier);
    });
  }

  updateSupplierWalletbalance(Supplier? supplier, {int? amount}) async {
    realmService.realm.write(() {
      if (amount != null) {
        supplier?.balance = amount;
      }
    });
  }
}
