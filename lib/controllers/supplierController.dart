import 'package:flutter/material.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/suppliers/suppliers_page.dart';
import 'package:pointify/services/supplier.dart';
import 'package:pointify/widgets/alert.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';

import '../Real/schema.dart';
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
      clearTexts();
      Get.back();
      if (!isSmallScreen(context)) {
        print(page);
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
            clearInputs: false,
          );
        }
        if (page == "createPurchase") {
          Get.find<HomeController>().selectedWidget.value = CreatePurchase();
        }
      } else {
        Get.back();
      }

      creatingSupplierLoad.value = false;
    } catch (e) {
      print(e);
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

  getSuppliersInShop(type) async {
    suppliers.clear();
    RealmResults<Supplier> suppliersList = SupplierService()
        .getSuppliersByShopId(
            type: type, shop: Get.find<ShopController>().currentShop.value!);

    suppliers.addAll(suppliersList.map((e) => e).toList());
  }

  assignTextFields(Supplier supplierModel) {
    nameController.text = supplierModel.fullName ?? "";
    phoneController.text = supplierModel.phoneNumber ?? "";
    emailController.text = supplierModel.emailAddress ?? "";
    addressController.text = supplierModel.location ?? "";
  }

  updateSupplier(Supplier supplier) async {
    SupplierService().updateSupplier(supplier,
        fullname: nameController.text,
        phoneNumber: phoneController.text,
        emailAddress: emailController.text,
        location: addressController.text);
  }

  deleteSuppler(Supplier supplier) {
    print(supplier.balance);
    if (supplier.balance! < 0) {
      generalAlert(
          title: "Error",
          message: "you cannot delete a supplier with a negative balance");
      return;
    }
    SupplierService().deleteSupplier(supplier);
    isSmallScreen(Get.context)
        ? Get.back()
        : Get.find<HomeController>().selectedWidget.value = SuppliersPage();
  }
}
