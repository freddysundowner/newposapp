import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/product_history_controller.dart';
import '../../models/product_history_model.dart';
import '../../models/product_sales_history.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';

class ProductHistory extends StatelessWidget {
  final ProductModel product;

  ProductHistory({Key? key, required this.product}) : super(key: key);
  ProductHistoryController productHistoryController =
      Get.find<ProductHistoryController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          titleSpacing: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios, color: Colors.black)),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              majorTitle(
                  title: "${product.name!}", color: Colors.black, size: 16.0),
              minorTitle(title: "History", color: Colors.grey),
            ],
          ),
        ),
        body: Column(children: [
          Container(
            color: Colors.white,
            height: kToolbarHeight,
            child: TabBar(
              indicatorColor: AppColors.mainColor,
              indicatorWeight: 3,
              controller: productHistoryController.tabController,
              labelColor: AppColors.mainColor,
              unselectedLabelColor: Colors.black,
              onTap: (index) {
                productHistoryController.changeTabIndex(index);
              },
              tabs: productHistoryController.tabs,
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.grey.withOpacity(0.3),
              child: TabBarView(
                  controller: productHistoryController.tabController,
                  children: [
                    SalesPages(
                        productHistoryController: productHistoryController,
                        productId: product.id,
                        type: "cash"),
                    HistoryPages(
                        productHistoryController: productHistoryController,
                        productId: product.id,
                        type: "purchase"),
                    HistoryPages(
                        productHistoryController: productHistoryController,
                        productId: product.id,
                        type: "transfer"),
                    HistoryPages(
                      productHistoryController: productHistoryController,
                      productId: product.id,
                      type: "badstock",
                    ),
                  ]),
            ),
          )
        ]));
  }
}

class HistoryPages extends StatelessWidget {
  final type;
  final ProductHistoryController productHistoryController;
  final productId;

  HistoryPages(
      {Key? key,
      required this.productHistoryController,
      required this.productId,
      required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    productHistoryController.getProductHistory(
        productId: productId, type: type);
    return Obx(() {
      return productHistoryController.product.length == 0
          ? Center(
              child: Text("There are no iems to display"),
            )
          : ListView.builder(
              shrinkWrap: true,
              itemCount: productHistoryController.product.length,
              // physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                ProductHistoryModel productBody =
                    productHistoryController.product.elementAt(index);

                return productHistoryContainer(productBody);
              });
    });
  }

  Widget productHistoryContainer(ProductHistoryModel productBody) {
    ShopController shopController = Get.find<ShopController>();
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        color: Colors.white.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              child: Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${productBody.product!.name}".capitalize!,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Text(
                        "${productBody.product!.category}",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      Text('Qty ${productBody.quantity}'),
                      Text(
                          '${DateFormat("MMM dd,yyyy, hh:m a").format(productBody.createdAt!)} '),
                    ],
                  )
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Text(
                      'BP/=  ${shopController.currentShop.value?.currency}.${productBody.product!.buyingPrice}'),
                  Text(
                      'SP/=  ${shopController.currentShop.value?.currency}.${productBody.product!.sellingPrice![0]}')
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}

class SalesPages extends StatelessWidget {
  final type;
  final ProductHistoryController productHistoryController;
  final productId;

  SalesPages(
      {Key? key,
      required this.productHistoryController,
      required this.productId,
      required this.type})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    productHistoryController.getHistory(productId: productId);

    return Obx(() {
      return productHistoryController.loadingSalesHistory.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : productHistoryController.salesHistory.length == 0
              ? Center(
                  child: Text("There are no iems to display"),
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: productHistoryController.salesHistory.length,
                  itemBuilder: (context, index) {
                    ProductSaleHistory productBody =
                        productHistoryController.salesHistory.elementAt(index);

                    return productHistoryContainer(productBody);
                  });
    });
  }

  Widget productHistoryContainer(ProductSaleHistory productBody) {
    ShopController shopController = Get.find<ShopController>();
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        color: Colors.white.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              child: Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${productBody.product!.name}".capitalize!,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Text(
                        "${productBody.product!.category}",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      Text('Qty ${productBody.itemCount}'),
                      Text(
                          '${DateFormat("MMM dd,yyyy, hh:m a").format(productBody.createdAt!)} '),
                    ],
                  )
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Text(
                      'BP/= ${shopController.currentShop.value?.currency}.${productBody.product!.buyingPrice}'),
                  Text(
                      'SP/=  ${shopController.currentShop.value?.currency}.${productBody.total}')
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
