import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/sales_controller.dart';
import 'package:get/get.dart';

import '../../models/sales_order_item_model.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/sales_history_card.dart';

class SaleOrderItem extends StatelessWidget {
  final id;

  SaleOrderItem({Key? key, required this.id}) : super(key: key);
  SalesController salesController = Get.find<SalesController>();

  @override
  Widget build(BuildContext context) {
    salesController.getSalesBySaleId(id);
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          backgroundColor: Colors.white,
          elevation: 0.3,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: majorTitle(
              title: "Sale Items", color: Colors.black, size: 16.0),
        ),
        body: Obx(() {
          return salesController.salesOrderItemLoad.value
              ? Center(
            child: CircularProgressIndicator(),
          )
              : salesController.salesHistory.length == 0
              ? Center(
            child: Text("No Entries Found"),
          )
              : ListView.builder(
              shrinkWrap: true,
              itemCount: salesController.salesHistory.length,
              itemBuilder: (context, index) {
                SaleOrderItemModel saleOrderItemModel = salesController.salesHistory.elementAt(index);
                return salesHistoryCard(
                    saleOrderItemModel, context, id, "page");
              });
        })
    );
  }
}
