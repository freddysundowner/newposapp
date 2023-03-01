import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/category_controller.dart';
import 'package:flutterpos/models/bank_model.dart';
import 'package:get/get.dart';

import '../services/transactions.dart';
import '../widgets/loading_dialog.dart';

class CashflowController extends GetxController
    with GetTickerProviderStateMixin {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  RxList cashInCategories = RxList([]);
  RxList categories = RxList([]);
  RxBool loadingCashAtBank = RxBool(false);
  RxBool gettingBankName = RxBool(false);
  late TabController tabController;
  TextEditingController textEditingControllerBankName = TextEditingController();
  TextEditingController textEditingControllerName = TextEditingController();
  TextEditingController textEditingControllerAmount = TextEditingController();
  RxList<BankModel> cashAtBanks = RxList([]);

  fetchCashAtBank(shopId) async {
    try {
      loadingCashAtBank.value = true;
      var response = await Transactions().getCashAtBank(shopId);
      print(response);
      if (response["status"] == true) {
        List jsonData = response["body"];
        List<BankModel> fetchedData =
            jsonData.map((e) => BankModel.fromJson(e)).toList();
        cashAtBanks.assignAll(fetchedData);
      } else {
        cashAtBanks.value = [];
      }
      loadingCashAtBank.value = false;
    } catch (e) {
      loadingCashAtBank.value = false;
      print(e);
    }
  }

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  // void getBankNames() {}

  createBankNames({required shopId, required context}) async {
    try {
      Map<String, dynamic> body = {
        "name": textEditingControllerBankName.text,
        "category": Get.find<CategoryController>().selectedCategory.value!.id,
        "shop": shopId,
      };
      print(body);
      LoadingDialog.showLoadingDialog(
          context: context, key: _keyLoader, title: "adding bank");
      var response = await Transactions().createBank(body: body);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        textEditingControllerBankName.clear();
        getBankNames(shopId: shopId);
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      print(e);
    }
  }

  createTransaction({required shopId, required context, required type}) async {
    try {
      Map<String, dynamic> body = {
        "shop": shopId,
        "bankName":  type=="cashout"?"":textEditingControllerName.text,
        "amount": textEditingControllerAmount.text,
        "type": type,
        "cashFlow": Get.find<CategoryController>().selectedCategory.value!.id,
      };
      print(body);
      LoadingDialog.showLoadingDialog(
          context: context, key: _keyLoader, title: "Confirming");
      var response = await Transactions().createTransaction(body: body);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        clearInputs();
        Get.back();
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      print(e);
    }
  }

  getBankNames({required shopId}) async {
    try {
      gettingBankName.value = true;

      var response = await Transactions().getBankNames(shopId);
      print(response);
      // if (response != null) {
      //   // List fetchedData = response["body"];
      //   // List<BankModelBody> fetchedBankNames = fetchedData.map((e) => BankModelBody.fromJson(e)).toList();
      //   // selectedBank.value == ""
      //   //     ? selectedBank.value = fetchedBankNames[0].name!
      //   //     : selectedBank.value;
      //   // selectedId.value == ""
      //   //     ? selectedBankId.value = fetchedBankNames[0].id!
      //   //     : selectedBankId.value;
      //   // banksLists.assignAll(fetchedBankNames);
      // } else {
      //   banksLists.value = [];
      // }
      gettingBankName.value = false;
    } catch (e) {
      gettingBankName.value = false;
      print(e);
    }
  }

  clearInputs(){
    textEditingControllerName.clear();
    textEditingControllerAmount.clear();
    Get.find<CategoryController>().selectedCategory.value = null;
  }
}
