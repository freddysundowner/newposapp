import 'package:flutter/material.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/screens/suppliers/suppliers_page.dart';
import 'package:pointify/services/purchases.dart';
import 'package:pointify/services/supplier.dart';
import 'package:pointify/utils/colors.dart';
import 'package:pointify/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';

import '../Real/Models/schema.dart';
import '../functions/functions.dart';
import '../screens/product/create_product.dart';
import '../screens/sales/create_sale.dart';
import '../screens/purchases/create_purchase.dart';
import '../widgets/loading_dialog.dart';
import 'home_controller.dart';

class SupplierController extends GetxController
    with SingleGetTickerProviderMixin {
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
  RxBool getSupplierReturnsLoad = RxBool(false);
  RxBool getsupplierLoad = RxBool(false);
  RxBool gettingSupplier = RxBool(false);
  RxBool supliesReturnedLoad = RxBool(false);
  RxList<Supplier> suppliers = RxList([]);
  RxList<PurchaseReturn> supplierReturns = RxList([]);
  RxList<InvoiceItem> returnedPurchases = RxList([]);
  RxList<StockInCredit> stockInCredit = RxList([]);
  Rxn<Supplier> supplier = Rxn(null);
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
  Rxn<CustomerModel> singleSupplier = Rxn(null);
  RxInt totals = RxInt(0);
  RxInt totalsReturn = RxInt(0);
  RxInt initialPage = RxInt(0);

  @override
  void onInit() {
    super.onInit();
  }

  createSupplier({required BuildContext context, required page}) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: context, title: "Creating supplier...", key: _keyLoader);
      creatingSupplierLoad.value = true;
      Supplier supplier = Supplier(ObjectId(),
          fullName: nameController.text,
          phoneNumber: phoneController.text,
          balance: 0,
          createdAt: DateTime.now(),
          shopId: Get.find<ShopController>().currentShop.value?.id.toString());
      SupplierService().createSupplier(supplier);
      Get.back();
      clearTexts();
      if (MediaQuery.of(context).size.width > 600) {
        if (page == "suppliersPage") {
          Get.find<HomeController>().selectedWidget.value = SuppliersPage();
        }
        if (page == "createSale") {
          Get.find<HomeController>().selectedWidget.value = CreateSale();
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
      }

      creatingSupplierLoad.value = false;
    } catch (e) {
      print(e);
      creatingSupplierLoad.value = false;
    } finally {
      Get.back();
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

  getSuppliersInShop(type) async {
    suppliers.clear();
    RealmResults<Supplier> suppliersList =
        SupplierService().getSuppliersByShopId(type: type);

    suppliers.addAll(suppliersList.map((e) => e).toList());
  }

  assignTextFields(Supplier supplierModel) {
    nameController.text = supplierModel.fullName ?? "";
    phoneController.text = supplierModel.phoneNumber ?? "";
    emailController.text = supplierModel.emailAddress ?? "";
    addressController.text = supplierModel.location ?? "";
  }

  updateSupplier(BuildContext context, ObjectId id) async {
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
      var response = await SupplierService().updateSupplier(body: body, id: id);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        clearTexts();
        // supplier.value = ;//SupplierModel.fromJson(response["body"]);
        int index = suppliers.indexWhere((element) => element.id == id);
        suppliers[index] = supplier.value!;
        suppliers.refresh();
      } else {
        showSnackBar(message: response["message"], color: AppColors.mainColor);
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }

  deleteSuppler(Supplier supplier) {
    SupplierService().deleteSupplier(supplier);
    Get.back();
  }

  returnOrderToSupplier({required uid, purchaseId}) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: Get.context!,
          title: "returning order to  supplier...",
          key: _keyLoader);
      await Purchases().returnOrderToSupplier(uid);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      quantityController.text = "";
      showSnackBar(
          message: "Product Has been Returned", color: AppColors.mainColor);
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    } finally {}
  }
}
