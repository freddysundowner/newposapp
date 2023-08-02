import 'dart:convert';

import 'package:get/get.dart';
import 'package:pointify/Real/schema.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/services/payment.dart';
import 'package:pointify/services/supplier.dart';
import 'package:realm/realm.dart';

import '../controllers/realm_controller.dart';
import '../functions/functions.dart';
import '../main.dart';

class Purchases {
  final RealmController realmService = Get.find<RealmController>();
  final ShopController shopController = Get.find<ShopController>();
  createPurchase(Invoice invoice) async {
    realmService.realm
        .write<Invoice>(() => realmService.realm.add<Invoice>(invoice));
  }

  RealmResults<InvoiceItem> getInvoiceItems({Shop? shop}) {
    RealmResults<InvoiceItem> invoices = realmService.realm.query<InvoiceItem>(
        r'shop == $0 AND TRUEPREDICATE SORT(createdAt DESC)',
        [shop!.id.toString()]);
    return invoices;
  }

  RealmResults<Invoice> getPurchase(
      {Supplier? supplier,
      bool? onCredit,
      DateTime? fromDate,
      Shop? shop,
      DateTime? toDate}) {
    if (supplier != null) {
      RealmResults<Invoice> invoices = realmService.realm.query<Invoice>(
          r'supplier == $0 AND TRUEPREDICATE SORT(createdAt DESC)', [supplier]);
      if (onCredit == true) {
        RealmResults<Invoice> ic = invoices
            .query("balance < 0  AND TRUEPREDICATE SORT(createdAt DESC)");
        return _attendantFilter(ic);
      }
      return _attendantFilter(invoices);
    }
    RealmResults<Invoice> invoices;
    if (shop == null) {
      invoices = realmService.realm.query<Invoice>(
          r'shop == $0 AND TRUEPREDICATE SORT(createdAt DESC)',
          [shopController.currentShop.value]);
    } else {
      invoices = realmService.realm.query<Invoice>(
          r'shop == $0 AND TRUEPREDICATE SORT(createdAt DESC)', [shop]);
    }

    if (fromDate != null) {
      RealmResults<Invoice> invoicesResponse = invoices.query(
          'dated > ${fromDate.millisecondsSinceEpoch} AND dated < ${toDate!.millisecondsSinceEpoch} AND TRUEPREDICATE SORT(createdAt DESC)');
      return _attendantFilter(invoicesResponse);
    }
    return _attendantFilter(invoices);
  }

  deleteInvoices(List<Invoice> sales) {
    realmService.realm.write(() {
      realmService.realm.deleteMany(sales);
    });
  }

  deleteInvoiceItems(List<InvoiceItem> sales) {
    realmService.realm.write(() {
      realmService.realm.deleteMany(sales);
    });
  }

  deleteInvoiceItemByProductId(List<InvoiceItem> sales) {
    realmService.realm.write(() {
      // realmService.realm.de
    });
  }

  _attendantFilter(RealmResults<Invoice> data) {
    if (userController.switcheduser.value != null) {
      return data
          .query("attendantId == \$0 ", [userController.switcheduser.value!]);
    }
    if (checkPermission(category: "suppliers", permission: "all_purchases") ||
        userController.user.value!.usertype == "admin") {
      return data;
    }
    if (userController.user.value != null &&
        userController.user.value!.usertype == "attendant") {
      return data.query("attendantId == \$0 ", [userController.user.value!]);
    }
    return data;
  }

  getIvoiceById(Invoice? invoice) {
    Invoice? invoices = realmService.realm.find(invoice!.id);
    return invoices;
  }

  createPayment(Invoice invoice, int amount) {
    var newbalance = invoice.balance!.abs() - amount;
    realmService.realm.write(() {
      invoice.balance = newbalance * -1;
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
      return _attendantReturnsFilter(returns);
    }
    RealmResults<InvoiceItem> returns =
        realmService.realm.query<InvoiceItem>('invoice == \$0 ', [invoice]);
    return _attendantReturnsFilter(returns);
  }

  _attendantReturnsFilter(RealmResults<InvoiceItem> data) {
    if (userController.switcheduser.value != null) {
      return data
          .query("attendantId == \$0 ", [userController.switcheduser.value!]);
    }
    if (checkPermission(category: "suppliers", permission: "all_purchases") ||
        userController.user.value!.usertype == "admin") {
      return data;
    }
    if (userController.user.value != null &&
        userController.user.value!.usertype == "attendant") {
      return data.query("attendantId == \$0 ", [userController.user.value!]);
    }
    return data;
  }
}
