import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/purchase_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/purchase_order.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/widgets/no_items_found.dart';
import 'package:get/get.dart';

import '../../widgets/bigtext.dart';
import '../../widgets/purchase_order_card.dart';
import '../../widgets/smalltext.dart';

class ViewPurchases extends StatelessWidget {
  ViewPurchases({Key? key}) : super(key: key) {
    purchaseController.getPurchase(
        shopId: shopController.currentShop.value?.id);
  }

  ShopController shopController = Get.find<ShopController>();
  PurchaseController purchaseController = Get.find<PurchaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        centerTitle: false,
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
            majorTitle(title: "Purchases", color: Colors.black, size: 16.0),
            minorTitle(
                title: "${shopController.currentShop.value?.name}",
                color: Colors.grey)
          ],
        ),
      ),
      body: ResponsiveWidget(
        largeScreen: Obx(() {
          return purchaseController.getPurchaseLoad.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : purchaseController.purchaseByDate.length == 0
                  ? noItemsFound(context, true)
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width *
                                          1.6/
                                          MediaQuery.of(context).size.height,
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 10),
                          itemCount: purchaseController.purchaseByDate.length,
                          physics: ScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            PurchaseOrder purchaseOrder = purchaseController
                                .purchaseByDate
                                .elementAt(index);
                            return purchaseOrderCard(
                                purchaseOrder: purchaseOrder);
                          }),
                    );
        }),
        smallScreen: Obx(() {
          return purchaseController.getPurchaseLoad.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : purchaseController.purchaseByDate.length == 0
                  ? Center(
                      child: Text("No purchase Entries Found"),
                    )
                  : ListView.builder(
                      itemCount: purchaseController.purchaseByDate.length,
                      physics: ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        PurchaseOrder purchaseOrder =
                            purchaseController.purchaseByDate.elementAt(index);
                        return purchaseOrderCard(purchaseOrder: purchaseOrder);
                      });
        }),
      ),
    );
  }
}
