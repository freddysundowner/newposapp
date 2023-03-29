import 'package:flutter/material.dart';
import 'package:flutterpos/models/customer_model.dart';
import 'package:flutterpos/models/sales_order_item_model.dart';
import 'package:flutterpos/services/customer.dart';
import 'package:get/get.dart';

import '../models/product_model.dart';
import '../screens/customers/customers_page.dart';
import '../screens/product/create_product.dart';
import '../screens/sales/create_sale.dart';
import '../screens/stock/create_purchase.dart';
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
  TextEditingController amountController = TextEditingController();
  RxBool creatingCustomerLoad = RxBool(false);
  RxBool gettingCustomersLoad = RxBool(false);
  RxBool gettingCustomer = RxBool(false);
  RxBool customerPurchaseLoad = RxBool(false);
  RxList<CustomerModel> customers = RxList([]);
  RxList<SaleOrderItemModel> customerPurchases = RxList([]);
  Rxn<CustomerModel> customer = Rxn(null);

  RxString activeItem = RxString("All");
  RxString customerActiveItem = RxString("Credit");
  late TabController tabController;
  RxInt initialPage = RxInt(0);

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

  createCustomer(
      {required shopId, required BuildContext context, required page}) async {
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
        clearTexts();
        if (MediaQuery.of(context).size.width > 600) {
          if (page == "customersPage") {
            Get.find<HomeController>().selectedWidget.value =
                CustomersPage(type: "customers");
          }
          if (page == "createSale") {
            Get.find<HomeController>().selectedWidget.value = CreateSale();
          }
          if (page == "createProduct") {
            Get.find<HomeController>().selectedWidget.value = CreateProduct(
              page: "create",
              productModel: ProductModel(),
            );
          }
          if (page == "createPurchase") {
            Get.find<HomeController>().selectedWidget.value = CreatePurchase();
          }
        } else {
          Get.back();
        }
        await getCustomersInShop(shopId, "all");
      } else {
        showSnackBar(
            message: response["message"], color: Colors.red, context: context);
      }
      creatingCustomerLoad.value = false;
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      creatingCustomerLoad.value = false;
    }
  }

  getCustomersInShop(shopId, type) async {
    try {
      customers.clear();
      gettingCustomersLoad.value = true;
      var response = await Customer().getCustomersByShopId(shopId, type);
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

  assignTextFields(CustomerModel customerModel) {
    nameController.text = customerModel.fullName!;
    phoneController.text = customerModel.phoneNumber!;
    emailController.text = customerModel.email!;
    genderController.text = customerModel.gender!;
    addressController.text = customerModel.address!;
  }

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    super.onInit();
  }

  updateCustomer(context, String id) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: context, title: "Updating customer...", key: _keyLoader);
      Map<String, dynamic> body = {
        if (nameController.text != "") "fullName": nameController.text,
        if (phoneController.text != "") "phoneNumber": phoneController.text,
        if (genderController.text != "") "gender": genderController.text,
        if (emailController.text != "") "email": emailController.text,
        if (addressController.text != "") "address": addressController.text
      };
      var response = await Customer().updateCustomer(body: body, id: id);
      print(response);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        clearTexts();
        customer.value = CustomerModel.fromJson(response["body"]);
        int index = customers.indexWhere((element) => element.id == id);
        customers[index] = customer.value!;
        customers.refresh();
      } else {
        showSnackBar(
            message: response["message"],
            color: AppColors.mainColor,
            context: context);
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
        if (MediaQuery.of(context).size.width > 600) {
          Get.find<HomeController>().selectedWidget.value =
              CustomersPage(type: "customers");
        } else {
          Get.back();
        }
        clearTexts();
        await getCustomersInShop(shopId, "all");
      } else {
        showSnackBar(
            message: response["message"],
            color: AppColors.mainColor,
            context: context);
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }

  getCustomerPurchases(uid, type, String operation) async {
    try {
      customerPurchases.clear();
      customerPurchaseLoad.value = true;
      var response = await Customer().getPurchases(uid, type, operation);

      if (response["status"] == true) {
        customerPurchases.clear();
        List fetchedProducts = response["body"];
        List<SaleOrderItemModel> listProducts =
            fetchedProducts.map((e) => SaleOrderItemModel.fromJson(e)).toList();
        customerPurchases.assignAll(listProducts);
      } else {
        customerPurchases.value = [];
      }

      customerPurchaseLoad.value = false;
    } catch (e) {
      customerPurchaseLoad.value = false;
    }
  }
}
