import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/stock/stock_transfer.dart';
import 'package:pointify/screens/stock/transfer_history_view.dart';
import 'package:pointify/utils/colors.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:pointify/widgets/transfer_history_card.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Real/schema.dart';
import '../../controllers/shop_controller.dart';
import '../../controllers/stock_transfer_controller.dart';

class TransferHistory extends StatelessWidget {
  TransferHistory({Key? key}) : super(key: key) {
    stockTransferController.gettingTransferHistory(type: "in");
  }

  ShopController createShopController = Get.find<ShopController>();
  StockTransferController stockTransferController =
      Get.find<StockTransferController>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
        largeScreen: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.0,
              centerTitle: false,
              leading: IconButton(
                  onPressed: () {
                    Get.find<HomeController>().selectedWidget.value =
                        StockTransfer();
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Stock Transfer',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                  Text(
                    '${createShopController.currentShop.value!.name!}',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              bottom: TabBar(
                indicatorColor: AppColors.mainColor,
                labelColor: AppColors.mainColor,
                unselectedLabelColor: Colors.grey,
                onTap: (value) {
                  if (value == 0) {
                    stockTransferController.gettingTransferHistory(type: "in");
                  } else {
                    stockTransferController.gettingTransferHistory(type: "out");
                  }
                },
                tabs: [
                  Tab(text: "In"),
                  Tab(text: "Out"),
                ],
              ),
            ),
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [
                INWidget(),
                INWidget(),
              ],
            ),
          ),
        ),
        smallScreen: DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0.0,
                centerTitle: false,
                leading: IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.black,
                    )),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Stock Transfer',
                      style: TextStyle(color: Colors.black, fontSize: 14),
                    ),
                    Text(
                      '${createShopController.currentShop.value!.name!}',
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(50.0),
                  child: Container(
                    height: 55,
                    margin:
                        EdgeInsets.only(top: 2, bottom: 2, right: 5, left: 5),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(
                        25.0,
                      ),
                    ),
                    child: TabBar(
                      onTap: (value) {
                        if (value == 0) {
                          stockTransferController.gettingTransferHistory(
                              type: "in");
                        } else {
                          stockTransferController.gettingTransferHistory(
                              type: "out");
                        }
                      },
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          25.0,
                        ),
                        color: AppColors.mainColor,
                      ),
                      tabs: [
                        Tab(text: 'IN'),
                        Tab(text: 'OUT'),
                      ],
                    ),
                  ),
                ),
              ),
              body: TabBarView(children: [
                INWidget(),
                INWidget(),
              ]),
            )));
  }
}

class INWidget extends StatelessWidget {
  INWidget({Key? key}) : super(key: key);
  ShopController createShopController = Get.find<ShopController>();
  StockTransferController stockTransferController =
      Get.find<StockTransferController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return stockTransferController.gettingTransferHistoryLoad.value
          ? const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: CircularProgressIndicator(),
                ),
              ],
            )
          : stockTransferController.transferHistory.isEmpty
              ? noItemsFound(context, true)
              : MediaQuery.of(context).size.width > 600
                  ? SingleChildScrollView(
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
                                  label: Text('Transfer',
                                      textAlign: TextAlign.center)),
                              DataColumn(
                                  label: Text('Variance Transferred',
                                      textAlign: TextAlign.center)),
                              DataColumn(
                                  label: Text('Date',
                                      textAlign: TextAlign.center)),
                              DataColumn(
                                  label: Text('', textAlign: TextAlign.center)),
                            ],
                            rows: List.generate(
                                stockTransferController.transferHistory.length,
                                (index) {
                              StockTransferHistory stockTransferHistory =
                                  stockTransferController.transferHistory
                                      .elementAt(index);
                              final y =
                                  "${stockTransferHistory.from!.name!} to ${stockTransferHistory.to!.name!}";
                              final x = stockTransferHistory.product!.length;
                              final z = stockTransferHistory.createdAt;

                              return DataRow(cells: [
                                DataCell(Container(child: Text(y))),
                                DataCell(Container(child: Text(x.toString()))),
                                DataCell(Container(
                                    child: Text(
                                        DateFormat("dd/MM/yyyy").format(z!)))),
                                DataCell(
                                  InkWell(
                                    onTap: () {
                                      Get.find<HomeController>()
                                              .selectedWidget
                                              .value =
                                          TransferHistoryView(
                                              id: stockTransferHistory.id!);
                                    },
                                    child: Align(
                                      child: Center(
                                        child: Container(
                                          padding: EdgeInsets.all(5),
                                          margin: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: AppColors.mainColor,
                                              borderRadius:
                                                  BorderRadius.circular(3)),
                                          child: Text(
                                            "View",
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                      alignment: Alignment.topRight,
                                    ),
                                  ),
                                ),
                              ]);
                            }),
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: stockTransferController.transferHistory.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        StockTransferHistory stockTransferHistory =
                            stockTransferController.transferHistory
                                .elementAt(index);
                        return transferHistoryCard(
                            stockTransferHistory: stockTransferHistory);
                      });
    });
  }
}
