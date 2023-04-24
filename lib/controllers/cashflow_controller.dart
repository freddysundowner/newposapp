import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/bank_model.dart';
import 'package:flutterpos/models/cashflow_category.dart';
import 'package:flutterpos/screens/cash_flow/cash_flow_manager.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../models/bank_transactions.dart';
import '../models/cashflow_summary.dart';
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
  var currentDate = DateTime.now().obs;
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
      var response = await Transactions().getCashAtBank(shopId);

      if (response["status"] == true) {
        List jsonData = response["body"];
        List<BankModel> fetchedData =
            jsonData.map((e) => BankModel.fromJson(e)).toList();
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

  createTransaction({required shopId, required context, required type}) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: context, key: _keyLoader, title: "Confirming");
      Map<String, dynamic> body = {
        "shop": shopId,
        "bank": selectedBank.value == null ? "" : selectedBank.value!.id,
        "amount": textEditingControllerAmount.text,
        "type": type,
        "category": selectedCashFlowCategories.value!.id,
      };
      var response = await Transactions().createTransaction(body: body);

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
            date: DateFormat("yyyy-MM-dd").format(currentDate.value));
      }
    } catch (e) {
      print(e);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }

  clearInputs() {
    textEditingControllerName.clear();
    textEditingControllerAmount.clear();
  }

  getCashFlowTransactions() {}

  void showDatePicker({required context}) {
    DatePicker.showDatePicker(context,
        showTitleActions: true,
        minTime: DateTime(1990, 5, 5, 20, 50),
        maxTime: DateTime.now(),
        theme: DatePickerTheme(
            itemStyle: TextStyle(color: AppColors.mainColor),
            cancelStyle: TextStyle(color: AppColors.lightDeepPurple),
            doneStyle: TextStyle(color: AppColors.mainColor)),
        onConfirm: (date) {
      currentDate.value = date;
      getSalesSummary(
          shopId: Get.find<ShopController>().currentShop.value!.id,
          date: DateFormat("yyyy-MM-dd").format(currentDate.value));
    }, locale: LocaleType.en);
  }

  void createCategory(type, shopId, context) async {
    try {
      Map<String, dynamic> body = {
        "type": type,
        "name": textEditingControllerCategory.text,
        "shop": shopId,
        "admin":Get.find<AuthController>().currentUser.value!.id
      };
      print(body);

      var response = await Transactions().createCategory(body: body);
      print(response);
      if (response["status"] == true) {
        textEditingControllerCategory.clear();
        getCategory(type, shopId);
      } else {
        showSnackBar(
            message: response["message"], color: Colors.red, context: context);
      }
    } catch (e) {
      print(e);
    }
  }

  void getCategory(type, shopId) async {
    try {
      loadingCashFlowCategories.value = true;
      cashflowTotal.value = 0;
      var response = await Transactions().getCategory(shop: shopId, type: type);
      if (response["status"] == true) {
        List dataResponse = response["body"];
        List<CashFlowCategory> cashflowCat =
            dataResponse.map((e) => CashFlowCategory.fromJson(e)).toList();
        cashFlowCategories.assignAll(cashflowCat);
        getCategoriesTotal();
      } else {
        cashFlowCategories.value = [];
      }
      loadingCashFlowCategories.value = false;
    } catch (e) {
      loadingCashFlowCategories.value = false;
      print(e);
    }
  }

  void getBankTransactions(id) async {
    try {
      loadingBankHistory.value = true;
      totalcashAtBankHistory.value = 0;
      var response = await Transactions().getBakTransactions(id: id);
      if (response["status"] == true) {
        List dataResponse = response["body"];
        List<BankTransactions> cashflowCat =
            dataResponse.map((e) => BankTransactions.fromJson(e)).toList();
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
      var response = await Transactions().getCategoryHistory(id: id);
      if (response["status"] == true) {
        List dataResponse = response["body"];
        List<BankTransactions> cashflowCat =
            dataResponse.map((e) => BankTransactions.fromJson(e)).toList();
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

  deleteCategory(String? id) async {
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

  getSalesSummary({required shopId, required date}) async {
    try {
      loadingCashflowSummry.value = true;
      var response =
          await Transactions().getCashFlowSummary(id: shopId, date: date);
      print(response);
      if (response != null) {
        cashflowSummary.value = CashflowSummary.fromJson(response);
      } else {
        cashflowSummary.value = null;
      }
      loadingCashflowSummry.value = false;
    } catch (e) {
      loadingCashflowSummry.value = false;
      print(e);
    }
  }
}
