import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pointify/services/client.dart';
import 'package:realm/realm.dart';

import '../Real/schema.dart';
import '../controllers/realm_controller.dart';
import '../controllers/shop_controller.dart';

class Transactions {
  final RealmController realmService = Get.find<RealmController>();
  final ShopController shopController = Get.find<ShopController>();

  RealmResults<BankModel> getCashAtBank() {
    RealmResults<BankModel> response = realmService.realm.query<BankModel>(
        r'shop == $0',
        [Get.find<ShopController>().currentShop.value!.id.toString()]);
    return response;
  }

  RealmResults<BankModel> getBankByName(String name) {
    RealmResults<BankModel> response = realmService.realm.query<BankModel>(
        "shop == \$0 AND name == '$name' ",
        [Get.find<ShopController>().currentShop.value!.id.toString()]);
    return response;
  }

  updateBank({required BankModel bankModel, int? amount}) async {
    realmService.realm.write(() {
      if (amount != null) {
        bankModel.amount = amount;
      }
    });
  }

  updateCashFlowCategory(
      {required CashFlowCategory cashFlowCategory,
      int? amount,
      String? name}) async {
    realmService.realm.write(() {
      if (amount != null) {
        cashFlowCategory.amount = amount;
      }
      if (name != null) {
        cashFlowCategory.name = name;
      }
    });
  }

  createBank(BankModel bankModel) async {
    realmService.realm
        .write<BankModel>(() => realmService.realm.add<BankModel>(bankModel));
  }

  createTransaction(CashFlowTransaction cashFlowTransaction) async {
    realmService.realm.write<CashFlowTransaction>(
        () => realmService.realm.add<CashFlowTransaction>(cashFlowTransaction));
  }

  createCategory(CashFlowCategory cashFlowCategory) {
    realmService.realm.write<CashFlowCategory>(
        () => realmService.realm.add<CashFlowCategory>(cashFlowCategory));
  }

  RealmResults<CashFlowCategory> getCategory({required type}) {
    RealmResults<CashFlowCategory> response = realmService.realm
        .query<CashFlowCategory>("shop == \$0 AND type == '$type' ",
            [shopController.currentShop.value!.id.toString()]);
    return response;
  }

  RealmResults<BankTransactions> getBakTransactions({required id}) {
    RealmResults<BankTransactions> response =
        realmService.realm.query<BankTransactions>(r'_id == $0', [id]);
    return response;
  }

  RealmResults<CashFlowTransaction> CategoryHistory(
      {required CashFlowCategory cashFlowCategory, BankModel? bankModel}) {
    if (bankModel != null) {
      RealmResults<CashFlowTransaction> response = realmService.realm
          .query<CashFlowTransaction>(
              r'cashFlowCategory == $0', [cashFlowCategory]);
      return response.query("bank == \$0", [bankModel]);
    }

    RealmResults<CashFlowTransaction> response = realmService.realm
        .query<CashFlowTransaction>(
            r'cashFlowCategory == $0', [cashFlowCategory]);
    return response;
  }

  RealmResults<CashFlowTransaction> getCashFlowTransaction({
    String? group,
    String? type,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    print(type);
    RealmResults<CashFlowTransaction> response = realmService.realm.query<
            CashFlowTransaction>(
        "shop == \$0 AND date > ${fromDate!.millisecondsSinceEpoch} AND date < ${toDate!.millisecondsSinceEpoch} AND TRUEPREDICATE SORT(date DESC)",
        [shopController.currentShop.value]);
    if (group != null && group == "bank") {
      var responsedata = response.query("bank != NULL AND type == 'cash-out'");
      return responsedata;
    }
    return response;
  }

  deleteCategory({CashFlowCategory? cashFlowCategory}) async {
    RealmResults<CashFlowTransaction> response = realmService.realm
        .query<CashFlowTransaction>(
            r'cashFlowCategory == $0', [cashFlowCategory]);

    realmService.realm.write(() {
      realmService.realm.deleteMany(response);
      realmService.realm.delete(cashFlowCategory!);
    });
  }
}
