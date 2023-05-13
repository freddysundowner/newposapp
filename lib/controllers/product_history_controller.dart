import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/productTransfer.dart';
import '../models/product_history_model.dart';
import '../models/receipt_item.dart';
import '../services/product.dart';

class ProductHistoryController extends GetxController
    with SingleGetTickerProviderMixin {
  late TabController tabController;
  RxBool gettingHistoryLoad = RxBool(false);
  RxBool loadingSalesHistory = RxBool(false);
  RxList<ProductHistoryModel> product = RxList([]);
  RxList<ProductTransferHistories> productTransferHistories = RxList([]);
  RxList<ReceiptItem> receiptItems = RxList([]);

  getProductHistory(
      {required productId,
      required String type,
      required String stockId}) async {
    try {
      gettingHistoryLoad.value = true;
      var response = await Products().getProductHistory(
          productId: productId, type: type, stockId: stockId);
      if (response["status"] == true) {
        List fetchedHistory = response["body"];
        List<ProductTransferHistories> fetchedProductHistory = fetchedHistory
            .map((e) => ProductTransferHistories.fromJson(e))
            .toList();
        productTransferHistories.assignAll(fetchedProductHistory);
      } else {
        product.value = [];
      }
      gettingHistoryLoad.value = false;
    } catch (e) {
      print(e);
      gettingHistoryLoad.value = false;
    }
  }

  getHistory({required productId}) async {
    try {
      loadingSalesHistory.value = true;
      var response = await Products().getProductSaleHistory(productId);

      if (response != null) {
        List fetchedHistory = response["body"];
        List<ReceiptItem> fetchedProductHistorys =
            fetchedHistory.map((e) => ReceiptItem.fromJson(e)).toList();
        receiptItems.assignAll(fetchedProductHistorys);
      } else {
        receiptItems.value = [];
      }
      loadingSalesHistory.value = false;
    } catch (e) {
      loadingSalesHistory.value = false;
    }
  }

  @override
  void onInit() {
    tabController = TabController(length: 4, vsync: this);
    super.onInit();
  }

  RxInt tabIndex = RxInt(0);

  final List<Tab> tabs = <Tab>[
    Tab(
      child: Text(
        "Sales",
        style: TextStyle(fontSize: 15),
      ),
    ),
    Tab(
        child: Text(
      "Purchase",
      style: TextStyle(fontSize: 15),
    )),
    Tab(
        child: Text(
      "Transfer",
      style: TextStyle(fontSize: 15),
    )),
    Tab(
        child: Text(
      "Bad Stock",
      style: TextStyle(fontSize: 15),
    )),
  ];
}
