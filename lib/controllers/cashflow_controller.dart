import 'package:flutter/material.dart';
import 'package:pointify/controllers/CustomerController.dart';
import 'package:pointify/controllers/expense_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/screens/cash_flow/cash_flow_manager.dart';
import 'package:pointify/widgets/alert.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';
import '../Real/Models/schema.dart';
import '../services/transactions.dart';
import '../services/users.dart';
import '../widgets/loading_dialog.dart';

class CashflowController extends GetxController
    with GetTickerProviderStateMixin {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  RxList<CashFlowCategory> cashFlowCategories = RxList([]);
  // RxList<CashFlowCategory> cashOutGroups = RxList([]);
  // RxList<BankTransactions> bankTransactions = RxList([]);
  RxList<CashFlowTransaction> cashflowTransactions = RxList([]);
  RxList<CashFlowTransaction> categoryCashflowTransactions = RxList([]);
  RxList<CashFlowTransaction> cashOutflowOtherTransactions = RxList([]);
  RxList<CashFlowTransaction> cashInflowOtherTransactions = RxList([]);
  RxList<CashFlowTransaction> cashflowOtherTransactions = RxList([]);
  Rxn<CashFlowCategory> selectedcashOutGroups = Rxn(null);
  Rxn<CashFlowCategory> selectedcashFlowCategory = Rxn(null);
  Rxn<BankModel> selectedBank = Rxn(null);
  RxInt totalcashAtBank = RxInt(0);
  RxInt totalcashAtBankHistory = RxInt(0);
  RxInt cashflowTotal = RxInt(0);
  RxInt initialPage = RxInt(0);

  RxInt purchasedItemsTotal = RxInt(0);
  RxInt cashatHand = RxInt(0);
  RxInt totalCashIn = RxInt(0);
  RxInt totalCashOut = RxInt(0);
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

  fetchCashAtBank() {
    totalcashAtBank.value = 0;
    RealmResults<BankModel> response = Transactions().getCashAtBank();

    print("vvv ${response.length}");
    if (response.isNotEmpty) {
      List<BankModel> fetchedData = response.map((e) => e).toList();
      cashAtBanks.assignAll(fetchedData);
      for (int i = 0; i < cashAtBanks.length; i++) {
        totalcashAtBank.value += cashAtBanks[i].amount!;
      }
    } else {
      cashAtBanks.value = [];
    }
  }

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }

  createBankNames() {
    try {
      BankModel bankModel = BankModel(
        ObjectId(),
        shop: Get.find<ShopController>().currentShop.value!.id.toString(),
        name: textEditingControllerBankName.text,
      );
      var response =
          Transactions().getBankByName(textEditingControllerBankName.text);
      print("response ${response.length}");
      if (response.isNotEmpty) {
        generalAlert(
            title: "Error", message: "${bankModel.name} already exists");
      } else {
        Transactions().createBank(bankModel);
        fetchCashAtBank();
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      print(e);
    }
  }

  createTransaction({
    required type,
  }) async {
    var amount = int.parse(textEditingControllerAmount.text);
    CashFlowTransaction cashFlowTransaction = CashFlowTransaction(ObjectId(),
        shop: Get.find<ShopController>().currentShop.value,
        amount: amount,
        description: textEditingControllerName.text,
        cashFlowCategory: selectedcashOutGroups.value,
        bank: selectedcashOutGroups.value!.key! == "bank"
            ? selectedBank.value!
            : null,
        type: type,
        date: DateTime.now().millisecondsSinceEpoch);

    if (selectedcashOutGroups.value != null &&
        selectedcashOutGroups.value!.key! == "bank") {
      Transactions().updateBank(
          bankModel: selectedBank.value!,
          amount: (selectedBank.value!.amount ?? 0) + amount);
    }
    Transactions().updateCashFlowCategory(
        cashFlowCategory: selectedcashOutGroups.value!,
        amount: (selectedcashOutGroups.value!.amount ?? 0) + amount);
    Transactions().createTransaction(cashFlowTransaction);
    getCashFlowTransactions(
      fromDate: DateTime.parse(DateFormat("yyyy-MM-dd").format(fromDate.value)),
      toDate: DateTime.parse(DateFormat("yyyy-MM-dd").format(toDate.value))
          .add(const Duration(days: 1)),
    );
    Get.back();
    textEditingControllerAmount.clear();
  }

  clearInputs() {
    textEditingControllerName.clear();
    textEditingControllerAmount.clear();
  }

  void createCategory(type) async {
    CashFlowCategory cashFlowCategory = CashFlowCategory(ObjectId(),
        name: textEditingControllerCategory.text,
        shop: Get.find<ShopController>().currentShop.value!.id.toString(),
        type: type,
        amount: 0,
        key: textEditingControllerCategory.text.toLowerCase().trim());
    await Transactions().createCategory(cashFlowCategory);
    getCategory(type);
  }

  void getCategory(type) {
    RealmResults<CashFlowCategory> response =
        Transactions().getCategory(type: type);
    if (response.isNotEmpty) {
      List<CashFlowCategory> cashflowCat = response.map((e) => e).toList();
      cashFlowCategories.assignAll(cashflowCat);
      // getCategoriesTotal();
    } else {
      cashFlowCategories.value = [];
    }
  }

  getCategoryHistory(CashFlowCategory cashFlowCategory,
      {BankModel? bankModel}) async {
    RealmResults<CashFlowTransaction> response = Transactions().CategoryHistory(
        cashFlowCategory: cashFlowCategory, bankModel: bankModel);
    List<CashFlowTransaction> cashflowCat = response.map((e) => e).toList();
    categoryCashflowTransactions.assignAll(cashflowCat);
  }

  getCashFlowTransactions({
    String? group,
    String? type,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    totalcashAtBankHistory.value = 0;
    cashflowTransactions.clear();
    cashInflowOtherTransactions.clear();
    cashOutflowOtherTransactions.clear();
    RealmResults<CashFlowTransaction> response = Transactions()
        .getCashFlowTransaction(
            group: group, type: type, fromDate: fromDate, toDate: toDate);
    List<CashFlowTransaction> cashflowCat = response.map((e) => e).toList();
    cashflowTransactions.assignAll(cashflowCat);
    List<CashFlowTransaction> bankTrans = [];
    for (var element in cashflowTransactions) {
      if (element.bank != null) {
        bankTrans.add(element);
      } else {
        if (element.type == "cash-out") {
          cashOutflowOtherTransactions.add(element);
        } else if (element.type == "cash-in") {
          cashInflowOtherTransactions.add(element);
        }
        cashflowOtherTransactions.add(element);
      }
    }
    totalcashAtBankHistory.value = bankTrans.fold(
        0, (previousValue, element) => previousValue + element.amount!);
  }

  void editCategory(CashFlowCategory cashFlowCategory) {
    try {
      Transactions().updateCashFlowCategory(
          cashFlowCategory: cashFlowCategory,
          name: textEditingControllerCategory.text);
      int index = cashFlowCategories
          .indexWhere((element) => element.id == cashFlowCategory.id);
      cashFlowCategories[index].name = textEditingControllerCategory.text;
      cashFlowCategories.refresh();
      textEditingControllerCategory.clear();
    } catch (e) {
      print(e);
    }
  }

  deleteCategory(CashFlowCategory? cashFlowCategory) async {
    try {
      cashFlowCategories
          .removeWhere((element) => element.id == cashFlowCategory!.id);

      cashflowTransactions.removeWhere(
          (element) => element.cashFlowCategory!.id == cashFlowCategory!.id);
      // cashFlowCategories.refresh();
      Transactions().deleteCategory(cashFlowCategory: cashFlowCategory);
      // getCategory(cashFlowCategory!.type);
    } catch (e) {
      print(e);
    }
  }

  getCashflowSummary({required shopId, required from, required to}) async {
    SalesController salesController = Get.find<SalesController>();
    ExpenseController expenseController = Get.find<ExpenseController>();
    PurchaseController purchaseController = Get.find<PurchaseController>();
    salesController.getProfitTransaction(fromDate: from, toDate: to);
    purchaseController.getPurchase(fromDate: from, toDate: to, onCredit: false);

    purchasedItemsTotal.value = purchaseController.purchasedItems
        .fold(0, (previousValue, element) => previousValue + element.total!);
    Get.find<CustomerController>()
        .getCustomerWallets(debtors: true, fromDate: from, toDate: to);
    Get.find<CustomerController>()
        .getCustomerWallets(debtors: false, fromDate: from, toDate: to);
    getCashFlowTransactions(fromDate: from, toDate: to);

    totalCashIn.value = salesController.allSalesTotal.value! +
        cashInflowOtherTransactions.fold(
            0, (previousValue, element) => previousValue + element.amount!);

    totalCashOut.value = totalcashAtBankHistory.value +
        expenseController.totalExpenses.value +
        purchaseController.purchasedTotal.value +
        cashOutflowOtherTransactions.fold(
            0, (previousValue, element) => previousValue + element.amount!);
    cashatHand.value = totalCashIn.value - totalCashOut.value;
  }

  @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }
}
