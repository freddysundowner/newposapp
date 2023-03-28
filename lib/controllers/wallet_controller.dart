import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/CustomerController.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/screens/sales/create_sale.dart';
import 'package:get/get.dart';

import '../models/deposit_model.dart';
import '../services/wallet.dart';
import '../widgets/loading_dialog.dart';

class WalletController extends GetxController with GetTickerProviderStateMixin {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  RxBool gettingWalletLoad = RxBool(false);
  RxBool createWalletLoad = RxBool(false);
  RxBool updateWalletLoad = RxBool(false);
  RxList<DepositModel> deposits = RxList([]);
  late TabController tabController;

  TextEditingController amountController = TextEditingController();

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  void save(uid, context, page) async {
    if (amountController.text == "") {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Please enter a valid amount")));
    } else {
      try {
        LoadingDialog.showLoadingDialog(
            context: context,
            title: "Depositing for customer",
            key: _keyLoader);

        Map<String, dynamic> body = {
          "amount": amountController.text,
          "shop": Get.find<ShopController>().currentShop.value!.id!,
        };
        var response = await Wallet().createWallet(body, uid);
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        if (response["status"] == true) {
          amountController.text = "";
          await Get.find<CustomerController>().getCustomerById(uid);
          if (page != null) {
            if (page == "small") {
              Get.back();
            } else {
              Get.find<HomeController>().selectedWidget.value = CreateSale();
            }
          }

          await getWallet(uid, "deposit");
        }

      } catch (e) {
        print(e);
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      }
    }
  }

  getWallet(uid, type) async {
    try {
      gettingWalletLoad.value = true;
      var response = await Wallet().getWallet(uid, type);

      if (response != null) {
        List fetchedData = response;
        List<DepositModel> data =
            fetchedData.map((e) => DepositModel.fromJson(e)).toList();
        deposits.assignAll(data);
      } else {
        deposits.value = [];
      }
      gettingWalletLoad.value = false;
    } catch (e) {
      print(e);
      gettingWalletLoad.value = false;
    }
  }

  updateWallet({required amount, required id, required uid}) async {
    try {
      updateWalletLoad.value = true;
      Map<String, dynamic> body = {"amount": amount, "customerId": uid};
      var response = await Wallet().updateWallet(id, body);

      await Get.find<CustomerController>().getCustomerById(uid);
      // await getWallet(uid);
      updateWalletLoad.value = false;
    } catch (e) {
      updateWalletLoad.value = false;
    }
  }
}
