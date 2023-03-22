// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/stock_transfer_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/models/stockTransferHistoryModel.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/stock/transfer_history.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:flutterpos/widgets/no_items_found.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/shop_controller.dart';

class TransferHistoryView extends StatelessWidget {
  final StockTransferHistory stockTransferHistory;

  TransferHistoryView({Key? key, required this.stockTransferHistory})
      : super(key: key);
  ShopController shopController = Get.find<ShopController>();
  StockTransferController stockTransferController =
      Get.find<StockTransferController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
          backgroundColor: Colors.white
              ,
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
                  Text('Transfer History View',style: TextStyle(color: Colors.white),),
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
              : stockTransferHistory.product!.length == 0
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
                            rows: List.generate(
                                shopController.AdminShops.length, (index) {
                              ProductModel productModel = stockTransferHistory
                                  .product!
                                  .elementAt(index);
                              final y = productModel.name;
                              final x = productModel.quantity;
                              final z = productModel.createdAt!;

                              return DataRow(cells: [
                                DataCell(Container(child: Text(y!))),
                                DataCell(Container(child: Text(x.toString()))),
                                DataCell(Container(
                                    child: Text(
                                        DateFormat("dd/MM/yyyy").format(z)))),
                              ]);
                            }),
                          ),
                        ),
                      ),
                    );
        }),
        smallScreen: Obx(() {
          return stockTransferController.gettingTransferHistoryLoad.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : stockTransferHistory.product!.length == 0
                  ? noItemsFound(context, true)
                  : ListView.builder(
                      itemCount: stockTransferHistory.product!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        ProductModel productModel =
                            stockTransferHistory.product!.elementAt(index);
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
                                      "${productModel.name}".capitalize!,
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
