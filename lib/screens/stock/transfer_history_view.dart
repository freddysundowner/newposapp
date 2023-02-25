// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/stock_transfer_controller.dart';
import 'package:get/get.dart';

import '../../controllers/shop_controller.dart';

class TransferHistoryView extends StatelessWidget {
  TransferHistoryView({Key? key}) : super(key: key);
  ShopController shopController = Get.find<ShopController>();
  StockTransferController stockTransferController = Get.find<StockTransferController>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.9),
      appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                Get.back();
              },
              icon: Icon(Icons.arrow_back_ios)),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Transfer History View'),
                  Text(
                    'transferModelBody',
                    style: TextStyle(fontSize: 15),
                  )
                ],
              ),
            ],
          )),
      body: Obx(() {
        return stockTransferController.gettingTransferHistoryLoad.value
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            itemBuilder: (context, index) {
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
                            "name",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "Qty ",
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
    );
  }
}