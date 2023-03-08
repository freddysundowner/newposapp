import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/purchase_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/supply_order_model.dart';
import 'package:get/get.dart';

import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';
import '../../widgets/stocks_card.dart';

class PurchaseOrderItems extends StatelessWidget {
  final id;

  PurchaseOrderItems({Key? key, required this.id}) : super(key: key);
  ShopController createShopController = Get.find<ShopController>();
  PurchaseController purchaseController = Get.find<PurchaseController>();

  @override
  Widget build(BuildContext context) {
    purchaseController.getPurchaseOrderItems(id: id);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            majorTitle(title: "Stock Items", color: Colors.black, size: 16.0),
            minorTitle(
                title: "${createShopController.currentShop.value?.name}",
                color: Colors.grey)
          ],
        ),
      ),
      body: Obx(() {
        return purchaseController.getPurchaseOrderItemLoad.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : purchaseController.purchaseOrderItems.length == 0
                ? Center(
                    child: Text("No stock Entries Found"),
                  )
                : ListView.builder(
                    itemCount: purchaseController.purchaseOrderItems.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      SupplyOrderModel supplyOrderModel = purchaseController
                          .purchaseOrderItems
                          .elementAt(index);

                      return stockCard(
                          context: context,
                          supplyOrderModel: supplyOrderModel,
                          type: "today");
                    });
      }),
    );
  }
}
