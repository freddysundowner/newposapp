import 'package:flutter/material.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/models/customer_model.dart';
import 'package:pointify/models/receipt.dart';
import 'package:pointify/models/sales_return.dart';
import 'package:pointify/services/customer.dart';
import 'package:get/get.dart';
import 'package:pointify/services/sales.dart';
import 'package:pointify/widgets/alert.dart';

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
  RxList<SalesReturn> customerReturns = RxList([]);

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
      "Sales",
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
            Get.find<HomeController>().selectedWidget.value = CustomersPage();
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
        showSnackBar(message: response["message"], color: Colors.red);
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

      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        clearTexts();
        customer.value = CustomerModel.fromJson(response["body"]);
        int index = customers.indexWhere((element) => element.id == id);
        customers[index] = customer.value!;
        customers.refresh();
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
        if (MediaQuery.of(context).size.width > 600) {
          Get.find<HomeController>().selectedWidget.value = CustomersPage();
        } else {
          Get.back();
        }
        clearTexts();
        await getCustomersInShop(shopId, "all");
      } else {
        generalAlert(message: response["message"], title: "Error");
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }

  getCustomerPurchases(
      {required uid,
      required operation,
      required attendantId,
      String? customer,
      String? returned}) async {
    try {
      customerSales.clear();
      customerPurchaseLoad.value = true;
      var response =
          await Sales().getSales(onCredit: "", customer: customer, date: "");
      if (response["status"] == true) {
        customerSales.clear();
        List fetchedProducts = response["body"];
        List<SalesModel> listProducts =
            fetchedProducts.map((e) => SalesModel.fromJson(e)).toList();
        customerSales.assignAll(listProducts);
      } else {
        customerSales.value = [];
      }

      customerPurchaseLoad.value = false;
    } catch (e) {
      customerPurchaseLoad.value = false;
    }
  }

  getCustomerReturns({String? uid, String? productId}) async {
    try {
      loadingcustomerReturns.value = true;
      customerReturns.clear();
      var response = await Customer().getReturns(
          uid: uid!,
          attendantId: Get.find<AuthController>().currentUser.value!.id!);
      if (response != null) {
        List fetchedProducts = response["body"];
        List<SalesReturn> singleProduct =
            fetchedProducts.map((e) => SalesReturn.fromJson(e)).toList();
        customerReturns.assignAll(singleProduct);
      } else {
        customerReturns.value = [];
      }
      loadingcustomerReturns.value = false;
    } catch (e) {
      loadingcustomerReturns.value = false;
    }
  }
}
