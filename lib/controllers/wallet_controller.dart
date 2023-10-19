import 'package:flutter/material.dart';
import 'package:pointify/controllers/CustomerController.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:get/get.dart';
import 'package:pointify/services/customer.dart';
import 'package:realm/realm.dart';
import '../Real/schema.dart';
import '../functions/functions.dart';
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

  deposit(CustomerModel customerModel, context, page, size) async {
    if (amountController.text == "") {
      generalAlert(title: "Error", message: "Please enter a valid amount");
    } else {
      LoadingDialog.showLoadingDialog(
          context: context, title: "Depositing for customer", key: _keyLoader);
      WalletTransaction(
          customerModel: customerModel,
          amount: int.parse(amountController.text),
          type: "deposit");
      Get.find<CustomerController>().getCustomerById(customerModel);
      Get.find<CustomerController>().customer.refresh();
      Navigator.of(context, rootNavigator: true).pop();
      getWallet(customerModel, "deposit");

    }
  }

  void WalletTransaction(
      {required CustomerModel customerModel,
      required int amount,
      required String type,
      SalesModel? salesModel,
      int? newbalance}) {
    DepositModel depositModel = DepositModel(ObjectId(),
        customer: customerModel,
        recieptNumber: getRandomString(10),
        attendant: Get.find<UserController>().user.value,
        createdAt: DateTime.now(),
        type: type,
        date: DateTime.now().millisecondsSinceEpoch,
        receipt: salesModel,
        amount: amount);

    Wallet().deposit(depositModel);
    if (type == "deposit") {
      Customer().updateCustomerWalletbalance(customerModel,
          amount: (customerModel.walletBalance ?? 0) + (newbalance ?? amount));
    } else if (type == "usage") {
      var a = (newbalance ?? amount);
     var b  = (customerModel.walletBalance ?? 0 ) -a;
      Customer().updateCustomerWalletbalance(customerModel,
          amount: b);
    }
  }

  getWallet(CustomerModel customerModel, type) {
    try {
      deposits.clear();
      RealmResults<DepositModel> response =
          Wallet().getWallet(customerModel, type);
      deposits.addAll(response.map((e) => e).toList());
    } catch (e) {
      print(e);
      gettingWalletLoad.value = false;
    }
  }
}
