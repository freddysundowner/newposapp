import 'package:flutter/material.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/stock/purchase_order_item.dart';
import 'package:pointify/screens/stock/stock_page.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:pointify/widgets/pdf/purchases_pdf.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';

import '../../Real/Models/schema.dart';
import '../../services/purchases.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/purchase_order_card.dart';
import '../../widgets/smalltext.dart';
import 'create_purchase.dart';

class AllPurchases extends StatelessWidget {
  AllPurchases({Key? key}) : super(key: key) {
    // purchaseController.getPurchase();
  }

  ShopController shopController = Get.find<ShopController>();
  PurchaseController purchaseController = Get.find<PurchaseController>();
  AuthController authController = Get.find<AuthController>();
  UserController usercontroller = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        centerTitle: false,
        titleSpacing: 0.4,
        leading: MediaQuery.of(context).size.width > 600
            ? null
            : IconButton(
                onPressed: () {
                  if (MediaQuery.of(context).size.width > 600) {
                    Get.find<HomeController>().selectedWidget.value =
                        StockPage();
                  } else {
                    Get.back();
                  }
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
              ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  majorTitle(
                      title: "Purchases", color: Colors.black, size: 16.0),
                  minorTitle(
                      title: "${shopController.currentShop.value?.name}",
                      color: Colors.grey)
                ],
              )
            ],
          ),
        ),
        actions: [
          InkWell(
              onTap: () {
                PurchasesPdf(
                    sales: purchaseController.purchasedItems, type: "type");
              },
              child: Icon(
                Icons.download,
                color: Colors.black,
              ))
        ],
      ),
      body: ResponsiveWidget(
        largeScreen: Obx(() {
          return purchaseController.getPurchaseLoad.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : purchaseController.purchasedItems.isEmpty
                  ? noItemsFound(context, true)
                  : Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
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
                                    const DataColumn(
                                        label: Text('Receipt Number',
                                            textAlign: TextAlign.center)),
                                    DataColumn(
                                        label: Text(
                                            'Amount(${shopController.currentShop.value?.currency})',
                                            textAlign: TextAlign.center)),
                                    DataColumn(
                                        label: Text('Products',
                                            textAlign: TextAlign.center)),
                                    DataColumn(
                                        label: Text('Date',
                                            textAlign: TextAlign.center)),
                                    DataColumn(
                                        label: Text('',
                                            textAlign: TextAlign.center)),
                                  ],
                                  rows: List.generate(
                                      purchaseController.purchasedItems.length,
                                      (index) {
                                    Invoice purchaseOrder = purchaseController
                                        .purchasedItems
                                        .elementAt(index);
                                    final y = purchaseOrder.receiptNumber;
                                    final x = purchaseOrder.total.toString();
                                    final z =
                                        purchaseOrder.productCount.toString();
                                    final w = purchaseOrder.createdAt;

                                    return DataRow(cells: [
                                      DataCell(Container(
                                          width: 75, child: Text(y!))),
                                      DataCell(
                                          Container(width: 75, child: Text(x))),
                                      DataCell(Container(child: Text(z))),
                                      DataCell(Container(
                                          child: Text(
                                              DateFormat("yyyy-dd-MMM hh:mm a")
                                                  .format(w!)))),
                                      DataCell(InkWell(
                                        onTap: () {
                                          Get.find<HomeController>()
                                                  .selectedWidget
                                                  .value =
                                              PurchaseOrderItems(
                                                  id: purchaseOrder.id);
                                        },
                                        child: Container(
                                            child: Text(
                                          "View",
                                          style: TextStyle(
                                              color: AppColors.mainColor),
                                        )),
                                      )),
                                    ]);
                                  }),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Container(
                                width: 250,
                                padding: EdgeInsets.only(right: 10),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text("Total Purchases:"),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                            "${shopController.currentShop.value?.currency} ${purchaseController.calculatePurchasemount()}"),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 2,
                                      color: Colors.black,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 60),
                          ],
                        ),
                      ));
        }),
        smallScreen: StreamBuilder<RealmResultsChanges<Invoice>>(
            stream: Purchases().getPurchase().changes,
            builder: (context, snapshot) {
              final data = snapshot.data;

              if (data == null || data.results.isEmpty) {
                return const Center(
                  child: Text(
                    "No purchases yet",
                    style: TextStyle(color: Colors.black),
                  ),
                );
              }

              final results = data.results;
              return ListView.builder(
                  itemCount: results.realm.isClosed ? 0 : results.length,
                  physics: const ScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    Invoice invoicedata = results.elementAt(index);
                    return InvoiceCard(invoice: invoicedata);
                  });
            }),
      ),
    );
  }
}
