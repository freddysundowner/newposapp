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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          centerTitle: false,
          leading: IconButton(
              onPressed: () {
                if (isSmallScreen(context)) {
                  Get.back();
                } else {
                  Get.find<HomeController>().selectedWidget.value =
                      StockTransfer();
                }
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Stock Transfer',
                style: TextStyle(color: Colors.black, fontSize: 14),
              ),
              Text(
                createShopController.currentShop.value!.name!,
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
          bottom: isSmallScreen(context)
              ? PreferredSize(
                  preferredSize: const Size.fromHeight(50.0),
                  child: Container(
                    height: 55,
                    margin: const EdgeInsets.only(
                        top: 2, bottom: 2, right: 5, left: 5),
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
                      tabs: const [
                        Tab(text: 'IN'),
                        Tab(text: 'OUT'),
                      ],
                    ),
                  ),
                )
              : TabBar(
                  indicatorColor: AppColors.mainColor,
                  labelColor: AppColors.mainColor,
                  unselectedLabelColor: Colors.grey,
                  onTap: (value) {
                    if (value == 0) {
                      stockTransferController.gettingTransferHistory(
                          type: "in");
                    } else {
                      stockTransferController.gettingTransferHistory(
                          type: "out");
                    }
                  },
                  tabs: const [
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
    );
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
              : isSmallScreen(context)
                  ? ListView.builder(
                      itemCount: stockTransferController.transferHistory.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        StockTransferHistory stockTransferHistory =
                            stockTransferController.transferHistory
                                .elementAt(index);
                        return transferHistoryCard(
                            stockTransferHistory: stockTransferHistory);
                      })
                  : SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
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
                            columns: const [
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
                                      alignment: Alignment.topRight,
                                      child: Center(
                                        child: Container(
                                          padding: const EdgeInsets.all(5),
                                          margin: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                              color: AppColors.mainColor,
                                              borderRadius:
                                                  BorderRadius.circular(3)),
                                          child: const Text(
                                            "View",
                                            style:
                                                TextStyle(color: Colors.white),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ]);
                            }),
                          ),
                        ),
                      ),
                    );
    });
  }
}
