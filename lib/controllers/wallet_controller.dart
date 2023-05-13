import 'package:flutter/material.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/CustomerController.dart';
import 'package:pointify/controllers/attendant_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/screens/sales/create_sale.dart';
import 'package:get/get.dart';

import '../models/deposit_model.dart';
import '../services/wallet.dart';
import '../widgets/alert.dart';
import '../widgets/loading_dialog.dart';

class WalletController extends GetxController with GetTickerProviderStateMixin {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  RxBool gettingWalletLoad = RxBool(false);
  RxBool createWalletLoad = RxBool(false);
  RxBool updateWalletLoad = RxBool(false);
  RxList<DepositModel> deposits = RxList([]);
  late TabController tabController;
  RxInt initialPage = RxInt(0);

  TextEditingController amountController = TextEditingController();

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  save(uid, context, page, size) async {
    if (amountController.text == "") {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please enter a valid amount")));
    } else {
      try {
        LoadingDialog.showLoadingDialog(
            context: context,
            title: "Depositing for customer",
            key: _keyLoader);

        Map<String, dynamic> body = {
          "amount": amountController.text,
          "shop": Get.find<ShopController>().currentShop.value!.id!,
          "attendant": Get.find<AttendantController>().attendant.value != null
              ? Get.find<AttendantController>().attendant.value?.id
              : Get.find<AuthController>().currentUser.value?.id,
        };
        var response = await Wallet().createWallet(body, uid);
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        if (response["status"] == true) {
          amountController.text = "";
          await Get.find<CustomerController>().getCustomerById(uid);
          if (page != null) {
            if (size == "small") {
              Get.back();
            } else {
              Get.find<HomeController>().selectedWidget.value = CreateSale();
            }
          }

          await getWallet(uid, "deposit");
        } else {
          generalAlert(title: "Error", message: response["message"]);
        }
      } catch (e) {
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
    print("updateWallet");
    try {
      updateWalletLoad.value = true;
      Map<String, dynamic> body = {"amount": amount, "customerId": uid};
      var response = await Wallet().updateWallet(id, body);
      print(response);
      return response;

      // await Get.find<CustomerController>().getCustomerById(uid);
      // await getWallet(uid, "deposit");
      // updateWalletLoad.value = false;
    } catch (e) {
      print(e);
      updateWalletLoad.value = false;
    }
  }
}
