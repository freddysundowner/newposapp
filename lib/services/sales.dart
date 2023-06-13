import 'dart:convert';

import 'package:get/get.dart';
import 'package:pointify/Real/Models/schema.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/main.dart';
import 'package:pointify/services/apiurls.dart';
import 'package:realm/realm.dart';

import '../controllers/realm_controller.dart';
import 'client.dart';

class Sales {
  final RealmController realmService = Get.find<RealmController>();
  final ShopController shopController = Get.find<ShopController>();
  createSale(SalesModel salesModel) async {
    realmService.realm.write<SalesModel>(
        () => realmService.realm.add<SalesModel>(salesModel));
  }

  createSaleReceiptItem(ReceiptItem receiptItem) async {
    realmService.realm.write<ReceiptItem>(
        () => realmService.realm.add<ReceiptItem>(receiptItem));
  }

  createSales(Map<String, dynamic> salesdata) async {
    var response = await DbBase()
        .databaseRequest(sales, DbBase().postRequestType, body: salesdata);
    var data = jsonDecode(response);
    return data;
  }

  updateReceiptItem(
      {required ReceiptItem receiptItem, int? quantity, int? total}) async {
    realmService.realm.write(() {
      if (quantity != null) {
        receiptItem.quantity = quantity;
      }
      if (total != null) {
        receiptItem.total = total;
      }
    });
  }

  updateReceipt(
      {required SalesModel receipt,
      int? quantity,
      int? total,
      int? creditBalance,
      int? returnedquantity,
      var returnedItems}) async {
    realmService.realm.write(() {
      if (quantity != null) {
        receipt.quantity = quantity;
      }
      if (total != null) {
        receipt.grandTotal = total;
      }
      if (creditBalance != null) {
        receipt.creditTotal = creditBalance;
      }
      if (returnedquantity != null) {
        receipt.returnsCount = (receipt.returnsCount ?? 0) + returnedquantity;
      }
      if (returnedItems != null) {
        receipt.returneditems.add(returnedItems);
      }
    });
  }

  RealmResults<SalesModel> getSales(
      {onCredit = false,
      DateTime? fromDate,
      DateTime? toDate,
      CustomerModel? customer,
      String receipt = "",
      String total = ""}) {
    String filter = "";

    if (onCredit) {
      filter += " AND creditTotal < 0";
    }
    if (customer != null) {
      RealmResults<SalesModel> invoices = realmService.realm.query<SalesModel>(
          'customerId == \$0  $filter AND TRUEPREDICATE SORT(createdAt DESC)',
          [customer]);
      return _attendantFilter(invoices);
    }
    RealmResults<SalesModel> invoices = realmService.realm.query<SalesModel>(
        'shop == \$0 $filter AND TRUEPREDICATE SORT(createdAt DESC)',
        [shopController.currentShop.value]);
    if (fromDate == null) {
      if (receipt.isNotEmpty) {
        var ii = invoices.query("receiptNumber BEGINSWITH \$0 ", [receipt]);
        return ii;
      }
      return _attendantFilter(invoices);
    }

    if (invoices.isNotEmpty) {
      RealmResults<SalesModel> dateinvoices = invoices.query(
          'dated > ${fromDate.millisecondsSinceEpoch} AND dated < ${toDate!.millisecondsSinceEpoch} AND TRUEPREDICATE SORT(createdAt DESC)');

      return _attendantFilter(dateinvoices);
    }
    return _attendantFilter(invoices);
  }

  _attendantFilter(RealmResults<SalesModel> data) {
    if (userController.switcheduser.value != null) {
      return data
          .query("attendantId == \$0 ", [userController.switcheduser.value!]);
    }
    if (checkPermission(category: "customers", permission: "all_sales") ||
        userController.user.value!.usertype == "admin") {
      return data;
    }
    if (userController.user.value != null &&
        userController.user.value!.usertype == "attendant") {
      return data.query("attendantId == \$0 ", [userController.user.value!]);
    }
    return data;
  }

  SalesModel? getSalesBySaleId(ObjectId id) {
    SalesModel? invoice = realmService.realm.find(id);
    return invoice;
  }

  RealmResults<ReceiptItem>? getSalesByProductId(Product product) {
    RealmResults<ReceiptItem>? invoices =
        realmService.realm.query<ReceiptItem>('product == \$0 ', [product]);
    return invoices;
  }

  RealmResults<ReceiptItem> getSaleReceipts(
      {CustomerModel? customerModel,
      SalesModel? salesModel,
      String? date,
      DateTime? fromDate,
      DateTime? toDate}) {
    if (fromDate != null && toDate != null) {
      RealmResults<ReceiptItem> returns = realmService.realm.query<ReceiptItem>(
          'soldOn > ${fromDate.millisecondsSinceEpoch} AND soldOn < ${toDate.millisecondsSinceEpoch} AND shop == \$0',
          [shopController.currentShop.value]);
      return returns;
    }
    if (date!.isNotEmpty) {
      RealmResults<ReceiptItem> returns = realmService.realm.query<ReceiptItem>(
          "date == '$date' AND shop == \$0",
          [shopController.currentShop.value]);
      return returns;
    }
    if (customerModel != null) {
      RealmResults<ReceiptItem> returns = realmService.realm
          .query<ReceiptItem>('customerId == \$0', [customerModel]);
      return returns;
    }
    RealmResults<ReceiptItem> returns =
        realmService.realm.query<ReceiptItem>('receipt == \$0', [salesModel]);
    return returns;
  }

  RealmResults<SalesModel> getCustomerReturns(CustomerModel customerModel) {
    RealmResults<SalesModel> receipts = realmService.realm
        .query<SalesModel>('customer == \$0 ', [customerModel]);
    return receipts;
  }

  retunSale(SalesReturn salesReturn) async {
    realmService.realm.write<SalesReturn>(
        () => realmService.realm.add<SalesReturn>(salesReturn));
  }

  createPayment({required Map<String, dynamic> body, required saleId}) async {
    var response = await DbBase().databaseRequest(
        "${sales}pay/credit/$saleId", DbBase().postRequestType,
        body: body);
    return jsonDecode(response);
  }

  getPaymentHistory({required String id, required String type}) async {
    var response = await DbBase().databaseRequest(
        type == "purchase"
            ? "${purchases}paymenthistory/$id"
            : "${sales}paymenthistory/$id",
        DbBase().getRequestType);
    return jsonDecode(response);
  }
}
