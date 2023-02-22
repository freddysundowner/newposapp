import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/product_controller.dart';
import 'package:flutterpos/models/customer_model.dart';
import 'package:flutterpos/services/supplier.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';

import '../widgets/loading_dialog.dart';

class SupplierController extends GetxController {
  ProductController productController = Get.find<ProductController>();
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  RxBool creatingSupplierLoad = RxBool(false);
  RxBool getsupplierLoad = RxBool(false);
  RxBool gettingSupplier = RxBool(false);
  RxBool supliesReturnedLoad = RxBool(false);
  RxList<CustomerModel> suppliers = RxList([]);
  Rxn<CustomerModel> supplier = Rxn(null);
  RxList<CustomerModel> suppliersOnCredit = RxList([]);
  RxBool suppliersOnCreditLoad = RxBool(false);

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
        showSnackBar(message: response["message"], color: AppColors.mainColor);
      } else {
        showSnackBar(message: response["message"], color: Colors.red);
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
      suppliers.clear();
      var response = await Supplier().getSuppliersByShopId(shopId);
      if (response != null) {
        List fetchedData = response["body"];
        print(fetchedData);
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
      // if (response["status"] == true) {
      //   List fetchedCustomers = response["body"];
      //   List customerData = fetchedCustomers.map((e) => CustomerModel.fromJson(e)).toList();
      //   productController.supplierName =customerData[0].name;
      //   productController.supplierId =customerData[0].name;
      //
      //   suppliers.assignAll(customerData);
      // } else {
      //   suppliers.value = [];
      // }
      getsupplierLoad.value = false;
    } catch (e) {
      print(e);
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

  assignTextFields() {
    nameController.text = supplier.value!.fullName!;
    phoneController.text = supplier.value!.phoneNumber!;
    emailController.text = supplier.value!.email!;
    genderController.text = supplier.value!.gender!;
    addressController.text = supplier.value!.address!;
  }

  updateSupplier(BuildContext context, String? id) async {
    try {
      // LoadingDialog.showLoadingDialog(context: context, title: "Updating supplier...", key: _keyLoader);
      Map<String, dynamic> body = {
        if (nameController.text != "") "fullName": nameController.text,
        "phoneNumber": phoneController.text,
        "gender": genderController.text,
        "email": emailController.text,
        "address": addressController.text
      };

      var response = await Supplier().updateSupplier(body: body, id: id);

      if (response["status"] == true) {
        showSnackBar(message: response["message"], color: AppColors.mainColor);
        clearTexts();
        await getSupplierById(id);
      } else {
        showSnackBar(message: response["message"], color: AppColors.mainColor);
      }
    } catch (e) {}
  }

  deleteSuppler(
      {required BuildContext context, required id, required shopId}) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: context, title: "deleting customer...", key: _keyLoader);
      var response = await Supplier().deleteCustomer(id: id);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        showSnackBar(message: response["message"], color: AppColors.mainColor);

        await getSuppliersInShop(shopId);
      } else {
        showSnackBar(message: response["message"], color: AppColors.mainColor);
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }

}
