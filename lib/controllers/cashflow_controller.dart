import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/screens/cash_flow/cash_flow_manager.dart';
import 'package:pointify/widgets/alert.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';
import '../Real/Models/schema.dart';
import '../services/transactions.dart';
import '../widgets/loading_dialog.dart';

class CashflowController extends GetxController
    with GetTickerProviderStateMixin {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  RxList<CashFlowCategory> cashFlowCategories = RxList([]);
  RxList<BankTransactions> bankTransactions = RxList([]);
  Rxn<CashFlowCategory> selectedCashFlowCategories = Rxn(null);
  Rxn<BankModel> selectedBank = Rxn(null);
  Rxn<CashflowSummary> cashflowSummary = Rxn(null);
  RxInt totalcashAtBank = RxInt(0);
  RxInt totalcashAtBankHistory = RxInt(0);
  RxInt cashflowTotal = RxInt(0);
  RxInt initialPage = RxInt(0);

  RxList categories = RxList([]);
  RxBool loadingCashAtBank = RxBool(false);
  RxBool gettingBankName = RxBool(false);
  RxBool loadingCashflowSummry = RxBool(false);
  RxBool loadingCashFlowCategories = RxBool(false);
  RxBool loadingBankTransactions = RxBool(false);
  RxBool loadingBankHistory = RxBool(false);
  var fromDate = DateTime.now().obs;
  var toDate = DateTime.now().obs;
  late TabController tabController;
  TextEditingController textEditingControllerBankName = TextEditingController();
  TextEditingController textEditingControllerName = TextEditingController();
  TextEditingController textEditingControllerAmount = TextEditingController();
  RxList<BankModel> cashAtBanks = RxList([]);

  TextEditingController textEditingControllerCategory = TextEditingController();

  fetchCashAtBank(shopId) async {
    try {
      loadingCashAtBank.value = true;
      totalcashAtBank.value = 0;
      RealmResults<BankModel> response =
          await Transactions().getCashAtBank(shopId);

      if (response.isNotEmpty) {
        List<BankModel> fetchedData = response.map((e) => e).toList();
        cashAtBanks.assignAll(fetchedData);
        for (int i = 0; i < cashAtBanks.length; i++) {
          totalcashAtBank.value += cashAtBanks[i].amount!;
        }
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

  createBankNames({required shopId, required context}) async {
    try {
      Map<String, dynamic> body = {
        "name": textEditingControllerBankName.text,
        "category": selectedCashFlowCategories.value!.id,
        "shop": shopId,
      };

      LoadingDialog.showLoadingDialog(
          context: context, key: _keyLoader, title: "adding bank");
      var response = await Transactions().createBank(body: body);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        textEditingControllerBankName.clear();
        fetchCashAtBank(shopId);
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      print(e);
    }
  }

  createTransaction({
    required shopId,
    required context,
    required type,
    DateTime? date,
  }) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: context, key: _keyLoader, title: "Confirming");
      Map<String, dynamic> body = {
        "shop": shopId,
        "bank": selectedBank.value == null ? "" : selectedBank.value!.id,
        "amount": textEditingControllerAmount.text,
        "type": type,
        "from": date != null ? DateFormat("yyyy-MM-dd").format(date) : "",
        "category": selectedCashFlowCategories.value!.id,
      };
      var response = await Transactions().createTransaction(body: body);
      print(response);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        selectedBank.value = null;
        if (MediaQuery.of(context).size.width > 600) {
          Get.find<HomeController>().selectedWidget.value = CashFlowManager();
        } else {
          Get.back();
        }
        clearInputs();
        getSalesSummary(
          shopId: shopId,
          from: DateFormat("yyyy-MM-dd").format(date!),
          to: DateFormat("yyyy-MM-dd").format(date),
        );
      } else {
        generalAlert(title: "Error", message: response["message"]);
      }
    } catch (e) {
      print(e);
      generalAlert(title: "Error", message: e.toString());
    }
  }

  clearInputs() {
    textEditingControllerName.clear();
    textEditingControllerAmount.clear();
  }

  void createCategory(type) async {
    CashFlowCategory cashFlowCategory = CashFlowCategory(ObjectId(),
        name: textEditingControllerCategory.text,
        shop: Get.find<ShopController>().currentShop.value!.id.toString(),
        type: type);
    await Transactions().createCategory(cashFlowCategory);
    getCategory(
        type, Get.find<ShopController>().currentShop.value!.id.toString());
  }

  void getCategory(type, shopId) {
    RealmResults<CashFlowCategory> response =
        Transactions().getCategory(shop: shopId, type: type);
    if (response.isNotEmpty) {
      List<CashFlowCategory> cashflowCat = response.map((e) => e).toList();
      cashFlowCategories.assignAll(cashflowCat);
      // getCategoriesTotal();
    } else {
      cashFlowCategories.value = [];
    }
  }

  void getBankTransactions(id) async {
    try {
      loadingBankHistory.value = true;
      totalcashAtBankHistory.value = 0;
      RealmResults<BankTransactions> response =
          await Transactions().getBakTransactions(id: id);
      if (response.isNotEmpty) {
        List<BankTransactions> cashflowCat = response.map((e) => e).toList();
        bankTransactions.assignAll(cashflowCat);
        for (int i = 0; i < bankTransactions.length; i++) {
          totalcashAtBankHistory.value += bankTransactions[i].amount!;
        }
      } else {
        bankTransactions.value = [];
      }
      loadingBankHistory.value = false;
    } catch (e) {
      loadingBankHistory.value = false;
      print(e);
    }
  }

  getCategoryHistory(id) async {
    try {
      loadingBankHistory.value = true;
      totalcashAtBankHistory.value = 0;
      RealmResults<BankTransactions> response =
          await Transactions().CategoryHistory(id: id);
      if (response.isNotEmpty) {
        List<BankTransactions> cashflowCat = response.map((e) => e).toList();
        bankTransactions.assignAll(cashflowCat);
        for (int i = 0; i < bankTransactions.length; i++) {
          totalcashAtBankHistory.value += bankTransactions[i].amount!;
        }
      } else {
        bankTransactions.value = [];
      }
      loadingBankHistory.value = false;
    } catch (e) {
      loadingBankHistory.value = false;
      print(e);
    }
  }

  void editCategory(id) async {
    try {
      Map<String, dynamic> body = {"name": textEditingControllerCategory.text};
      var response = await Transactions().ediCategory(body: body, id: id);
      if (response["status"] == true) {
        int index =
            cashFlowCategories.indexWhere((element) => element.id == id);
        cashFlowCategories[index].name = textEditingControllerCategory.text;
        cashFlowCategories.refresh();
        textEditingControllerCategory.clear();
      }
    } catch (e) {
      print(e);
    }
  }

  deleteCategory(ObjectId? id) async {
    try {
      var response = await Transactions().deleteCategory(id: id);
      if (response["status"] == true) {
        cashFlowCategories.removeWhere((element) => element.id == id);
        cashFlowCategories.refresh();
        getCategoriesTotal();
      }
    } catch (e) {
      print(e);
    }
  }

  void getCategoriesTotal() {
    cashflowTotal.value = 0;
    for (int i = 0; i < cashFlowCategories.length; i++) {
      cashflowTotal.value += cashFlowCategories[i].amount!;
    }
  }

  getSalesSummary({required shopId, required from, required to}) async {
    try {
      loadingCashflowSummry.value = true;
      RealmResults<CashflowSummary> response = await Transactions()
          .getCashFlowSummary(id: shopId, from: from, to: to);
      if (response.isNotEmpty) {
        cashflowSummary.value = response.first;
      } else {
        cashflowSummary.value = null;
      }
      loadingCashflowSummry.value = false;
    } catch (e) {
      loadingCashflowSummry.value = false;
      print(e);
    }
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
