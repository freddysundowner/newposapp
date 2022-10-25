import 'package:flutter/material.dart';
import 'package:flutterpos/models/customer_model.dart';
import 'package:flutterpos/services/supplier.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';

import '../widgets/loading_dialog.dart';

class SupplierController extends GetxController {
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
        "shop": shopId
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
      var response = await Supplier().getSuppliersByShopId(shopId);
      if (response["status"] == true) {
        List fetchedCustomers = response["body"];
        List<CustomerModel> customerData =
            fetchedCustomers.map((e) => CustomerModel.fromJson(e)).toList();
        suppliers.assignAll(customerData);
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

  assignTextFields() {
    nameController.text = supplier.value!.fullName!;
    phoneController.text = supplier.value!.phoneNumber!;
    emailController.text = supplier.value!.email!;
    genderController.text = supplier.value!.gender!;
    addressController.text =supplier.value!.address!;
  }
}
