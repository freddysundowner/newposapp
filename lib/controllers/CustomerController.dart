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
  RxBool customerReturnsLoad = RxBool(false);
  RxBool gettingCustomer = RxBool(false);
  RxBool customerPurchaseLoad = RxBool(false);
  RxList<CustomerModel> customers = RxList([]);
  RxList<SaleOrderItemModel> customerPurchases = RxList([]);
  RxList<SaleOrderItemModel> customerReturns = RxList([]);
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
        Get.back();
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

  assignTextFields() {
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
        clearTexts();
        await getCustomerById(id);
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

  getCustomerPurchases(uid, type) async {
    try {
      customerPurchaseLoad.value = true;
      var response = await Customer().getPurchases(uid, type);
      if (response["status"] == true) {
        customerPurchases.clear();
        List fetchedProducts = response["body"];
        List<SaleOrderItemModel> listProducts =
            fetchedProducts.map((e) => SaleOrderItemModel.fromJson(e)).toList();
        for (var i = 0; i < listProducts.length; i++) {
          if (listProducts[i].returned != true) {
            customerPurchases.add(listProducts[i]);
          }
        }
      } else {
        customerPurchases.value = [];
      }

      customerPurchaseLoad.value = false;
    } catch (e) {
      customerPurchaseLoad.value = false;
    }
  }

  getCustomerReturns(uid) async {
    try {
      customerReturnsLoad.value = true;
      var response = await Customer().getReturns(uid);
      if (response != null) {
        List fetchedProducts = response["body"];
        List<SaleOrderItemModel> listProducts =
            fetchedProducts.map((e) => SaleOrderItemModel.fromJson(e)).toList();
        customerReturns.assignAll(listProducts);
      } else {
        customerReturns.value = [];
      }

      customerReturnsLoad.value = false;
    } catch (e) {
      customerReturnsLoad.value = false;
    }
  }
}
