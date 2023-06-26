import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/home/home_page.dart';
import 'package:pointify/screens/sales/all_sales.dart';
import 'package:pointify/utils/colors.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Real/schema.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/sales_history_card.dart';

class SaleOrderItem extends StatelessWidget {
  final id;
  final page;

  SaleOrderItem({Key? key, required this.id, required this.page})
      : super(key: key);
  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    // salesController.getSalesBySaleId(uid: id);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0.3,
        centerTitle: false,
        leading: IconButton(
          onPressed: () {
            if (MediaQuery.of(context).size.width > 600) {
              if (page == "home") {
                Get.find<HomeController>().selectedWidget.value = HomePage();
              } else {
                Get.find<HomeController>().selectedWidget.value = AllSalesPage(
                  page: "saleOrder",
                );
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
        title: majorTitle(title: "Sale Items", color: Colors.black, size: 16.0),
      ),
      body: ResponsiveWidget(
        largeScreen: SingleChildScrollView(
          child: Obx(
            () {
              return salesController.salesOrderItemLoad.value
                  ? Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4),
                        Center(child: CircularProgressIndicator()),
                      ],
                    )
                  : salesController.salesHistory.isEmpty
                      ? noItemsFound(context, true)
                      : Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
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
                                        'Amount(${shopController.currentShop.value?.currency})',
                                        textAlign: TextAlign.center)),
                                DataColumn(
                                    label: Text('Payment Method',
                                        textAlign: TextAlign.center)),
                                DataColumn(
                                    label: Text('Date',
                                        textAlign: TextAlign.center)),
                                DataColumn(
                                    label:
                                        Text('', textAlign: TextAlign.center)),
                              ],
                              rows: List.generate(
                                  salesController.salesHistory.length, (index) {
                                InvoiceItem saleOrderItemModel = salesController
                                    .salesHistory
                                    .elementAt(index);
                                final y =
                                    saleOrderItemModel.product!.name.toString();
                                final x = saleOrderItemModel.total.toString();
                                final z =
                                    saleOrderItemModel.itemCount.toString();
                                final w = saleOrderItemModel.createdAt;
                                // final a = saleOrderItemModel.attendantid?.username;

                                return DataRow(cells: [
                                  DataCell(
                                      Container(width: 75, child: Text(y))),
                                  DataCell(
                                      Container(width: 75, child: Text(x))),
                                  DataCell(Container(child: Text(z))),
                                  DataCell(Container(
                                      child: Text(DateFormat("MM-dd-yyyy")
                                          .format(w!)))),
                                  DataCell(InkWell(
                                    onTap: () {
                                      // if (saleOrderItemModel.returned ==
                                      //     false) {
                                      //   returnStockDialog(
                                      //       saleItem: saleOrderItemModel);
                                      // }
                                    },
                                    child: Container(
                                        child: Text(
                                      "Return to stock",
                                      style:
                                          TextStyle(color: AppColors.mainColor),
                                    )),
                                  )),
                                ]);
                              }),
                            ),
                          ),
                        );
            },
          ),
        ),
        smallScreen: Obx(
          () {
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
                          InvoiceItem saleOrderItemModel =
                              salesController.salesHistory.elementAt(index);
                          return SaleOrderItemCard(saleOrderItemModel, "page");
                        });
          },
        ),
      ),
    );
  }
}
