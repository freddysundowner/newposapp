import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/product_controller.dart';
import 'package:flutterpos/models/customer_model.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/models/purchase_order.dart';
import 'package:flutterpos/models/supply_order_model.dart';
import 'package:flutterpos/screens/stock/view_purchases.dart';
import 'package:flutterpos/services/purchases.dart';
import 'package:flutterpos/widgets/loading_dialog.dart';
import 'package:get/get.dart';

import '../widgets/snackBars.dart';

class PurchaseController extends GetxController {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  RxList<ProductModel> selectedList = RxList([]);
  RxList<PurchaseOrder> purchaseByDate = RxList([]);
  RxList<SupplyOrderModel> purchaseOrderItems = RxList([]);
  RxInt grandTotal = RxInt(0);
  RxInt balance = RxInt(0);
  Rxn<CustomerModel> selectedSupplier = Rxn(null);

  RxBool getPurchaseLoad = RxBool(false);
  RxBool getPurchaseByDateLoad = RxBool(false);
  RxBool getPurchaseOrderItemLoad = RxBool(false);
  TextEditingController textEditingControllerAmount = TextEditingController();
  ProductController productController = Get.find<ProductController>();

  createPurchase(
      {required shopId,
      required attendantid,
      required context,
      required screen}) async {
    if (balance.value > 0 && selectedSupplier.value == "") {
      showSnackBar(
          message: "please select supplier",
          color: Colors.red,
          context: context);
    } else {
      try {
        LoadingDialog.showLoadingDialog(
            context: context,
            title: "adding purchase please wait...",
            key: _keyLoader);
        var products = selectedList.map((element) => element).toList();
        var supplier = {
          if (selectedSupplier.value != null)
            "supplier": selectedSupplier.value!.id,
          "balance": balance.value,
          "total": grandTotal.value,
          "attendant": attendantid,
          "shop": shopId,
        };
        var response = await Purchases().createPurchase(shopId: shopId, body: {
          "supplier": supplier,
          "products": products,
          "date":
              DateTime.parse(DateTime.now().toString()).millisecondsSinceEpoch,
        });
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        if (response["status"] == true) {
          balance.value = 0;
          selectedList.value = [];
          grandTotal.value = 0;
          selectedSupplier.value = null;
          textEditingControllerAmount.text = "0";
          getPurchase(shopId: shopId,attendantId: attendantid);
          if (screen == "admin") {
            if (MediaQuery.of(context).size.width > 600) {
              Get.find<HomeController>().selectedWidget.value = ViewPurchases();
            } else {
              Get.back();
            }
          }
        }
      } catch (e) {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      }
    }
  }

  getPurchase({required shopId,String ?attendantId}) async {
    try {
      getPurchaseLoad.value = true;
      var response = await Purchases().getPurchase(shopId: shopId,attendantId:attendantId);
      print(response);
      if (response["status"] == true) {
        List fetchedResponse = response["body"];
        List<PurchaseOrder> supply =
            fetchedResponse.map((e) => PurchaseOrder.fromJson(e)).toList();
        purchaseByDate.assignAll(supply);
      } else {
        purchaseByDate.value = RxList([]);
      }
      getPurchaseLoad.value = false;
    } catch (e) {
      getPurchaseLoad.value = false;
    }
  }

  getPurchaseOrderItems({required id}) async {
    try {
      getPurchaseOrderItemLoad.value = true;
      var response = await Purchases().getPurchaseOrderItems(id: id);
      if (response["status"] == true) {
        List fetchedResponse = response["body"];
        List<SupplyOrderModel> supply =
            fetchedResponse.map((e) => SupplyOrderModel.fromJson(e)).toList();
        purchaseOrderItems.assignAll(supply);
      } else {
        purchaseOrderItems.value = RxList([]);
      }
      getPurchaseOrderItemLoad.value = false;
    } catch (e) {
      print(e);
      getPurchaseOrderItemLoad.value = false;
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

  Future<void> scanQR({required shopId, required context}) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      productController.searchProductController.text = barcodeScanRes;
      await productController.searchProduct(shopId, "product");
      if (productController.products.length == 0) {
        showSnackBar(
            message: "product doesnot exist in this shop",
            color: Colors.red,
            context: context);
      } else {
        for (int i = 0; i < productController.products.length; i++) {
          changeSelectedList(productController.products[i]);
        }
      }
    } on PlatformException {
      showSnackBar(
          message: 'Failed to get platform version.',
          color: Colors.red,
          context: context);
    }
  }

  calculateSalesAmount() {
    var subTotal = 0;
    selectedList.forEach((element) {
      subTotal = subTotal + (element.buyingPrice! * element.cartquantity!);
    });
    return subTotal;
  }

  calculatePurchasemount() {
    var subTotal = 0;
    purchaseByDate.forEach((element) {
      subTotal = subTotal + element.total!;
    });
    return subTotal;
  }
}
