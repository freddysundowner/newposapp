import 'package:flutter/material.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/models/customer_model.dart';
import 'package:pointify/models/supplier.dart';
import 'package:pointify/screens/suppliers/suppliers_page.dart';
import 'package:pointify/services/purchases.dart';
import 'package:pointify/services/supplier.dart';
import 'package:pointify/utils/colors.dart';
import 'package:pointify/widgets/snackBars.dart';
import 'package:get/get.dart';

import '../models/invoice_items.dart';
import '../models/product_model.dart';
import '../models/purchase_return.dart';
import '../models/stock_in_credit.dart';
import '../screens/product/create_product.dart';
import '../screens/sales/create_sale.dart';
import '../screens/stock/create_purchase.dart';
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
  RxList<SupplierModel> suppliers = RxList([]);
  RxList<PurchaseReturn> supplierReturns = RxList([]);
  RxList<InvoiceItem> returnedPurchases = RxList([]);
  RxList<StockInCredit> stockInCredit = RxList([]);
  Rxn<SupplierModel> supplier = Rxn(null);
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
  RxInt initialPage = RxInt(0);
  late TabController tabController;

  final List<Tab> tabs = <Tab>[
    Tab(
        child: Row(children: const [
      Text(
        "Pending",
        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      )
    ])),
    const Tab(
        child: Text(
      "Invoices",
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    )),
    const Tab(
        child: Text(
      "Returns",
      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    )),
  ];
  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    super.onInit();
  }

  createSupplier({required BuildContext context, required page}) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: context, title: "Creating supplier...", key: _keyLoader);
      creatingSupplierLoad.value = true;
      Map<String, dynamic> body = {
        "fullName": nameController.text,
        "phoneNumber": phoneController.text,
        "shopId": Get.find<ShopController>().currentShop.value?.id
      };
      var response = await Supplier().createSupplier(body);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
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
              productModel: ProductModel(),
            );
          }
          if (page == "createPurchase") {
            Get.find<HomeController>().selectedWidget.value = CreatePurchase();
          }
        } else {
          Get.back();
        }
        await getSuppliersInShop(
            Get.find<ShopController>().currentShop.value?.id, "all");
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

  getSuppliersInShop(shopId, type) async {
    try {
      suppliers.clear();
      productController.selectedSupplier.clear();
      getsupplierLoad.value = true;
      var response = await Supplier().getSuppliersByShopId(shopId, type);
      if (response != null) {
        suppliers.clear();
        List fetchedData = response["body"];

        List<SupplierModel> customersData =
            fetchedData.map((e) => SupplierModel.fromJson(e)).toList();
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
      print(e);
      getsupplierLoad.value = false;
    }
  }

  getSupplierById(id) async {
    try {
      gettingSupplier.value = true;
      var response = await Supplier().getSupplierById(id);
      if (response["status"] == true) {
        supplier.value = SupplierModel.fromJson(response["body"]);
      } else {
        supplier.value = SupplierModel();
      }
      gettingSupplier.value = false;
    } catch (e) {
      gettingSupplier.value = false;
    }
  }

  assignTextFields(SupplierModel supplierModel) {
    nameController.text = supplierModel.fullName!;
    phoneController.text = supplierModel.phoneNumber!;
    emailController.text = supplierModel.email!;
    genderController.text = supplierModel.gender!;
    addressController.text = supplierModel.address!;
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
        supplier.value = SupplierModel.fromJson(response["body"]);
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

  deleteSuppler(
      {required BuildContext context, required id, required shopId}) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: context, title: "deleting supplier...", key: _keyLoader);
      var response = await Supplier().deleteCustomer(id: id);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        if (MediaQuery.of(context).size.width > 600) {
          Get.find<HomeController>().selectedWidget.value = SuppliersPage();
        } else {
          Get.back();
        }

        await getSuppliersInShop(shopId, "all");
      } else {
        showSnackBar(message: response["message"], color: AppColors.mainColor);
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
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
    } finally {
      Get.find<PurchaseController>()
          .getPurchaseOrderItems(purchaseId: purchaseId);
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
            color: Colors.red);
      } else {
        Map<String, dynamic> body = {
          "amount": int.parse(amountController.text)
        };
        var response = await Supplier().paySupplyCredit(stockInCredit, body);

        if (response["status"] == true) {
          showSnackBar(
              message: response["message"], color: AppColors.mainColor);
          amountController.text = "";
          getSupplierCredit(stockInCredit.shop, stockInCredit.supplier);
        } else {
          showSnackBar(message: "Payment failed", color: Colors.red);
        }
      }
    } catch (e) {}
  }

  deleteProductFromStock(String productId, String shopId, context) async {
    var response = await Supplier().deleteStockProduct(productId);
    if (response["status"] != true) {
      showSnackBar(message: response["message"], color: Colors.red);
    }
  }

  getSupplierReturns({required supplierId, required String returned}) async {
    try {
      getSupplierReturnsLoad.value = true;
      var response = await Supplier()
          .getSupplierSupplies(supplierId: supplierId, returned: returned);
      if (response["status"] == true) {
        List rawData = response["body"];
        print(rawData);
        List<PurchaseReturn> jsonData =
            rawData.map((e) => PurchaseReturn.fromJson(e)).toList();
        supplierReturns.assignAll(jsonData);
      } else {
        supplierReturns.value = [];
      }
      getSupplierReturnsLoad.value = false;
    } catch (e) {
      getSupplierReturnsLoad.value = false;
      print(e);
    }
  }
}
