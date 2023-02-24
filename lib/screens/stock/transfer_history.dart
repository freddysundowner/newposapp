import 'package:flutter/material.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:flutterpos/widgets/transfer_history_card.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/shop_controller.dart';
import '../../controllers/stock_transfer_controller.dart';

class TransferHistory extends StatelessWidget {
  TransferHistory({Key? key}) : super(key: key);
  ShopController createShopController = Get.find<ShopController>();
  StockTransferController stockTransferController =
      Get.find<StockTransferController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.0,
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
                margin: EdgeInsets.only(top: 2,bottom: 2,right: 5,left: 5),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(
                    25.0,
                  ),
                ),
                child: TabBar(
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
        ));
  }
}

class INWidget extends StatelessWidget {
  ShopController createShopController = Get.find<ShopController>();
  StockTransferController stockTransferController =
      Get.find<StockTransferController>();

  INWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
        // stockTransferController.tranferHistoryInShop.length == 0
        //       ? Column(
        //           mainAxisAlignment: MainAxisAlignment.center,
        //           children: [
        //             Icon(Icons.dangerous),
        //             SizedBox(height: 10),
        //             Text('No Transfer History'),
        //             SizedBox(height: 10),
        //             Row(
        //               mainAxisAlignment: MainAxisAlignment.center,
        //               children: [
        //                 InkWell(
        //                   onTap: () {
        //                     Get.to(StockTransfer());
        //                   },
        //                   child: Container(
        //                     decoration: BoxDecoration(
        //                         borderRadius: BorderRadius.circular(20),
        //                         border: Border.all(color: Colors.blueAccent)),
        //                     child: Padding(
        //                       padding: const EdgeInsets.all(8.0),
        //                       child: Row(
        //                         children: [
        //                           Icon(
        //                             Icons.cloud_upload,
        //                             color: Colors.blue,
        //                           ),
        //                           Text('Transfer')
        //                         ],
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ],
        //             )
        //           ],
        //         )
        //       :
        ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return transferHistoryCard();
            });
  }
}

class OutWidget extends StatelessWidget {
  ShopController createShopController = Get.find<ShopController>();
  StockTransferController stockTransferController =
      Get.find<StockTransferController>();

  OutWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return

          // stockTransferController.tranferHistoryOut.length == 0
          // ? Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       Icon(Icons.dangerous),
          //       SizedBox(height: 10),
          //       Text('No Transfer History'),
          //       SizedBox(height: 10),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           InkWell(
          //             onTap: () {
          //               Get.to(StockTransfer());
          //             },
          //             child: Container(
          //               decoration: BoxDecoration(
          //                   borderRadius: BorderRadius.circular(20),
          //                   border: Border.all(color: Colors.blueAccent)),
          //               child: Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: Row(
          //                   children: [
          //                     Icon(
          //                       Icons.cloud_upload,
          //                       color: Colors.blue,
          //                     ),
          //                     Text('Transfer')
          //                   ],
          //                 ),
          //               ),
          //             ),
          //           ),
          //         ],
          //       )
          //     ],
          //   )
          ListView.builder(
              itemCount: 10,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return transferHistoryCard();
              });

  }
}
