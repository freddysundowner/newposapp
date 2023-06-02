import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/purchases/all_purchases.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Real/Models/schema.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';
import '../../widgets/stocks_card.dart';

class PurchaseOrderItems extends StatelessWidget {
  final id;
  final String? page;

  PurchaseOrderItems({Key? key, required this.id, this.page}) : super(key: key);
  ShopController createShopController = Get.find<ShopController>();
  PurchaseController purchaseController = Get.find<PurchaseController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            if (MediaQuery.of(context).size.width > 600) {
              if (page != null && page == "customerInfoPage") {
              } else {
                Get.find<HomeController>().selectedWidget.value =
                    AllPurchases();
              }
            } else {
              Get.back();
            }
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
      body: ResponsiveWidget(largeScreen: Obx(() {
        return purchaseController.getPurchaseOrderItemLoad.value
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                ],
              )
            : purchaseController.invoice.value!.items.isEmpty
                ? noItemsFound(context, true)
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 5, vertical: 10),
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
                                    label: Text('Product',
                                        textAlign: TextAlign.center)),
                                DataColumn(
                                    label: Text(
                                        'Amount(${createShopController.currentShop.value?.currency})',
                                        textAlign: TextAlign.center)),
                                DataColumn(
                                    label: Text('Quantity',
                                        textAlign: TextAlign.center)),
                                const DataColumn(
                                    label: Text('Date',
                                        textAlign: TextAlign.center)),
                                DataColumn(
                                    label:
                                        Text('', textAlign: TextAlign.center)),
                              ],
                              rows: List.generate(
                                  purchaseController
                                      .invoice.value!.items.length, (index) {
                                InvoiceItem saleOrderItemModel =
                                    purchaseController.invoice.value!.items
                                        .elementAt(index);
                                final y =
                                    saleOrderItemModel.product!.name.toString();
                                final x = saleOrderItemModel.total.toString();
                                final z =
                                    saleOrderItemModel.itemCount.toString();
                                final w = saleOrderItemModel.createdAt;

                                return DataRow(cells: [
                                  DataCell(
                                      Container(width: 75, child: Text(y))),
                                  DataCell(
                                      Container(width: 75, child: Text(x))),
                                  DataCell(Container(child: Text(z))),
                                  DataCell(Container(
                                      child: Text(DateFormat("MM-dd-yyyy")
                                          .format(w!)))),
                                  DataCell(Container(
                                    child: Align(
                                      alignment: Alignment.topRight,
                                      child: PopupMenuButton(
                                        itemBuilder: (ctx) => [
                                          PopupMenuItem(
                                            child: ListTile(
                                              onTap: () {
                                                Get.back();
                                                // if (saleOrderItemModel
                                                //         .sale ==
                                                //     null) {
                                                //   showSnackBar(
                                                //       message:
                                                //           "please select customer to sell to",
                                                //       color: Colors.red);
                                                // } else {
                                                //   showQuantityDialog(context,
                                                //       saleOrderItemModel);
                                                // }
                                              },
                                              title: Text("Return to Supplier"),
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: ListTile(
                                              onTap: () {
                                                Get.back();
                                              },
                                              title: Text("Close"),
                                            ),
                                          ),
                                        ],
                                        icon: Icon(
                                          Icons.more_vert,
                                          color: Colors.black,
                                          size: 30,
                                        ),
                                      ),
                                    ),
                                  )),
                                ]);
                              }),
                            ),
                          ),
                        ),
                        SizedBox(height: 60),
                      ],
                    ),
                  );
      }), smallScreen: Obx(() {
        return purchaseController.getPurchaseOrderItemLoad.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : purchaseController.invoice.value!.items.length == 0
                ? const Center(
                    child: Text("No stock Entries Found"),
                  )
                : ListView.builder(
                    itemCount: purchaseController.invoice.value!.items.length,
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      InvoiceItem supplyOrderModel = purchaseController
                          .invoice.value!.items
                          .elementAt(index);

                      return stockCard(
                          context: context,
                          supplyOrderModel: supplyOrderModel,
                          type: "today",
                          purchaseId: id);
                    });
      })),
    );
  }
}
