import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/attendant_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/models/invoice_items.dart';
import 'package:pointify/models/product_model.dart';
import 'package:pointify/models/supplier.dart';
import 'package:pointify/screens/stock/view_purchases.dart';
import 'package:pointify/services/purchases.dart';
import 'package:pointify/widgets/loading_dialog.dart';
import 'package:get/get.dart';

import '../models/invoice.dart';
import '../widgets/snackBars.dart';
import 'CustomerController.dart';

class PurchaseController extends GetxController {
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();
  RxList<ProductModel> saleItem = RxList([]);
  RxList<Invoice> purchasedItems = RxList([]);
  RxList<Invoice> creditPurchases = RxList([]);
  RxList<InvoiceItem> invoicesItems = RxList([]);
  RxInt grandTotal = RxInt(0);
  RxInt balance = RxInt(0);
  Rxn<SupplierModel> selectedSupplier = Rxn(null);

  RxBool returningIvoiceLoad = RxBool(false);
  RxBool getPurchaseLoad = RxBool(false);
  RxBool getPurchaseByDateLoad = RxBool(false);
  RxBool getPurchaseOrderItemLoad = RxBool(false);
  TextEditingController textEditingControllerAmount = TextEditingController();
  ProductController productController = Get.find<ProductController>();

  createPurchase({required context, required screen}) async {
    if (balance.value > 0 && selectedSupplier.value == null) {
      showSnackBar(message: "please select supplier", color: Colors.red);
    } else {
      try {
        Navigator.pop(context);
        LoadingDialog.showLoadingDialog(
            context: context,
            title: "adding purchase please wait...",
            key: _keyLoader);
        var products = saleItem.map((element) => element.toJson()).toList();
        var supplier = {
          if (selectedSupplier.value != null)
            "supplier": selectedSupplier.value!.id,
          "balance": balance.value,
          "total": grandTotal.value,
          "itemstotal": grandTotal.value,
          "attendant": Get.find<AuthController>().usertype.value == "admin"
              ? Get.find<AuthController>().currentUser.value!.id
              : Get.find<AttendantController>().attendant.value!.id,
          "shop": Get.find<ShopController>().currentShop.value!.id,
        };

        var response = await Purchases().createPurchase(body: {
          "supplier": supplier,
          "products": products,
          "date":
              DateTime.parse(DateTime.now().toString()).millisecondsSinceEpoch,
        });
        Navigator.of(_keyLoader.currentContext!, rootNavigator: true).pop();
        if (response["status"] == true) {
          balance.value = 0;
          saleItem.value = [];
          grandTotal.value = 0;
          selectedSupplier.value = null;
          textEditingControllerAmount.text = "0";
          getPurchase();
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

  getPurchase({
    String? supplier,
    String? onCredit,
  }) async {
    try {
      getPurchaseLoad.value = true;
      var response = await Purchases()
          .getPurchase(supplier: supplier ?? "", onCredit: onCredit ?? "");
      if (response["status"] == true) {
        List fetchedResponse = response["body"];
        List<Invoice> supply =
            fetchedResponse.map((e) => Invoice.fromJson(e)).toList();
        if (onCredit!.isNotEmpty) {
          creditPurchases.value = supply;
        } else {
          purchasedItems.assignAll(supply);
        }
      } else {
        purchasedItems.value = RxList([]);
      }
      getPurchaseLoad.value = false;
    } catch (e) {
      print(e);
      getPurchaseLoad.value = false;
    }
  }

  getPurchaseOrderItems({String? purchaseId, String? productId}) async {
    try {
      getPurchaseOrderItemLoad.value = true;
      var response = await Purchases().getPurchaseOrderItems(
          id: purchaseId ?? "", productId: productId ?? "");
      if (response["status"] == true) {
        List fetchedResponse = response["body"];
        invoicesItems.clear();
        List<InvoiceItem> supply =
            fetchedResponse.map((e) => InvoiceItem.fromJson(e)).toList();
        invoicesItems.assignAll(supply);
      } else {
        invoicesItems.value = RxList([]);
      }
      getPurchaseOrderItemLoad.value = false;
    } catch (e) {
      getPurchaseOrderItemLoad.value = false;
    }
  }

  changesaleItem(value) {
    var index = saleItem.indexWhere((element) => element.id == value.id);
    if (index == -1) {
      saleItem.add(value);
      index = saleItem.indexWhere((element) => element.id == value.id);
    } else {
      var data = int.parse(saleItem[index].cartquantity.toString()) + 1; // +=1;
      saleItem[index].cartquantity = data;
    }
    calculateAmount(index);
    saleItem.refresh();
  }

  decrementItem(index) {
    if (saleItem[index].cartquantity! > 1) {
      saleItem[index].cartquantity = saleItem[index].cartquantity! - 1;
      saleItem.refresh();
    }
    calculateAmount(index);
  }

  incrementItem(index) {
    saleItem[index].cartquantity = saleItem[index].cartquantity! + 1;
    saleItem.refresh();

    calculateAmount(index);
  }

  calculateAmount(index) {
    grandTotal.value = 0;
    balance.value = 0;
    textEditingControllerAmount.text = "0";
    if (saleItem.isNotEmpty) {
      saleItem[index].amount =
          saleItem[index].cartquantity! * saleItem[index].buyingPrice!;
    }

    if (saleItem.isNotEmpty) {
      saleItem.forEach((element) {
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
    saleItem.removeAt(index);
    saleItem.refresh();
    calculateAmount(index);
  }

  Future<void> scanQR({required shopId, required context}) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      productController.searchProductController.text = barcodeScanRes;
      await productController.searchProduct(shopId, "product");
      if (productController.products.isEmpty) {
        showSnackBar(
            message: "product doesnot exist in this shop", color: Colors.red);
      } else {
        for (int i = 0; i < productController.products.length; i++) {
          changesaleItem(productController.products[i]);
        }
      }
    } on PlatformException {
      showSnackBar(
          message: 'Failed to get platform version.', color: Colors.red);
    }
  }

  calculateSalesAmount() {
    var subTotal = 0;
    saleItem.forEach((element) {
      subTotal = subTotal + (element.buyingPrice! * element.cartquantity!);
    });
    return subTotal;
  }

  calculatePurchasemount() {
    var subTotal = 0;
    purchasedItems.forEach((element) {
      subTotal = subTotal + element.total!;
    });
    return subTotal;
  }

  void returnInvoiceItem(InvoiceItem sale, int quatity, Invoice invoice) async {
    try {
      returningIvoiceLoad.value = true;
      var response = await Purchases().retunPurchase(sale.id, quatity);
      if (response["status"] != false) {
        getPurchaseOrderItems(purchaseId: invoice.id);
      } else {
        showSnackBar(message: response["message"], color: Colors.red);
      }
      returningIvoiceLoad.value = false;
    } catch (e) {
      returningIvoiceLoad.value = false;
    }
  }

  paySupplierCredit(
      {required String amount, required Invoice salesBody}) async {
    try {
      Map<String, dynamic> body = {
        "supplier": salesBody.supplier,
        "amount": int.parse(amount),
        "attendant": Get.find<AuthController>().usertype.value == "admin"
            ? Get.find<AuthController>().currentUser.value!.id
            : Get.find<AttendantController>().attendant.value!.id,
      };
      var response =
          await Purchases().createPayment(body: body, saleId: salesBody.id);
      if (response["status"] = true) {
        int index =
            creditPurchases.indexWhere((element) => element.id == salesBody.id);
        creditPurchases[index].balance =
            creditPurchases[index].balance! - int.parse(amount);
        creditPurchases.refresh();
        Get.find<CustomerController>().amountController.clear();
      }
    } catch (e) {
      print(e);
    }
  }
}
