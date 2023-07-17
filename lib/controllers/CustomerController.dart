import 'package:flutter/material.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/services/customer.dart';
import 'package:get/get.dart';
import 'package:pointify/services/sales.dart';
import 'package:pointify/widgets/alert.dart';
import 'package:realm/realm.dart';

import '../Real/schema.dart';
import '../screens/customers/customers_page.dart';
import '../screens/product/create_product.dart';
import '../screens/sales/create_sale.dart';
import '../screens/purchases/create_purchase.dart';
import '../utils/colors.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/snackBars.dart';
import 'home_controller.dart';

class CustomerController extends GetxController
    with SingleGetTickerProviderMixin {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController amountpaid = TextEditingController();
  TextEditingController amountController = TextEditingController();
  RxBool creatingCustomerLoad = RxBool(false);
  RxBool gettingCustomersLoad = RxBool(false);
  RxBool loadingcustomerReturns = RxBool(false);
  RxBool gettingCustomer = RxBool(false);
  RxBool customerPurchaseLoad = RxBool(false);
  RxList<CustomerModel> customers = RxList([]);
  RxList<SalesModel> customerSales = RxList([]);
  Rxn<CustomerModel> customer = Rxn(null);
  RxInt walletDebtsTotal = RxInt(0);
  RxInt walletbalancessTotal = RxInt(0);

  RxString activeItem = RxString("All");
  RxString customerActiveItem = RxString("Credit");

  createCustomer({required page, Function? function}) async {
    try {
      creatingCustomerLoad.value = true;
      LoadingDialog.showLoadingDialog(
          context: Get.context!,
          title: "Creating customer...",
          key: _keyLoader);
      CustomerModel customerModel = CustomerModel(ObjectId(),
          fullName: nameController.text,
          phoneNumber: phoneController.text,
          createdAt: DateTime.now(),
          shopId: Get.find<ShopController>().currentShop.value);
      Customer().createCustomer(customerModel);
      Navigator.of(Get.context!, rootNavigator: true).pop();
      clearTexts();
      if (!isSmallScreen(Get.context)) {
        print("page is hello the page is${page}");
        if (page == "customersPage") {
          Get.find<HomeController>().selectedWidget.value = CustomersPage();

        }
        if (page == "createSale") {
          function!();
          // Get.find<HomeController>().selectedWidget.value = CreateSale();
        }
        if (page == "createProduct") {
          Get.find<HomeController>().selectedWidget.value = CreateProduct(
            page: "create",
            productModel: null,
          );
        }
        if (page == "createPurchase") {
          Get.find<HomeController>().selectedWidget.value = CreatePurchase();
        }
      } else {
        Get.back();
      }
      creatingCustomerLoad.value = false;
    } catch (e) {
      print(e);
      Navigator.of(Get.context!, rootNavigator: true).pop();
      creatingCustomerLoad.value = false;
    }
  }

  getCustomersInShop(type) {
    try {
      customers.clear();
      RealmResults<CustomerModel> customerresponse = Customer()
          .getCustomersByShopId(
              type, Get.find<ShopController>().currentShop.value!);
      customers.assignAll(customerresponse.map((e) => e).toList());
    } catch (e) {}
  }

  clearTexts() {
    nameController.text = "";
    phoneController.text = "";
    genderController.text = "";
    emailController.text = "";
    addressController.text = "";
    amountController.text = "";
  }

  getCustomerById(CustomerModel customerModel) async {
    CustomerModel response = Customer().getCustomersById(customerModel);
    customer.value = response;
    refresh();
  }

  getCustomerWallets({
    bool debtors = false,
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    RealmResults<DepositModel> response = Customer().getCustomerWallets(
        debtors: debtors, fromDate: fromDate, toDate: toDate);
    walletDebtsTotal.value = 0;
    walletbalancessTotal.value = 0;
    if (debtors) {
      walletDebtsTotal.value = response.fold(
          0, (previousValue, element) => previousValue + element.amount!);
    } else {
      walletbalancessTotal.value = response.fold(
          0,
          (previousValue, element) =>
              previousValue +
              (element.customer!.walletBalance! < 0
                  ? 0
                  : element.customer!.walletBalance!));
    }

    refresh();
  }

  assignTextFields(CustomerModel customerModel) {
    nameController.text = customerModel.fullName ?? "";
    phoneController.text = customerModel.phoneNumber ?? "";
    emailController.text = customerModel.email ?? "";
    genderController.text = customerModel.gender ?? "";
    addressController.text = customerModel.address ?? "";
  }

  updateCustomer(context, CustomerModel customerModel) async {
    try {
      CustomerModel customer = CustomerModel(customerModel.id,
          fullName: nameController.text,
          phoneNumber: phoneController.text,
          gender: genderController.text,
          walletBalance: customerModel.walletBalance ?? 0,
          shopId: customerModel.shopId,
          email: emailController.text,
          address: addressController.text);
      Customer().updateCustomer(customer);

      Navigator.of(context, rootNavigator: true).pop();
    } catch (e) {
      Navigator.of(context, rootNavigator: true).pop();
    }
  }

  deleteCustomer(CustomerModel customerModel) {
    try {
      if (customerModel.walletBalance != null &&
          customerModel.walletBalance! < 0) {
        generalAlert(
            title: "Erro", message: "You cannot delete customer with debt");
        return;
      }
      LoadingDialog.showLoadingDialog(
          context: Get.context!,
          title: "deleting customer...",
          key: _keyLoader);
      Customer().deleteCustomer(customerModel: customerModel);
      Get.back();
      Get.back();
    } catch (e) {
      Navigator.of(Get.context!, rootNavigator: true).pop();
    }
  }
}
