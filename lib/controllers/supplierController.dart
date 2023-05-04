import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/product_controller.dart';
import 'package:flutterpos/models/customer_model.dart';
import 'package:flutterpos/services/purchases.dart';
import 'package:flutterpos/services/supplier.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';

import '../models/product_model.dart';
import '../models/stock_in_credit.dart';
import '../models/supply_order_model.dart';
import '../screens/customers/customers_page.dart';
import '../screens/product/create_product.dart';
import '../screens/sales/create_sale.dart';
import '../screens/stock/create_purchase.dart';
import '../widgets/loading_dialog.dart';
import 'home_controller.dart';

class SupplierController extends GetxController {
  ProductController productController = Get.find<ProductController>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController namesController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

  RxBool creatingSupplierLoad = RxBool(false);
  RxBool gettingSupplierSuppliesLoad = RxBool(false);
  RxBool getsupplierLoad = RxBool(false);
  RxBool gettingSupplier = RxBool(false);
  RxBool supliesReturnedLoad = RxBool(false);
  RxList<CustomerModel> suppliers = RxList([]);
  RxList<SupplyOrderModel> supplierSupplies = RxList([]);
  RxList<StockInCredit> stockInCredit = RxList([]);
  Rxn<CustomerModel> supplier = Rxn(null);
  RxBool suppliersOnCreditLoad = RxBool(false);

  RxBool savesupplierLoad = RxBool(false);
  RxBool getSinglesupplier = RxBool(false);
  RxBool updatesupplierLoad = RxBool(false);
  RxBool deletesupplierLoad = RxBool(false);
  RxBool gettingSupplierSupliesLoad = RxBool(false);
  RxBool gettingSuppliesLoad = RxBool(false);
  RxBool returningLoad = RxBool(false);
  RxBool getSupplierLoad = RxBool(false);
  RxBool gettingSupliesReturnerLoad = RxBool(false);
  var purchaseOrder = [].obs;
  var returnedProducts = [].obs;
  var supplies = [].obs;
  var singleSupplier = CustomerModel().obs;
  RxInt totals = RxInt(0);
  RxInt totalsReturn = RxInt(0);

  // RxList<StockInCredit> stockInCredit = RxList([]);

  createSupplier(
      {required shopId, required BuildContext context, required page}) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: context, title: "Creating supplier...", key: _keyLoader);
      creatingSupplierLoad.value = true;
      Map<String, dynamic> body = {
        "fullName": nameController.text,
        "phoneNumber": phoneController.text,
        "shopId": shopId
      };
      var response = await Supplier().createSupplier(body);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        clearTexts();
        if (MediaQuery.of(context).size.width > 600) {
          if (page == "customersPage") {
            Get.find<HomeController>().selectedWidget.value =
                CustomersPage(type: "suppliers");
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
        await getSuppliersInShop(shopId, "all");
      } else {
        showSnackBar(
            message: response["message"], color: Colors.red, context: context);
      }

      creatingSupplierLoad.value = false;
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      creatingSupplierLoad.value = false;
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

  getSuppliersInShop(shopId, type) async {
    try {
      suppliers.clear();
      productController.selectedSupplier.clear();
      getsupplierLoad.value = true;
      var response = await Supplier().getSuppliersByShopId(shopId, type);
      print("suppliers$response}");
      if (response != null) {
        suppliers.clear();
        List fetchedData = response["body"];

        List<CustomerModel> customersData =
            fetchedData.map((e) => CustomerModel.fromJson(e)).toList();
        for (int i = 0; i < customersData.length; i++) {
          productController.selectedSupplier.add({
            "name": "${customersData[i].fullName}",
            "id": "${customersData[i].id}"
          });
        }

        suppliers.assignAll(customersData);
      } else {
        suppliers.value = [];
      }
      getsupplierLoad.value = false;
    } catch (e) {
      getsupplierLoad.value = false;
    }
  }

  getSupplierById(id) async {
    try {
      gettingSupplier.value = true;
      var response = await Supplier().getSupplierById(id);
      if (response["status"] == true) {
        supplier.value = CustomerModel.fromJson(response["body"]);
      } else {
        supplier.value = CustomerModel();
      }
      gettingSupplier.value = false;
    } catch (e) {
      gettingSupplier.value = false;
    }
  }

  assignTextFields(CustomerModel customerModel) {
    nameController.text = customerModel.fullName!;
    phoneController.text = customerModel.phoneNumber!;
    emailController.text = customerModel.email!;
    genderController.text = customerModel.gender!;
    addressController.text = customerModel.address!;
  }

  updateSupplier(BuildContext context, String id) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: context, title: "Updating supplier...", key: _keyLoader);
      Map<String, dynamic> body = {
        if (nameController.text != "") "fullName": nameController.text,
        if (phoneController.text != "") "phoneNumber": phoneController.text,
        if (genderController.text != "") "gender": genderController.text,
        if (emailController.text != "") "email": emailController.text,
        if (addressController.text != "") "address": addressController.text
      };
      var response = await Supplier().updateSupplier(body: body, id: id);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        clearTexts();
        supplier.value = CustomerModel.fromJson(response["body"]);
        int index = suppliers.indexWhere((element) => element.id == id);
        suppliers[index] = supplier.value!;
        suppliers.refresh();
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

  deleteSuppler(
      {required BuildContext context, required id, required shopId}) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: context, title: "deleting customer...", key: _keyLoader);
      var response = await Supplier().deleteCustomer(id: id);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        if (MediaQuery.of(context).size.width > 600) {
          Get.find<HomeController>().selectedWidget.value =
              CustomersPage(type: "supplier");
        } else {
          Get.back();
        }

        await getSuppliersInShop(shopId, "all");
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

  returnOrderToSupplier({required uid, required context}) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: context,
          title: "returning order to  supplier...",
          key: _keyLoader);
      await Purchases().returnOrderToSupplier(uid);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      quantityController.text = "";
      showSnackBar(
          message: "Product Has been Returned",
          color: AppColors.mainColor,
          context: context);
    } catch (e) {
      print(e);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }

  getSupplierCredit(shopId, uid) async {
    try {
      returningLoad.value = true;
      var response = await Supplier().getCredit(shopId, uid);
      if (response != null) {
        List fetchedCredit = response["body"];
        List<StockInCredit> credits =
            fetchedCredit.map((e) => StockInCredit.fromJson(e)).toList();
        stockInCredit.assignAll(credits);
      } else {
        stockInCredit.value = [];
      }
      returningLoad.value = false;
    } catch (e) {
      returningLoad.value = false;
    }
  }

  depositForSUpplier(StockInCredit stockInCredit, context) async {
    try {
      if (int.parse(amountController.text) >
          int.parse("${stockInCredit.balance}")) {
        showSnackBar(
            message: "Amaunt cannot be greater than ${stockInCredit.balance}",
            color: Colors.red,
            context: context);
      } else {
        Map<String, dynamic> body = {
          "amount": int.parse(amountController.text)
        };
        var response = await Supplier().paySupplyCredit(stockInCredit, body);

        if (response["status"] == true) {
          showSnackBar(
              message: response["message"],
              color: AppColors.mainColor,
              context: context);
          amountController.text = "";
          getSupplierCredit(stockInCredit.shop, stockInCredit.supplier);
        } else {
          showSnackBar(
              message: "Payment failed", color: Colors.red, context: context);
        }
      }
    } catch (e) {}
  }

  deleteProductFromStock(String productId, String shopId, context) async {
    var response = await Supplier().deleteStockProduct(productId);
    if (response["status"] != true) {
      showSnackBar(
          message: response["message"], color: Colors.red, context: context);
    }
  }

  getSupplierSupplies(
      {required supplierId, required attendantId, required returned}) async {
    try {
      gettingSupplierSuppliesLoad.value=true;
      var response = await Supplier().getSupplierSupplies(
          supplierId: supplierId, attendantId: attendantId, returned: returned);
      if (response["status"] == true) {
        List rawData = response["body"];
        List<SupplyOrderModel> jsonData =
            rawData.map((e) => SupplyOrderModel.fromJson(e)).toList();
        supplierSupplies.assignAll(jsonData);
      } else {
        supplierSupplies.value = [];
      }
      gettingSupplierSuppliesLoad.value=false;
    } catch (e) {
      gettingSupplierSuppliesLoad.value=false;
      print(e);
    }
  }
}
