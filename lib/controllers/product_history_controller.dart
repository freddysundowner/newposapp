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

      List data=[
        {
          "_id": "63fdd0f98b658aafbf4e228b",
          "product": {
            "_id": "63fdd0f98b658aafbf4e2289",
            "name": "triple",
            "quantity": 193,
            "category": "63fdce708b658aafbf4e21ec",
            "stockLevel": 110,
            "sellingPrice": [
              "1300"
            ],
            "discount": 0,
            "shop": {
              "_id": "63fa089e46721b7480474be5",
              "name": "apple",
              "location": "nakuru",
              "owner": "63f9efe3879e16801054a0b0",
              "type": "electronics",
              "currency": "ARS",
              "createdAt": "2023-02-25T13:09:50.801Z",
              "updatedAt": "2023-02-27T10:53:46.012Z",
              "__v": 0
            },
            "attendant": "63f9efe3879e16801054a0b0",
            "buyingPrice": 1200,
            "minSellingPrice": 1300,
            "badStock": 0,
            "description": "",
            "measureUnit": "",
            "deleted": false,
            "counted": false,
            "createdAt": "2023-02-28T10:01:29.081Z",
            "updatedAt": "2023-03-04T08:44:25.515Z",
            "__v": 0
          },
          "type": "purchase",
          "quantity": 200,
          "shop": "63fa089e46721b7480474be5",
          "attendantId": null,
          "stockTransfer": null,
          "supplier": "63fa090246721b7480474bf9",
          "createdAt": "2023-02-28T10:01:29.083Z",
          "updatedAt": "2023-02-28T10:01:29.083Z",
          "__v": 0
        },
        {
          "_id": "63fdd0f98b658aafbf4e228b",
          "product": {
            "_id": "63fdd0f98b658aafbf4e2289",
            "name": "triple",
            "quantity": 193,
            "category": "63fdce708b658aafbf4e21ec",
            "stockLevel": 110,
            "sellingPrice": [
              "1300"
            ],
            "discount": 0,
            "shop": {
              "_id": "63fa089e46721b7480474be5",
              "name": "apple",
              "location": "nakuru",
              "owner": "63f9efe3879e16801054a0b0",
              "type": "electronics",
              "currency": "ARS",
              "createdAt": "2023-02-25T13:09:50.801Z",
              "updatedAt": "2023-02-27T10:53:46.012Z",
              "__v": 0
            },
            "attendant": "63f9efe3879e16801054a0b0",
            "buyingPrice": 1200,
            "minSellingPrice": 1300,
            "badStock": 0,
            "description": "",
            "measureUnit": "",
            "deleted": false,
            "counted": false,
            "createdAt": "2023-02-28T10:01:29.081Z",
            "updatedAt": "2023-03-04T08:44:25.515Z",
            "__v": 0
          },
          "type": "purchase",
          "quantity": 200,
          "shop": "63fa089e46721b7480474be5",
          "attendantId": null,
          "stockTransfer": null,
          "supplier": "63fa090246721b7480474bf9",
          "createdAt": "2023-02-28T10:01:29.083Z",
          "updatedAt": "2023-02-28T10:01:29.083Z",
          "__v": 0
        },
        {
          "_id": "63fdd0f98b658aafbf4e228b",
          "product": {
            "_id": "63fdd0f98b658aafbf4e2289",
            "name": "triple",
            "quantity": 193,
            "category": "63fdce708b658aafbf4e21ec",
            "stockLevel": 110,
            "sellingPrice": [
              "1300"
            ],
            "discount": 0,
            "shop": {
              "_id": "63fa089e46721b7480474be5",
              "name": "apple",
              "location": "nakuru",
              "owner": "63f9efe3879e16801054a0b0",
              "type": "electronics",
              "currency": "ARS",
              "createdAt": "2023-02-25T13:09:50.801Z",
              "updatedAt": "2023-02-27T10:53:46.012Z",
              "__v": 0
            },
            "attendant": "63f9efe3879e16801054a0b0",
            "buyingPrice": 1200,
            "minSellingPrice": 1300,
            "badStock": 0,
            "description": "",
            "measureUnit": "",
            "deleted": false,
            "counted": false,
            "createdAt": "2023-02-28T10:01:29.081Z",
            "updatedAt": "2023-03-04T08:44:25.515Z",
            "__v": 0
          },
          "type": "purchase",
          "quantity": 200,
          "shop": "63fa089e46721b7480474be5",
          "attendantId": null,
          "stockTransfer": null,
          "supplier": "63fa090246721b7480474bf9",
          "createdAt": "2023-02-28T10:01:29.083Z",
          "updatedAt": "2023-02-28T10:01:29.083Z",
          "__v": 0
        },
        {
          "_id": "63fdd0f98b658aafbf4e228b",
          "product": {
            "_id": "63fdd0f98b658aafbf4e2289",
            "name": "triple",
            "quantity": 193,
            "category": "63fdce708b658aafbf4e21ec",
            "stockLevel": 110,
            "sellingPrice": [
              "1300"
            ],
            "discount": 0,
            "shop": {
              "_id": "63fa089e46721b7480474be5",
              "name": "apple",
              "location": "nakuru",
              "owner": "63f9efe3879e16801054a0b0",
              "type": "electronics",
              "currency": "ARS",
              "createdAt": "2023-02-25T13:09:50.801Z",
              "updatedAt": "2023-02-27T10:53:46.012Z",
              "__v": 0
            },
            "attendant": "63f9efe3879e16801054a0b0",
            "buyingPrice": 1200,
            "minSellingPrice": 1300,
            "badStock": 0,
            "description": "",
            "measureUnit": "",
            "deleted": false,
            "counted": false,
            "createdAt": "2023-02-28T10:01:29.081Z",
            "updatedAt": "2023-03-04T08:44:25.515Z",
            "__v": 0
          },
          "type": "purchase",
          "quantity": 200,
          "shop": "63fa089e46721b7480474be5",
          "attendantId": null,
          "stockTransfer": null,
          "supplier": "63fa090246721b7480474bf9",
          "createdAt": "2023-02-28T10:01:29.083Z",
          "updatedAt": "2023-02-28T10:01:29.083Z",
          "__v": 0
        },
        {
          "_id": "63fdd0f98b658aafbf4e228b",
          "product": {
            "_id": "63fdd0f98b658aafbf4e2289",
            "name": "triple",
            "quantity": 193,
            "category": "63fdce708b658aafbf4e21ec",
            "stockLevel": 110,
            "sellingPrice": [
              "1300"
            ],
            "discount": 0,
            "shop": {
              "_id": "63fa089e46721b7480474be5",
              "name": "apple",
              "location": "nakuru",
              "owner": "63f9efe3879e16801054a0b0",
              "type": "electronics",
              "currency": "ARS",
              "createdAt": "2023-02-25T13:09:50.801Z",
              "updatedAt": "2023-02-27T10:53:46.012Z",
              "__v": 0
            },
            "attendant": "63f9efe3879e16801054a0b0",
            "buyingPrice": 1200,
            "minSellingPrice": 1300,
            "badStock": 0,
            "description": "",
            "measureUnit": "",
            "deleted": false,
            "counted": false,
            "createdAt": "2023-02-28T10:01:29.081Z",
            "updatedAt": "2023-03-04T08:44:25.515Z",
            "__v": 0
          },
          "type": "purchase",
          "quantity": 200,
          "shop": "63fa089e46721b7480474be5",
          "attendantId": null,
          "stockTransfer": null,
          "supplier": "63fa090246721b7480474bf9",
          "createdAt": "2023-02-28T10:01:29.083Z",
          "updatedAt": "2023-02-28T10:01:29.083Z",
          "__v": 0
        }
      ];
      List<ProductHistoryModel> fetchedProductHistory =
      data.map((e) => ProductHistoryModel.fromJson(e)).toList();
      product.assignAll(fetchedProductHistory);
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
