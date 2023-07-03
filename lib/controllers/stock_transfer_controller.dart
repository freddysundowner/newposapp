import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pointify/controllers/realm_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/stock/transfer_history.dart';
import 'package:pointify/services/product.dart';
import 'package:pointify/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';

import '../Real/schema.dart';
import '../widgets/loading_dialog.dart';

class StockTransferController extends GetxController {
  GlobalKey<State> _keyLoader = new GlobalKey<State>();
  RxList<ProductTransfer> selectedProducts = RxList([]);
  RxList<StockTransferHistory> transferHistory = RxList([]);
  RxList<ProductHistoryModel> productTransferHistory = RxList([]);

  RxBool gettingTransferHistoryLoad = RxBool(false);

  RxString activeItem = RxString("Transfer In");

  void addToList(Product productModel) {
    checkProductExistence(productModel);
    var index = selectedProducts
        .indexWhere((element) => element.product!.id == productModel.id);
    if (index == -1) {
      selectedProducts.add(ProductTransfer(product: productModel, quantity: 1));
    } else {
      selectedProducts.removeAt(selectedProducts
          .indexWhere((element) => element.product!.id == productModel.id));
    }
    Get.find<ProductController>().products.refresh();
    selectedProducts.refresh();
  }

  checkProductExistence(Product productModel) {
    var index = selectedProducts
        .indexWhere((element) => element.product!.id == productModel.id);
    if (index == -1) {
      return false;
    } else {
      return true;
    }
  }

  void submitTranster({required Shop toShop, required context}) async {
    // try {
    // LoadingDialog.showLoadingDialog(
    //     context: context, title: "Transfering Products...", key: _keyLoader);
    ObjectId transferId = ObjectId();
    StockTransferHistory stockTransferHistory = StockTransferHistory(transferId,
        from: Get.find<ShopController>().currentShop.value,
        to: toShop,
        attendant: Get.find<UserController>().user.value,
        product: selectedProducts.map((element) => {
              "id": element.product!.id,
              "quantity": element.quantity,
              "name": element.product!.name
            }.toString()),
        createdAt: DateTime.now(),
        type: "out");
    Products().createProductStockTransferHistory(stockTransferHistory);
    for (var element in selectedProducts) {
      var quantityToAdd = (element.quantity ?? 1);
      //create product transfer history
      ProductHistoryModel productHistoryModel = ProductHistoryModel(ObjectId(),
          product: element.product,
          type: "transfer",
          toShop: toShop,
          quantity: quantityToAdd,
          shop: Get.find<ShopController>().currentShop.value!.id.toString(),
          supplier: element.supplier,
          createdAt: DateTime.now(),
          stockTransferHistory: transferId);
      Products().createProductHistory(productHistoryModel);

      //reduce from shop product quantity
      var quantityToDeduct = element.product!.quantity! - quantityToAdd;
      Products().updateProductPart(
          product: element.product!,
          quantity: quantityToDeduct,
          type: "transfer");

      final DateTime now = DateTime.now();
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final String formatted = formatter.format(now);
      //check if product exits
      Product? productExists =
          Products().getProductByName(element.product!.name!, toShop);
      if (productExists != null) {
        var qty = productExists.quantity! + quantityToAdd;
        print("exists $qty");
        Products().updateProductPart(product: productExists, quantity: qty);
      } else {
        Product product = Product(ObjectId(),
            name: element.product!.name,
            quantity: quantityToAdd,
            buyingPrice: element.product!.buyingPrice,
            selling: element.product!.selling,
            minPrice: element.product!.minPrice,
            shop: toShop,
            attendant: Get.find<UserController>().user.value,
            unit: element.product!.unit,
            category: element.product!.category,
            stockLevel: element.product!.stockLevel,
            discount: element.product!.discount,
            description: element.product!.description,
            supplier: element.supplier,
            date: formatted,
            deleted: false,
            createdAt: DateTime.now());
        Products().createProduct(product, type: "transfer");
      }
    }
    refresh();

    if (!isSmallScreen(context)) {
      Get.back();
      Get.find<HomeController>().selectedWidget.value = TransferHistory();
    } else {
      Get.back();
      Get.back();
      Get.to(() => TransferHistory());
      Get.find<ProductController>().getProductsBySort(type: "");
    }
    selectedProducts.clear();
    // gettingTransferHistory(shopId: from, type: "in");
  }

  gettingTransferHistory({String type = ""}) async {
    try {
      transferHistory.clear();
      gettingTransferHistoryLoad.value = true;
      RealmResults<StockTransferHistory> response = Products().getTransHistory(
          shop: Get.find<ShopController>().currentShop.value!, type: type);
      transferHistory.addAll(response.map((e) => e).toList());
      gettingTransferHistoryLoad.value = false;
      refresh();
    } catch (e) {
      print(e);
      gettingTransferHistoryLoad.value = false;
    }
  }

  getProductTransferHistory(Product product) async {
    productTransferHistory.clear();
    RealmResults<ProductHistoryModel> response =
        Products().getProductTransferHistory(product: product);
    productTransferHistory.addAll(response.map((e) => e).toList());
  }
}
