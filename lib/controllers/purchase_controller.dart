import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutterpos/controllers/product_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/models/purchase_order.dart';
import 'package:flutterpos/models/supply_order_model.dart';
import 'package:flutterpos/services/purchases.dart';
import 'package:flutterpos/widgets/loading_dialog.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';
import '../widgets/snackBars.dart';

class PurchaseController extends GetxController {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  RxList<ProductModel> selectedList = RxList([]);
  RxList<PurchaseOrder> purchaseByDate = RxList([]);
  RxList<SupplyOrderModel> purchaseOrderItems = RxList([]);
  RxInt grandTotal = RxInt(0);
  RxInt balance = RxInt(0);
  RxString selectedSupplier = RxString("");
  RxString selectedSupplierId = RxString("");
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
          "supplier": selectedSupplierId.value,
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
          selectedSupplier.value = "";
          selectedSupplierId.value = "";
          textEditingControllerAmount.text = "0";
          if (screen == "admin") {
            Get.back();
          }

          showSnackBar(
              message: response["message"],
              color: AppColors.mainColor,
              context: context);
        }
      } catch (e) {
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
      }
    }
  }

  getPurchase({required shopId}) async {
    try {
      getPurchaseLoad.value = true;
      var response = await Purchases().getPurchase(shopId: shopId);

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
      List pur = [
        {
          "_id": "63fc4d788e7d4a3bbf488786",
          "supplier": "63fa090246721b7480474bf9",
          "shop": "63fa089e46721b7480474be5",
          "attendantId": "63f9efe3879e16801054a0b0",
          "balance": 0,
          "total": 120000,
          "receiptNumber": "RE644IJFIK2",
          "onCredit": false,
          "productCount": 1,
          "createdAt": "2023-02-27T06:28:08.010Z",
          "updatedAt": "2023-02-27T06:28:08.010Z",
          "__v": 0
        },
        {
          "_id": "63fc4dc58e7d4a3bbf488799",
          "supplier": "63fa090246721b7480474bf9",
          "shop": "63fa089e46721b7480474be5",
          "attendantId": null,
          "balance": 0,
          "total": 0,
          "receiptNumber": "",
          "onCredit": false,
          "productCount": 1,
          "createdAt": "2023-02-27T06:29:25.895Z",
          "updatedAt": "2023-02-27T06:29:25.895Z",
          "__v": 0
        },
        {
          "_id": "63fc707a8e7d4a3bbf488d24",
          "supplier": "63fa090246721b7480474bf9",
          "shop": "63fa089e46721b7480474be5",
          "attendantId": "63f9efe3879e16801054a0b0",
          "balance": 0,
          "total": 1200,
          "receiptNumber": "RE35KKS62EH",
          "onCredit": false,
          "productCount": 1,
          "createdAt": "2023-02-27T08:57:30.889Z",
          "updatedAt": "2023-02-27T08:57:30.889Z",
          "__v": 0
        },
        {
          "_id": "63fc71038e7d4a3bbf488d52",
          "supplier": "63fc6eb98e7d4a3bbf488ccf",
          "shop": "63fa089e46721b7480474be5",
          "attendantId": "63f9efe3879e16801054a0b0",
          "balance": 4320,
          "total": 4800,
          "receiptNumber": "REIRYTTDUPG",
          "onCredit": true,
          "productCount": 1,
          "createdAt": "2023-02-27T08:59:47.022Z",
          "updatedAt": "2023-02-27T08:59:47.022Z",
          "__v": 0
        },
        {
          "_id": "63fda65bd13cf778aab94f77",
          "supplier": "63fa090246721b7480474bf9",
          "shop": "63fa089e46721b7480474be5",
          "attendantId": "63f9efe3879e16801054a0b0",
          "balance": 0,
          "total": 7200,
          "receiptNumber": "REB7MLIPB6Z",
          "onCredit": false,
          "productCount": 1,
          "createdAt": "2023-02-28T06:59:39.411Z",
          "updatedAt": "2023-02-28T06:59:39.411Z",
          "__v": 0
        },
        {
          "_id": "63fda674d13cf778aab94f8a",
          "supplier": "63fc6eb98e7d4a3bbf488ccf",
          "shop": "63fa089e46721b7480474be5",
          "attendantId": "63f9efe3879e16801054a0b0",
          "balance": 1080,
          "total": 1200,
          "receiptNumber": "RECYDPYNUQA",
          "onCredit": true,
          "productCount": 1,
          "createdAt": "2023-02-28T07:00:04.019Z",
          "updatedAt": "2023-02-28T07:00:04.019Z",
          "__v": 0
        },
        {
          "_id": "63fdcd1b8b658aafbf4e21b9",
          "supplier": "63fa090246721b7480474bf9",
          "shop": "63fa089e46721b7480474be5",
          "attendantId": null,
          "balance": 0,
          "total": 0,
          "receiptNumber": "",
          "onCredit": false,
          "productCount": 1,
          "createdAt": "2023-02-28T09:44:59.282Z",
          "updatedAt": "2023-02-28T09:44:59.282Z",
          "__v": 0
        },
      ];
      List<PurchaseOrder> supply =
          pur.map((e) => PurchaseOrder.fromJson(e)).toList();
      purchaseByDate.assignAll(supply);
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
}
