import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/product_history_model.dart';
import '../models/product_sales_history.dart';
import '../services/product.dart';

class ProductHistoryController extends GetxController
    with SingleGetTickerProviderMixin {
  late TabController tabController;
  RxBool gettingHistoryLoad = RxBool(false);
  RxBool loadingSalesHistory = RxBool(false);
  RxList<ProductHistoryModel> product = RxList([]);
  RxList<ProductSaleHistory> salesHistory = RxList([]);

  getProductHistory({required productId, required String type}) async {
    try {
      gettingHistoryLoad.value = true;
      var response = await Products().getProductHistory(productId, type);
      print(response);
      // product.clear();
      if (response["status"] == true) {
        List fetchedHistory = response["body"];
        List<ProductHistoryModel> fetchedProductHistory =
        fetchedHistory.map((e) => ProductHistoryModel.fromJson(e)).toList();
        product.assignAll(fetchedProductHistory);
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
        List<ProductSaleHistory> fetchedProductHistorys =
            fetchedHistory.map((e) => ProductSaleHistory.fromJson(e)).toList();
        salesHistory.assignAll(fetchedProductHistorys);
      } else {
        salesHistory.value = [];
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

  var tabIndex = 0.obs;

  changeTabIndex(int index) {
    tabIndex.value = index;
  }

  final List<Tab> tabs = <Tab>[
    Tab(
      child: Text(
        "Sales",
        style: TextStyle(fontSize: 15),
      ),
    ),
    Tab(
        child: Text(
      "StockIn",
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
