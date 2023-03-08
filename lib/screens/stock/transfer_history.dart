import 'package:flutter/material.dart';
import 'package:flutterpos/models/stockTransferHistoryModel.dart';
import 'package:flutterpos/responsive/large_screen.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:flutterpos/widgets/no_items_found.dart';
import 'package:flutterpos/widgets/transfer_history_card.dart';
import 'package:get/get.dart';

import '../../controllers/shop_controller.dart';
import '../../controllers/stock_transfer_controller.dart';

class TransferHistory extends StatelessWidget {
  TransferHistory({Key? key}) : super(key: key);
  ShopController createShopController = Get.find<ShopController>();
  StockTransferController stockTransferController =
      Get.find<StockTransferController>();

  List transfersidePages = [
    {"page": "Transfer In"},
    {"page": "Transfer Out"},
  ];

  Widget showPage() {
    switch (stockTransferController.activeItem.value) {
      case "Transfer In":
        return INWidget();

      case "Transfer Out":
        return OutWidget();

      default:
        return INWidget();
    }
  }

  Widget sideMenuItems({required title, required context}) {
    return Obx(() => InkWell(
          onTap: () {
            stockTransferController.activeItem.value = title;
            if (title == "Transfer In") {
              print("called1");
              stockTransferController.gettingTransferHistory(
                  shopId: createShopController.currentShop.value!.id,
                  type: "in");
            } else {
              print("called2");
              stockTransferController.gettingTransferHistory(
                  shopId: createShopController.currentShop.value!.id,
                  type: "out");
            }
          },
          onHover: (value) {},
          child: Container(
            padding: EdgeInsets.only(top: 10, left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "${title}",
                    style: TextStyle(
                        color: stockTransferController.activeItem.value == title
                            ? AppColors.mainColor
                            : Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    stockTransferController.gettingTransferHistory(
        shopId: createShopController.currentShop.value!.id, type: "in");
    return ResponsiveWidget(
        largeScreen: Scaffold(
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
          ),
          body: LargeScreen(
            sideBar: ListView(
              children: transfersidePages
                  .map((e) => sideMenuItems(title: e["page"], context: context))
                  .toList(),
            ),
            body: showPage(),
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
                              shopId:
                                  createShopController.currentShop.value!.id,
                              type: "in");
                        } else {
                          stockTransferController.gettingTransferHistory(
                              shopId:
                                  createShopController.currentShop.value!.id,
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
                OutWidget(),
              ]),
            )));
  }
}

class INWidget extends StatelessWidget {
  ShopController createShopController = Get.find<ShopController>();
  StockTransferController stockTransferController =
      Get.find<StockTransferController>();

  INWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return stockTransferController.gettingTransferHistoryLoad.isTrue
          ? Center(
              child: CircularProgressIndicator(),
            )
          : stockTransferController.transferHistory.length == 0
              ? noItemsFound(context, true)
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

class OutWidget extends StatelessWidget {
  ShopController createShopController = Get.find<ShopController>();
  StockTransferController stockTransferController =
      Get.find<StockTransferController>();

  OutWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return stockTransferController.gettingTransferHistoryLoad.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : stockTransferController.transferHistory.length == 0
              ? noItemsFound(context, true)
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
