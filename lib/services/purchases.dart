import 'dart:convert';

import 'package:get/get.dart';
import 'package:pointify/Real/Models/schema.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/screens/cash_flow/payment_history.dart';
import 'package:pointify/services/apiurls.dart';
import 'package:pointify/services/client.dart';
import 'package:pointify/services/payment.dart';
import 'package:pointify/services/product.dart';
import 'package:pointify/services/supplier.dart';
import 'package:realm/realm.dart';

import '../controllers/realm_controller.dart';

class Purchases {
  final RealmController realmService = Get.find<RealmController>();
  final ShopController shopController = Get.find<ShopController>();
  createPurchase(Invoice invoice) async {
    realmService.realm
        .write<Invoice>(() => realmService.realm.add<Invoice>(invoice));
  }

  RealmResults<Invoice> getPurchase({Supplier? supplier, bool? onCredit}) {
    if (supplier != null) {
      RealmResults<Invoice> invoices = realmService.realm.query<Invoice>(
          r'supplier == $0 AND TRUEPREDICATE SORT(createdAt DESC)', [supplier]);
      if (onCredit == true) {
        return invoices
            .query("balance < 0  AND TRUEPREDICATE SORT(createdAt DESC)");
      }
      return invoices;
    }
    RealmResults<Invoice> invoices = realmService.realm.query<Invoice>(
        r'shop == $0 AND TRUEPREDICATE SORT(createdAt DESC)',
        [shopController.currentShop.value]);
    return invoices;
  }

  getIvoiceById(Invoice? invoice) {
    Invoice? invoices = realmService.realm.find(invoice!.id);
    return invoices;
  }

  returnOrderToSupplier(uid) async {
    var response = await DbBase()
        .databaseRequest("${purchases}returns/$uid", DbBase().patchRequestType);
    var data = jsonDecode(response);
    return data;
  }

  createPayment(Invoice invoice, int amount) {
    var newbalance = invoice.balance! - amount;
    realmService.realm.write(() {
      invoice.balance = newbalance;
      invoice.onCredit = newbalance >= 0;
    });
    PayHistory payHistory = PayHistory(ObjectId(),
        attendant: Get.find<UserController>().user.value,
        amountPaid: amount,
        balance: newbalance,
        invoice: invoice,
        createdAt: DateTime.now());
    Payment().createPayHistory(payHistory);
    var wbalance = invoice.supplier!.balance! + amount;
    SupplierService()
        .updateSupplierWalletbalance(invoice.supplier!, amount: wbalance);
  }

  updateInvoiceItem(
      {required InvoiceItem invoiceItem, int? quantity, int? total}) async {
    realmService.realm.write(() {
      if (quantity != null) {
        invoiceItem.itemCount = quantity;
      }
      if (total != null) {
        invoiceItem.total = total;
      }
    });
  }

  updateInvoice(
      {required Invoice invoice,
      int? quantity,
      int? total,
      int? creditBalance,
      int? returnedquantity,
      var returnedItems}) async {
    realmService.realm.write(() {
      if (quantity != null) {
        invoice.productCount = quantity;
      }
      if (total != null) {
        invoice.total = total;
      }
      if (creditBalance != null) {
        invoice.balance = creditBalance;
      }
      if (returnedItems != null) {
        invoice.returneditems.add(returnedItems);
      }
    });
  }

  createSaleReceiptItem(InvoiceItem invoiceItem) async {
    realmService.realm.write<InvoiceItem>(
        () => realmService.realm.add<InvoiceItem>(invoiceItem));
  }

  RealmResults<InvoiceItem> getReturns({Supplier? supplier, Invoice? invoice}) {
    if (supplier != null) {
      RealmResults<InvoiceItem> returns =
          realmService.realm.query<InvoiceItem>('supplier == \$0 ', [supplier]);
      return returns;
    }
    RealmResults<InvoiceItem> returns =
        realmService.realm.query<InvoiceItem>('invoice == \$0 ', [invoice]);
    return returns;
  }
}
