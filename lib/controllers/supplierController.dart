import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/product_controller.dart';
import 'package:flutterpos/controllers/sales_controller.dart';
import 'package:flutterpos/models/customer_model.dart';
import 'package:flutterpos/services/supplier.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';

import '../models/stock_in_credit.dart';
import '../widgets/loading_dialog.dart';
import 'CustomerController.dart';

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
  RxBool getsupplierLoad = RxBool(false);
  RxBool gettingSupplier = RxBool(false);
  RxBool supliesReturnedLoad = RxBool(false);
  RxList<CustomerModel> suppliers = RxList([]);
  RxList<StockInCredit> stockInCredit = RxList([]);
  Rxn<CustomerModel> supplier = Rxn(null);
  RxList<CustomerModel> suppliersOnCredit = RxList([]);
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

  createSupplier({required shopId, required BuildContext context}) async {
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
        await getSuppliersInShop(shopId);
        Get.back();
        showSnackBar(message: response["message"],
            color: AppColors.mainColor,
            context: context);
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

  getSuppliersInShop(shopId) async {
    try {
      getsupplierLoad.value = true;
      var response = await Supplier().getSuppliersByShopId(shopId);
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
      List supp = [ {
        "_id": "63fc6eb98e7d4a3bbf488ccf",
        "fullName": "trial",
        "phoneNumber": "1234567890",
        "shopId": {
          "_id": "63fa089e46721b7480474be5",
          "name": "apple",
          "location": "nakuru",
          "owner": "63f9efe3879e16801054a0b0",
          "type": "electronics",
          "currency": "ARS",
          "createdAt": "2023-02-25T13:09:50.801Z",
          "updatedAt": "2023-02-27T10:53:46.012Z",
          "__v": 0
        },
        "walletBalance": 0,
        "credit": 5400,
        "onCredit": true,
        "gender": "",
        "email": "",
        "address": "",
        "createdAt": "2023-02-27T08:50:01.760Z",
        "updatedAt": "2023-02-28T07:00:04.023Z",
        "__v": 0
      }, {
        "_id": "63fc6eb98e7d4a3bbf488ccf",
        "fullName": "trial",
        "phoneNumber": "1234567890",
        "shopId": {
          "_id": "63fa089e46721b7480474be5",
          "name": "apple",
          "location": "nakuru",
          "owner": "63f9efe3879e16801054a0b0",
          "type": "electronics",
          "currency": "ARS",
          "createdAt": "2023-02-25T13:09:50.801Z",
          "updatedAt": "2023-02-27T10:53:46.012Z",
          "__v": 0
        },
        "walletBalance": 0,
        "credit": 5400,
        "onCredit": true,
        "gender": "",
        "email": "",
        "address": "",
        "createdAt": "2023-02-27T08:50:01.760Z",
        "updatedAt": "2023-02-28T07:00:04.023Z",
        "__v": 0
      }, {
        "_id": "63fc6eb98e7d4a3bbf488ccf",
        "fullName": "trial",
        "phoneNumber": "1234567890",
        "shopId": {
          "_id": "63fa089e46721b7480474be5",
          "name": "apple",
          "location": "nakuru",
          "owner": "63f9efe3879e16801054a0b0",
          "type": "electronics",
          "currency": "ARS",
          "createdAt": "2023-02-25T13:09:50.801Z",
          "updatedAt": "2023-02-27T10:53:46.012Z",
          "__v": 0
        },
        "walletBalance": 0,
        "credit": 5400,
        "onCredit": true,
        "gender": "",
        "email": "",
        "address": "",
        "createdAt": "2023-02-27T08:50:01.760Z",
        "updatedAt": "2023-02-28T07:00:04.023Z",
        "__v": 0
      },
        {
          "_id": "63fa090246721b7480474bf9",
          "fullName": "kamau",
          "phoneNumber": "0782015660",
          "shopId": {
            "_id": "63fa089e46721b7480474be5",
            "name": "apple",
            "location": "nakuru",
            "owner": "63f9efe3879e16801054a0b0",
            "type": "electronics",
            "currency": "ARS",
            "createdAt": "2023-02-25T13:09:50.801Z",
            "updatedAt": "2023-02-27T10:53:46.012Z",
            "__v": 0
          },
          "walletBalance": 0,
          "credit": 0,
          "onCredit": false,
          "gender": "",
          "email": "",
          "address": "",
          "createdAt": "2023-02-25T13:11:30.874Z",
          "updatedAt": "2023-02-25T13:11:30.874Z",
          "__v": 0
        }
      ];
      List fetchedData = supp;
      List<CustomerModel> customersData = fetchedData.map((e) => CustomerModel.fromJson(e)).toList();
      suppliers.assignAll(customersData);
      getsupplierLoad.value = false;
    }
  }

  getSuppliersOnCredit({String? shopId}) async {
    try {
      creatingSupplierLoad.value = true;
      var response = await Supplier().getSuppliersOnCredit(shopId);
      if (response != null) {
        List fetchedData = response["body"];
        List<CustomerModel> customersData =
        fetchedData.map((e) => CustomerModel.fromJson(e)).toList();
        suppliersOnCredit.assignAll(customersData);
      } else {
        suppliersOnCredit.value = [];
      }
      creatingSupplierLoad.value = false;
    } catch (e) {
      creatingSupplierLoad.value = false;
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

  assignTextFields() {
    nameController.text = supplier.value!.fullName!;
    phoneController.text = supplier.value!.phoneNumber!;
    emailController.text = supplier.value!.email!;
    genderController.text = supplier.value!.gender!;
    addressController.text = supplier.value!.address!;
  }

  updateSupplier(BuildContext context, String? id) async {
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
      print(response);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        showSnackBar(message: response["message"],
            color: AppColors.mainColor,
            context: context);
        clearTexts();
        await getSupplierById(id);
      } else {
        showSnackBar(message: response["message"],
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
        showSnackBar(message: response["message"],
            color: AppColors.mainColor,
            context: context);

        await getSuppliersInShop(shopId);
      } else {
        showSnackBar(message: response["message"],
            color: AppColors.mainColor,
            context: context);
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }

  returnOrderToSupplier(uid, quantity, shopId, context) async {
    SalesController salesController = Get.find<SalesController>();
    try {
      returningLoad.value = true;
      if (quantityController.text == "") {
        showSnackBar(color: Colors.red,
            message: "Enter quantity to return",
            context: context);
      } else if (int.parse(quantityController.text) > quantity) {
        showSnackBar(
            message: "Quantity cannot be greater than $quantity",
            color: Colors.red, context: context);
      } else {
        Map<String, dynamic> body = {
          "quantity": int.parse(quantityController.text)
        };
        await Supplier().returnOrderToSupplier(uid, body);
        quantityController.text = "";
        showSnackBar(
            message: "Product Has been Returned",
            color: AppColors.mainColor,
            context: context);
      }

      returningLoad.value = false;
    } catch (e) {
      returningLoad.value = false;
    }
  }

  getSupplierCredit(shopId, uid) async {
    try {
      var response = await Supplier().getCredit(shopId, uid);
      if (response != null) {
        List fetchedCredit = response["body"];
        List<StockInCredit> credits =
        fetchedCredit.map((e) => StockInCredit.fromJson(e)).toList();
        stockInCredit.assignAll(credits);
      } else {
        stockInCredit.value = [];
      }
    } catch (e) {

    }
  }

  depositForSUpplier(StockInCredit stockInCredit, context) async {
    try {
      if (int.parse(amountController.text) >
          int.parse("${stockInCredit.balance}")) {
        showSnackBar(
            message: "Amaunt cannot be greater than ${stockInCredit.balance}",
            color: Colors.red, context: context);
      } else {
        Map<String, dynamic> body = {
          "amount": int.parse(amountController.text)
        };
        var response = await Supplier().paySupplyCredit(stockInCredit, body);

        if (response["status"] == true) {
          showSnackBar(message: response["message"],
              color: AppColors.mainColor,
              context: context);
          amountController.text = "";
          getSupplierCredit(stockInCredit.shop, stockInCredit.supplier);
        } else {
          showSnackBar(
              message: "Payment failed", color: Colors.red, context: context);
        }
      }
    } catch (e) {

    }
  }

  deleteProductFromStock(String productId, String shopId, context) async {
    SalesController salesController = Get.find<SalesController>();
    var response = await Supplier().deleteStockProduct(productId);
    if (response["status"] == true) {
      showSnackBar(message: response["message"],
          color: AppColors.mainColor,
          context: context);
    } else {
      showSnackBar(
          message: response["message"], color: Colors.red, context: context);
    }
  }


}
