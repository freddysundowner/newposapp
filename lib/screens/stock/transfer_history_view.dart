// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/product_history_controller.dart';
import 'package:flutterpos/controllers/stock_transfer_controller.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/stock/transfer_history.dart';
import 'package:get/get.dart';

import '../../controllers/shop_controller.dart';
import '../../models/productTransfer.dart';
import '../../widgets/no_items_found.dart';

class TransferHistoryView extends StatelessWidget {
  final String id;

  TransferHistoryView({Key? key, required this.id}) : super(key: key) {
    productHistoryController.getProductHistory(
        productId: "", type: "transfer", stockId: id);
  }

  ShopController shopController = Get.find<ShopController>();
  ProductHistoryController productHistoryController =
      Get.find<ProductHistoryController>();
  StockTransferController stockTransferController =
      Get.find<StockTransferController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          leading: IconButton(
            onPressed: () {
              if (MediaQuery.of(context).size.width > 600) {
                Get.find<HomeController>().selectedWidget.value =
                    TransferHistory();
              } else {
                Get.back();
              }
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Transfer History View',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ],
          )),
      body: ResponsiveWidget(
        largeScreen: Obx(() {
          return stockTransferController.gettingTransferHistoryLoad.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : productHistoryController.productTransferHistories!.length == 0
                  ? noItemsFound(context, true)
                  : SingleChildScrollView(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        width: double.infinity,
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.grey),
                          child: DataTable(
                            decoration: BoxDecoration(
                                border: Border.all(
                              width: 1,
                              color: Colors.black,
                            )),
                            columnSpacing: 30.0,
                            columns: [
                              DataColumn(
                                  label: Text('Name',
                                      textAlign: TextAlign.center)),
                              DataColumn(
                                  label: Text('Quantity',
                                      textAlign: TextAlign.center)),
                              DataColumn(
                                  label: Text('Date',
                                      textAlign: TextAlign.center)),
                            ],
                            rows: [],
                          ),
                        ),
                      ),
                    );
        }),
        smallScreen: Obx(() {
          return productHistoryController.gettingHistoryLoad.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : productHistoryController.productTransferHistories!.length == 0
                  ? noItemsFound(context, true)
                  : ListView.builder(
                      itemCount: productHistoryController
                          .productTransferHistories!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        ProductTransferHistories productModel =
                            productHistoryController.productTransferHistories!
                                .elementAt(index);
                        return Container(
                          margin: EdgeInsets.all(5),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5)),
                          child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${productModel.product!.name!}"
                                          .capitalize!,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      "Qty ${productModel.quantity}",
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w400),
                                    )
                                  ],
                                ),
                                IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.clear,
                                      color: Colors.purple,
                                    ))
                              ]),
                        );
                      });
        }),
      ),
    );
  }
}
