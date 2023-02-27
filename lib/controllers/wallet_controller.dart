import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/CustomerController.dart';
import 'package:get/get.dart';

import '../models/deposit_model.dart';
import '../services/wallet.dart';
import '../widgets/loading_dialog.dart';

class WalletController extends GetxController with GetTickerProviderStateMixin {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  RxBool gettingUsageLoad = RxBool(false);
  RxBool gettingWalletLoad = RxBool(false);
  RxBool createWalletLoad = RxBool(false);
  RxBool updateWalletLoad = RxBool(false);
  RxList usages = RxList([]);
  RxList deposits = RxList([]);

  late TabController tabController;

  TextEditingController amountController = TextEditingController();

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  void save(uid, context) async {
    if (amountController.text == "") {
      Get.snackbar("", "Please enter a valid amount ");
    } else {
      try {
        LoadingDialog.showLoadingDialog(
            context: context,
            title: "Depositing for customer",
            key: _keyLoader);
        Map<String, dynamic> body = {
          "amount": amountController.text,
          "customerId": uid,
          "type": "deposit"
        };
        var response = await Wallet().createWallet(body);
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        print("Wallet deposit${response}");
        if (response["ststus"] == true) {
          await Get.find<CustomerController>().getCustomerById(uid);
          amountController.text = "";
          await getWallet(uid);
        }
      } catch (e) {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        print(e);
      }
    }
  }

  getWallet(uid) async {
    try {
      gettingWalletLoad.value = true;
      var response = await Wallet().getWallet(uid);
      print(response);
      if (response != null) {
        List fetchedData = response["body"];
        List<DepositModel> data = fetchedData.map((e) => DepositModel.fromJson(e)).toList();
        deposits.assignAll(data);
      } else {
        deposits.value = [];
      }
      gettingWalletLoad.value = false;
    } catch (e) {
      gettingWalletLoad.value = false;
      print(e);
    }
  }

  getWalletUsage(uid) async {
    try {
      gettingUsageLoad.value = true;
      var response = await Wallet().getusage(uid);
      if (response != null) {
        List fetchedData = response["body"];
        List<DepositModel> data =
            fetchedData.map((e) => DepositModel.fromJson(e)).toList();
        usages.assignAll(data);
      } else {
        usages.value = [];
      }
      gettingUsageLoad.value = false;
    } catch (e) {
      gettingUsageLoad.value = false;
      print(e);
    }
  }

  updateWallet({required amount, required id, required uid}) async {
    try {
      updateWalletLoad.value = true;
      Map<String, dynamic> body = {"amount": amount, "customerId": uid};
      var response = await Wallet().updateWallet(id, body);
      await Get.find<CustomerController>().getCustomerById(uid);
      await getWallet(uid);
      updateWalletLoad.value = false;
    } catch (e) {
      updateWalletLoad.value = false;
      print(e);
    }
  }
}
