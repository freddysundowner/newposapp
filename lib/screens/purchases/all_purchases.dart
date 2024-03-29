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
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:realm/realm.dart';

import '../../Real/schema.dart';
import '../../services/purchases.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/purchase_order_card.dart';
import '../../widgets/smalltext.dart';
import 'create_purchase.dart';
import 'invoice_screen.dart';

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
          leading: IconButton(
            onPressed: () {
              if (!isSmallScreen(context)) {
                Get.find<HomeController>().selectedWidget.value = StockPage();
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
                  // PurchasesPdf(
                  //     sales: purchaseController.purchasedItems, type: "type");
                },
                child: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Icon(
                    Icons.download,
                    color: Colors.black,
                  ),
                ))
          ],
        ),
        body: StreamBuilder<RealmResultsChanges<Invoice>>(
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
              return isSmallScreen(context)
                  ? ListView.builder(
                      itemCount: results.realm.isClosed ? 0 : results.length,
                      physics: const ScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        Invoice invoiceData = results.elementAt(index);
                        return InvoiceCard(invoice: invoiceData);
                      })
                  : Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      margin: const EdgeInsets.symmetric(horizontal: 10)
                          .copyWith(top: 10),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(dividerColor: Colors.grey),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: DataTable(
                              headingTextStyle: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                              dataTextStyle: const TextStyle(
                                  fontSize: 18, color: Colors.black),
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
                                const DataColumn(
                                    label: Text('Products',
                                        textAlign: TextAlign.center)),
                                const DataColumn(
                                    label: Text('Status',
                                        textAlign: TextAlign.center)),
                                const DataColumn(
                                    label: Text('Date',
                                        textAlign: TextAlign.center)),
                                const DataColumn(
                                    label: Text('Actions',
                                        textAlign: TextAlign.center)),
                              ],
                              rows: List.generate(
                                  results.realm.isClosed ? 0 : results.length,
                                  (index) {
                                Invoice invoiceData = results.elementAt(index);

                                final y = invoiceData.receiptNumber;
                                final x = invoiceData.total.toString();
                                final z = invoiceData.productCount.toString();
                                final w = invoiceData.createdAt;

                                return DataRow(cells: [
                                  DataCell(Text("#${y!}".toUpperCase())),
                                  DataCell(Text(x)),
                                  DataCell(Text(z)),
                                  DataCell(Text(
                                    chechPayment(invoiceData),
                                    style: TextStyle(
                                        color: chechPaymentColor(invoiceData)),
                                  )),
                                  DataCell(Text(
                                      DateFormat("yyyy-dd-MMM hh:mm a")
                                          .format(w!))),
                                  DataCell(InkWell(
                                    onTap: () {
                                      Get.find<HomeController>()
                                          .selectedWidget
                                          .value = InvoiceScreen(
                                        invoice: invoiceData,
                                        type: "",
                                        from: "AllPurchases",
                                      );
                                    },
                                    child: Text(
                                      "View",
                                      style:
                                          TextStyle(color: AppColors.mainColor),
                                    ),
                                  )),
                                ]);
                              }),
                            ),
                          ),
                        ),
                      ),
                    );
            }));
  }
}
