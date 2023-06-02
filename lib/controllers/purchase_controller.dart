import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/controllers/supplierController.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/screens/purchases/all_purchases.dart';
import 'package:pointify/services/product.dart';
import 'package:pointify/services/purchases.dart';
import 'package:pointify/services/sales.dart';
import 'package:pointify/widgets/alert.dart';
import 'package:pointify/widgets/loading_dialog.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';

import '../Real/Models/schema.dart';
import '../services/supplier.dart';
import '../widgets/snackBars.dart';
import 'CustomerController.dart';
import 'realm_controller.dart';

class PurchaseController extends GetxController {
  Rxn<Invoice> invoice = Rxn(null);
  RxList<Invoice> purchasedItems = RxList([]);
  RxList<Invoice> creditPurchases = RxList([]);
  Rxn<Invoice> currentInvoice = Rxn(null);
  RxList<InvoiceItem> currentInvoiceReturns = RxList([]);

  RxBool returningIvoiceLoad = RxBool(false);
  RxBool getPurchaseLoad = RxBool(false);
  RxBool getPurchaseByDateLoad = RxBool(false);
  RxBool getPurchaseOrderItemLoad = RxBool(false);
  TextEditingController textEditingControllerAmount = TextEditingController();
  ProductController productController = Get.find<ProductController>();
  ShopController shopController = Get.find<ShopController>();

  createPurchase({required context, required screen}) async {
    if (invoice.value!.balance! > 0 && invoice.value!.supplier == null) {
      generalAlert(title: "Error", message: "please select supplier");
    } else {
      Navigator.pop(context);
      Invoice invoiceData = invoice.value!;
      invoiceData.shop = shopController.currentShop.value;
      invoiceData.attendantId = Get.find<UserController>().user.value;
      invoiceData.receiptNumber = getRandomString(10);
      invoiceData.onCredit = invoiceData.balance! > 0;
      invoiceData.createdAt = DateTime.now();
      invoiceData.productCount = invoiceData.items.length;

      if (_onCredit(invoiceData)) {
        var balance = (invoiceData.supplier!.balance ?? 0);
        if (invoiceData.balance == 0) {
          invoiceData.balance = invoiceData.total! * -1;
        } else {
          invoiceData.balance = invoiceData.balance! * -1;
        }
        if (invoiceData.balance! > balance) {
          balance = (balance.abs() + invoiceData.balance!.abs()) * -1;
        } else {
          balance = balance.abs() - invoiceData.balance!.abs();
          if (balance < 0) {
            invoiceData.balance = balance;
          } else {
            invoiceData.balance = 0;
          }
        }
        SupplierService().updateSupplierWalletbalance(invoiceData.supplier!,
            amount: balance);
      }

      //save purchase invoice
      Purchases().createPurchase(invoiceData);

      //update product quantities
      for (var element in invoiceData.items) {
        Products().updateProductPart(
            product: element.product!,
            quantity: element.itemCount! + element.product!.quantity!);
        //create product history
        ProductHistoryModel productHistoryModel = ProductHistoryModel(
            ObjectId(),
            quantity: element.product!.quantity!,
            supplier: invoiceData.supplier == null
                ? ""
                : invoiceData.supplier!.id.toString(),
            shop: invoiceData.shop!.id.toString(),
            product: element.product,
            type: "purchases");
        Products().createProductHistory(productHistoryModel);
      }
      invoice.value = null;
      refresh();
      Get.back();
    }
  }

  getPurchase({
    Supplier? supplier,
    bool? onCredit,
  }) async {
    purchasedItems.clear();
    RealmResults<Invoice> invoices =
        Purchases().getPurchase(supplier: supplier, onCredit: onCredit);
    purchasedItems.addAll(invoices.map((e) => e).toList());
  }

  getIvoiceById(Invoice invoice) {
    Invoice? invoiceResponse = Purchases().getIvoiceById(invoice);
    currentInvoice.value = invoiceResponse!;

    currentInvoice.refresh();
  }

  addNewPurchase(InvoiceItem value) {
    var index = -1;
    if (invoice.value != null) {
      index = invoice.value!.items
          .indexWhere((element) => element.product!.id == value.product!.id);
    }
    if (index == -1) {
      if (invoice.value == null) {
        invoice.value = Invoice(
          ObjectId(),
          items: [value],
        );
      } else {
        invoice.value =
            Invoice(invoice.value!.id, items: [...invoice.value!.items, value]);
      }
      index =
          invoice.value!.items.indexWhere((element) => element.id == value.id);
    } else {
      var data = int.parse(invoice.value!.items[index].itemCount.toString()) +
          1; // +=1;
      invoice.value?.items[index].itemCount = data;
    }
    calculateAmount(index);
    invoice.refresh();
  }

  decrementItem(index) {
    if (invoice.value!.items[index].itemCount! > 1) {
      invoice.value?.items[index].itemCount =
          invoice.value!.items[index].itemCount! - 1;
      invoice.refresh();
    }
    calculateAmount(index);
  }

  incrementItem(index) {
    invoice.value?.items[index].itemCount =
        invoice.value!.items[index].itemCount! + 1;
    invoice.refresh();

    calculateAmount(index);
  }

  calculateAmount(index) {
    invoice.value!.total = 0;
    invoice.value!.balance = 0;
    textEditingControllerAmount.text = "0";

    invoice.value!.total = invoice.value!.items.fold(
        0,
        (previousValue, element) =>
            previousValue! +
            (element.product!.buyingPrice! * element.itemCount!));

    textEditingControllerAmount.text = invoice.value!.total.toString();

    invoice.value!.balance =
        invoice.value!.total! - int.parse(textEditingControllerAmount.text);
    if (index == -1) {
      return;
    }

    invoice.value?.items[index].total =
        invoice.value!.items[index].product!.buyingPrice! *
            invoice.value!.items[index!].itemCount!;
    invoice.refresh();
  }

  removeFromList(index) {
    invoice.value?.items.removeAt(index);
    invoice.refresh();
    calculateAmount(-1);
  }

  Future<void> scanQR({required shopId, required context}) async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      productController.searchProductController.text = barcodeScanRes;
      productController.getProductsBySort(type: "all");
      if (productController.products.isEmpty) {
        showSnackBar(
            message: "product doesnot exist in this shop", color: Colors.red);
      } else {
        for (int i = 0; i < productController.products.length; i++) {
          // addNewPurchase(productController.products[i]);
        }
      }
    } on PlatformException {
      showSnackBar(
          message: 'Failed to get platform version.', color: Colors.red);
    }
  }

  calculateSalesAmount() {
    var subTotal = 0;
    invoice.value?.items.forEach((element) {
      subTotal = subTotal + (element.price! * element.itemCount!);
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

  _onCredit(Invoice invoice) => invoice.balance!.abs() > 0;
  void returnInvoiceItem(
      InvoiceItem invoiceItem, int quatity, Invoice invoice) {
    var amount = quatity * invoiceItem.price!; // amount to be returned
    InvoiceItem returnedReceipt = InvoiceItem(ObjectId(),
        itemCount: quatity,
        product: invoiceItem.product,
        total: amount,
        price: invoiceItem.price,
        type: "return",
        invoice: invoice,
        createdAt: DateTime.now(),
        attendantid: Get.find<UserController>().user.value,
        supplier: invoice.supplier);
    Purchases().createSaleReceiptItem(returnedReceipt);

    //increate product quantity
    Products().updateProductPart(
        product: invoiceItem.product!,
        quantity: invoiceItem.product!.quantity! - quatity);

    //update receit item sold items qty and total
    var newqty = invoiceItem.itemCount! - quatity;
    Purchases().updateInvoiceItem(
        invoiceItem: invoiceItem,
        quantity: newqty,
        total: newqty * invoiceItem.price!);

    // update receipt qty returned and re-calculate the total
    Purchases().updateInvoice(
        invoice: invoice,
        total: invoice.items.fold(
            0,
            (previousValue, element) =>
                previousValue! + (element.itemCount! * element.price!)),
        returnedquantity: quatity,
        creditBalance: (invoice.balance!.abs() - amount) * -1,
        returnedItems: returnedReceipt);

    // //refund to the wallet if its was a wallet sale
    // //if it was credit sale return the paid amount to the wallet
    if (_onCredit(invoice)) {
      //what was already paid
      var newBalance =
          invoice.supplier!.balance! + (quatity * invoiceItem.price!);
      SupplierService()
          .updateSupplierWalletbalance(invoice.supplier!, amount: newBalance);
    }
    getIvoiceById(invoice);
    currentInvoice.refresh();
  }

  paySupplierCredit({required String amount, required Invoice invoice}) async {
    Purchases().createPayment(invoice, int.parse(amount));
    getIvoiceById(invoice);
    currentInvoice.refresh();
  }

  void getReturns({Supplier? supplier, Invoice? invoice}) {
    currentInvoiceReturns.clear();
    RealmResults<InvoiceItem> response =
        Purchases().getReturns(invoice: invoice, supplier: supplier);
    List<InvoiceItem> invoiceReturn = response.map((e) => e).toList();
    for (var e in invoiceReturn) {
      if (currentInvoiceReturns
              .indexWhere((element) => element.invoice!.id == e.invoice!.id) ==
          -1) {
        print(e.invoice!.id);
        currentInvoiceReturns.add(e);
      }
    }
  }
}
