import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/purchase_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/supply_order_model.dart';
import 'package:get/get.dart';

import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';
import '../../widgets/stocks_card.dart';

class ViewPurchases extends StatelessWidget {
  ViewPurchases({Key? key}) : super(key: key);
  ShopController shopController = Get.find<ShopController>();
  PurchaseController purchaseController = Get.find<PurchaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        titleSpacing: 0.0,
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
            majorTitle(
                title: "Purchased Items", color: Colors.black, size: 16.0),
            minorTitle(
                title: "${shopController.currentShop.value?.name}",
                color: Colors.grey)
          ],
        ),
      ),
      body: Obx(() {
        return purchaseController.getPurchaseByDateLoad.value
            ? Center(
                child: CircularProgressIndicator(),
              )
            : purchaseController.purchaseByDate.length == 0
                ? Center(
                    child: Text("No purchase Entries Found"),
                  )
                : ListView.builder(
                    itemCount: purchaseController.purchaseByDate.length,
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      SupplyOrderModel supplyOrderModel =
                          purchaseController.purchaseByDate.elementAt(index);

                      return stockCard(
                          context: context,
                          supplyOrderModel: supplyOrderModel,
                          type: "today");
                    });
      }),
    );
  }
}
