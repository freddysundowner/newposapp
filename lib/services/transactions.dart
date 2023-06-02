import 'dart:convert';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:pointify/services/client.dart';
import 'package:realm/realm.dart';

import '../Real/Models/schema.dart';
import '../controllers/realm_controller.dart';
import 'apiurls.dart';

class Transactions {
  final RealmController realmService = Get.find<RealmController>();
  getProfitTransactions(shopId, startDate, endDate) async {
    var response = await DbBase().databaseRequest(
      "$transaction/salessummary/$shopId/$startDate/$endDate",
      DbBase().getRequestType,
    );
    return jsonDecode(response);
  }

  RealmResults<BankModel> getCashAtBank(shopId) {
    RealmResults<BankModel> response =
        realmService.realm.query<BankModel>(r'shop == $0', [shopId]);
    return response;
  }

  createBank({required Map<String, dynamic> body}) async {
    var response = await DbBase().databaseRequest(
        "$cashflow/create/bank", DbBase().postRequestType,
        body: body);

    return jsonDecode(response);
  }

  getBankNames(shopId) async {
    var response = await DbBase().databaseRequest(
      category + "banklist/${shopId}",
      DbBase().getRequestType,
    );
    var data = jsonDecode(response);
    return data;
  }

  createTransaction({required Map<String, dynamic> body}) async {
    var response = await DbBase()
        .databaseRequest(cashflow, DbBase().postRequestType, body: body);
    var data = jsonDecode(response);
    return data;
  }

  createCategory({required Map<String, dynamic> body}) async {
    var response = await DbBase().databaseRequest(
        "${cashflow}" + "category", DbBase().postRequestType,
        body: body);
    var data = jsonDecode(response);
    return data;
  }

  RealmResults<CashFlowCategory> getCategory({required shop, required type}) {
    RealmResults<CashFlowCategory> response =
        realmService.realm.query<CashFlowCategory>(r'shop == $0', [shop]);
    return response;
  }

  RealmResults<BankTransactions> getBakTransactions({required id}) {
    RealmResults<BankTransactions> response =
        realmService.realm.query<BankTransactions>(r'_id == $0', [id]);
    return response;
  }

  RealmResults<BankTransactions> CategoryHistory({required id}) {
    RealmResults<BankTransactions> response =
        realmService.realm.query<BankTransactions>(r'_id == $0', [id]);
    return response;
    // var response = await DbBase().databaseRequest(
    //     "${cashflow}" + "category/category/$id", DbBase().getRequestType);
    // var data = jsonDecode(response);
    // return data;
  }

  ediCategory({required Map<String, dynamic> body, required id}) async {
    var response = await DbBase().databaseRequest(
        "${cashflow}" + "category/$id", DbBase().patchRequestType,
        body: body);
    var data = jsonDecode(response);
    return data;
  }

  deleteCategory({ObjectId? id}) async {
    var response = await DbBase().databaseRequest(
        "${cashflow}" + "category/$id", DbBase().deleteRequestType);
    var data = jsonDecode(response);
    return data;
  }

  RealmResults<CashflowSummary> getCashFlowSummary(
      {required id, required from, required to}) {
    RealmResults<CashflowSummary> response =
        realmService.realm.query<CashflowSummary>(r'_id == $0', [id]);
    return response;
  }
}
