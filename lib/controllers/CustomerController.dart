import 'package:flutter/material.dart';
import 'package:flutterpos/models/customer_model.dart';
import 'package:flutterpos/services/customer.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/snackBars.dart';

class CustomerController extends GetxController
    with SingleGetTickerProviderMixin {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  RxBool creatingCustomerLoad = RxBool(false);
  RxBool gettingCustomersLoad = RxBool(false);
  RxBool gettingCustomer = RxBool(false);
  RxList<CustomerModel> customers = RxList([]);
  RxList<CustomerModel> customersOnCredit = RxList([]);
  Rxn<CustomerModel> customer = Rxn(null);
  RxBool customerOnCreditLoad = RxBool(false);

  late TabController tabController;

  final List<Tab> tabs = <Tab>[
    Tab(
        child: Row(children: [
      Text(
        "Credit",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      )
    ])),
    Tab(
        child: Text(
      "Purchase",
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    )),
    Tab(
        child: Text(
      "Returns",
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    )),
  ];

  createCustomer({required shopId, required BuildContext context}) async {
    try {
      creatingCustomerLoad.value = true;
      LoadingDialog.showLoadingDialog(
          context: context, title: "Creating customer...", key: _keyLoader);
      Map<String, dynamic> body = {
        "fullName": nameController.text,
        "phoneNumber": phoneController.text,
        "shopId": shopId
      };
      var response = await Customer().createCustomer(body);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        await getCustomersInShop(shopId);
        clearTexts();
        Get.back();
        showSnackBar(message: response["message"], color: AppColors.mainColor);
      } else {
        showSnackBar(message: response["message"], color: Colors.red);
      }
      creatingCustomerLoad.value = false;
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      creatingCustomerLoad.value = false;
    }
  }

  getCustomersInShop(shopId) async {
    try {
      gettingCustomersLoad.value = true;
      var response = await Customer().getCustomersByShopId(shopId);
      if (response["status"] == true) {
        List fetchedCustomers = response["body"];
        List<CustomerModel> customerData =
            fetchedCustomers.map((e) => CustomerModel.fromJson(e)).toList();
        customers.assignAll(customerData);
      } else {
        customers.value = [];
      }
      gettingCustomersLoad.value = false;
    } catch (e) {
      gettingCustomersLoad.value = false;
    }
  }

  clearTexts() {
    nameController.text = "";
    phoneController.text = "";
    genderController.text = "";
    emailController.text = "";
    addressController.text = "";
    amountController.text = "";
  }

  void getCustomersOnCredit({String? shopId}) {}

  void getSuppliersOnCredit({String? shopId}) {}

  getCustomerById(id) async {
    try {
      gettingCustomer.value = true;
      var response = await Customer().getCustomersById(id);
      if (response["status"] == true) {
        customer.value = CustomerModel.fromJson(response["body"]);
      } else {
        customer.value = CustomerModel();
      }
      gettingCustomer.value = false;
    } catch (e) {
      gettingCustomer.value = false;
    }
  }

  void assignTextFields() {
    nameController.text = customer.value!.fullName!;
    phoneController.text = customer.value!.phoneNumber!;
    emailController.text = customer.value!.email!;
    genderController.text = customer.value!.gender!;
    addressController.text = customer.value!.address!;
  }

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    super.onInit();
  }

  updateCustomer(context, String? id) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: context, title: "Updating customer...", key: _keyLoader);
      Map<String, dynamic> body = {
        if (nameController.text != "") "fullName": nameController.text,
        "phoneNumber": phoneController.text,
        "gender": genderController.text,
        "email": emailController.text,
        "address": addressController.text
      };

      var response = await Customer().updateCustomer(body: body, id: id);

      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        showSnackBar(message: response["message"], color: AppColors.mainColor);
        clearTexts();
        await getCustomerById(id);
      } else {
        showSnackBar(message: response["message"], color: AppColors.mainColor);
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }

  deleteCustomer(
      {required BuildContext context, required id, required shopId}) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: context, title: "deleting customer...", key: _keyLoader);
      var response = await Customer().deleteCustomer(id: id);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        clearTexts();
        Get.back();
        showSnackBar(message: response["message"], color: AppColors.mainColor);
        await getCustomersInShop(shopId);
      } else {
        showSnackBar(message: response["message"], color: AppColors.mainColor);
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }
}
