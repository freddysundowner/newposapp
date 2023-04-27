import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/product_controller.dart';
import 'package:flutterpos/screens/stock/transfer_history.dart';
import 'package:flutterpos/services/product.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';

import '../models/product_model.dart';
import '../models/stockTransferHistoryModel.dart';
import '../widgets/loading_dialog.dart';

class StockTransferController extends GetxController {
  GlobalKey<State> _keyLoader = new GlobalKey<State>();
  RxList<ProductModel> selectedProducts = RxList([]);
  RxList<StockTransferHistory> transferHistory = RxList([]);

  RxBool gettingTransferHistoryLoad = RxBool(false);

  RxString activeItem = RxString("Transfer In");

  void addToList(ProductModel productModel) {
    checkProductExistence(productModel);
    var index =
        selectedProducts.indexWhere((element) => element.id == productModel.id);
    if (index == -1) {
      selectedProducts.add(productModel);
    } else {
      selectedProducts.removeAt(selectedProducts
          .indexWhere((element) => element.id == productModel.id));
    }
    Get.find<ProductController>().products.refresh();
    selectedProducts.refresh();
  }

  checkProductExistence(ProductModel productModel) {
    var index =
        selectedProducts.indexWhere((element) => element.id == productModel.id);
    if (index == -1) {
      return false;
    } else {
      return true;
    }
  }

  void submitTranster({required to, required from, required context}) async {
    try {
      LoadingDialog.showLoadingDialog(
          context: context, title: "Transferring Product...", key: _keyLoader);
      Map<String, dynamic> body = {
        "from": from,
        "to": to,
        "products": selectedProducts
            .map((element) =>
                {"id": element.id, "quantity": element.cartquantity,"name":element.name})
            .toList(),
      };
      var response = await Products().transferProducts(body: body);
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      if (response["status"] == true) {
        if (MediaQuery.of(context).size.width > 600) {
          Get.find<HomeController>().selectedWidget.value = TransferHistory();
        } else {
          Get.back();
          Get.back();
          Get.to(() => TransferHistory());
        }
        selectedProducts.clear();
        gettingTransferHistory(shopId: from, type: "in");
      } else {
        showSnackBar(
            message: response["message"], color: Colors.red, context: context);
      }
    } catch (e) {
      Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
    }
  }

  gettingTransferHistory({required shopId, required type}) async {
    try {
      transferHistory.clear();
      gettingTransferHistoryLoad.value = true;
      var response = await Products().getTransHistory(shopId: shopId, type: type);
      if (response["status"] == true) {
        List jsonData = response["body"];

        List<StockTransferHistory> transfer =
            jsonData.map((e) => StockTransferHistory.fromJson(e)).toList();
        transferHistory.assignAll(transfer);
      } else {
        transferHistory.value = [];
      }
      gettingTransferHistoryLoad.value = false;
    } catch (e) {
      gettingTransferHistoryLoad.value = false;
    }
  }
}
