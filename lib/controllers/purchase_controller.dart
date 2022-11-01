import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutterpos/controllers/product_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/services/purchases.dart';
import 'package:get/get.dart';

import '../models/supply_order_model.dart';
import '../utils/colors.dart';
import '../widgets/snackBars.dart';

class PurchaseController extends GetxController {
  RxList<ProductModel> selectedList = RxList([]);
  RxList<SupplyOrderModel> purchaseByDate = RxList([]);
  RxInt grandTotal = RxInt(0);
  RxInt balance = RxInt(0);
  RxString selectedSupplier = RxString("");
  RxString selectedSupplierId = RxString("");
  RxBool savePurchaseLoad = RxBool(false);
  RxBool getPurchaseByDateLoad = RxBool(false);
  TextEditingController textEditingControllerAmount = TextEditingController();
  ProductController productController = Get.find<ProductController>();

  createPurchase(
      {required shopId,
      required attendantid,
      required context,
      required screen}) async {
    if (balance.value > 0 && selectedSupplier.value == "") {
      showSnackBar(message: "please select supplier", color: Colors.red);
    } else {
      try {
        savePurchaseLoad.value = true;
        var products = selectedList.map((element) => element).toList();
        var supplier = {
          "supplier": selectedSupplierId.value,
          "balance": balance.value,
          "total": grandTotal.value,
          "attendant": attendantid,
          "shop": shopId,
        };
        await Purchases().createPurchase(shopId:shopId,body: {"supplier": supplier, "products": products});
        balance.value = 0;
        selectedList.value = [];
        grandTotal.value = 0;
        selectedSupplier.value = "";
        selectedSupplierId.value = "";
        textEditingControllerAmount.text = "0";
        savePurchaseLoad.value = false;
        if (screen == "admin") {
          Get.back();
        }

        showSnackBar(
            message: "Stock has been successfully updated",
            color: AppColors.mainColor);
      } catch (e) {
        savePurchaseLoad.value = false;
      }
    }
  }

  changeSelectedList(value) {
    var index = selectedList.indexWhere((element) => element.id == value.id);
    if (index == -1) {
      selectedList.add(value);
      index = selectedList.indexWhere((element) => element.id == value.id);
    } else {
      var data =
          int.parse(selectedList[index].cartquantity.toString()) + 1; // +=1;
      selectedList[index].cartquantity = data;
    }
    calculateAmount(index);
    selectedList.refresh();
  }

  decrementItem(index) {
    if (selectedList[index].cartquantity! > 1) {
      selectedList[index].cartquantity = selectedList[index].cartquantity! - 1;
      selectedList.refresh();
    }
    calculateAmount(index);
  }

  incrementItem(index) {
    selectedList[index].cartquantity = selectedList[index].cartquantity! + 1;
    selectedList.refresh();

    calculateAmount(index);
  }

  calculateAmount(index) {
    grandTotal.value = 0;
    balance.value = 0;
    textEditingControllerAmount.text = "0";
    if (selectedList.length > 0) {
      selectedList[index].amount =
          selectedList[index].cartquantity! * selectedList[index].buyingPrice!;
    }

    if (selectedList.length > 0) {
      selectedList.forEach((element) {
        grandTotal.value =
            grandTotal.value + int.parse(element.amount.toString());
        textEditingControllerAmount.text = grandTotal.value.toString();
        balance.value =
            grandTotal.value - int.parse(textEditingControllerAmount.text);
      });
    }
    grandTotal.refresh();
  }

  removeFromList(index) {
    selectedList.removeAt(index);
    selectedList.refresh();
    calculateAmount(index);
  }

  Future<void> scanQR({required shopId}) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      productController.searchProductController.text = barcodeScanRes;
      await productController.searchProduct(shopId, "product");
      if (productController.products.length == 0) {
        showSnackBar(
            message: "product doesnot exist in this shop", color: Colors.red);
      } else {
        for (int i = 0; i < productController.products.length; i++) {
          changeSelectedList(productController.products[i]);
        }
      }
    } on PlatformException {
      showSnackBar(
          message: 'Failed to get platform version.', color: Colors.red);
    }
  }
}
