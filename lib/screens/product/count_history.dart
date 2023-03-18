import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/home_controller.dart';
import '../../controllers/product_controller.dart';
import '../../models/product_count_model.dart';
import '../../utils/colors.dart';
import 'counting_page.dart';

class CountHistory extends StatelessWidget {
  CountHistory({Key? key}) : super(key: key);
  ProductController productController = Get.find<ProductController>();
  ShopController createShopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    productController
        .getProductCount(createShopController.currentShop.value?.id);
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          leading: IconButton(
              onPressed: () {
                if (MediaQuery.of(context).size.width > 600) {
                  Get.find<HomeController>().selectedWidget.value =
                      CountingPage();
                } else {
                  Get.back();
                }
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Count History',
                    style: TextStyle(fontSize: 18, color: Colors.black),
                  ),
                  Obx(() {
                    return Text(
                        createShopController.currentShop.value == null
                            ? ""
                            : createShopController.currentShop.value!.name!,
                        style: TextStyle(fontSize: 15, color: Colors.black));
                  })
                ],
              ),
              // IconButton(
              //     onPressed: () {
              //       showDialog(
              //         context: context,
              //         builder: (_) {
              //           return AlertDialog(
              //             title: Text('Sort By'),
              //             content: ListView(
              //               shrinkWrap: true,
              //               children: [
              //                 Row(
              //                   children: [
              //                     Text('2022'),
              //                   ],
              //                 ),
              //                 Divider(),
              //                 Row(
              //                   children: [
              //                     Text('2021'),
              //                   ],
              //                 ),
              //                 Divider(),
              //                 Row(
              //                   children: [
              //                     Text('2020'),
              //                   ],
              //                 ),
              //                 Divider(),
              //                 Row(
              //                   children: [
              //                     Text('2019'),
              //                   ],
              //                 ),
              //                 Divider(),
              //                 Row(
              //                   children: [
              //                     Text('2018'),
              //                   ],
              //                 ),
              //                 Divider(),
              //                 Row(
              //                   children: [
              //                     Text('2017'),
              //                   ],
              //                 )
              //               ],
              //             ),
              //             actions: [
              //               TextButton(
              //                 onPressed: () => Navigator.pop(context),
              //                 child: Text('Cancel'),
              //               ),
              //             ],
              //           );
              //         },
              //       );
              //     },
              //     icon: Icon(Icons.arrow_drop_down))
            ],
          )),
      body: ResponsiveWidget(
        largeScreen: Container(),
        smallScreen: historyWidget(),
      ),
    );
  }

  Widget historyWidget() {
    return Obx(() {
      return productController.loadingCountHistory.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : productController.countHistoryList.length == 0
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                        child: Column(
                      children: [
                        Icon(Icons.warning_amber),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'List is empty',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text('No stock count done yet'),
                        SizedBox(
                          height: 5,
                        ),
                        Text('Or check your internet connection')
                      ],
                    ))
                  ],
                )
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: productController.countHistoryList.length,
                  // physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    ProductCountModel productBody =
                        productController.countHistoryList.elementAt(index);

                    return productHistoryContainer(productBody);
                  });
      ;
    });
  }

  Widget productHistoryContainer(ProductCountModel productBody) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Card(
        color: Colors.white.withOpacity(0.9),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              child: Row(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Center(
                    child: ClipOval(
                      child: Container(
                        height: 40,
                        width: 40,
                        decoration: BoxDecoration(
                          color: AppColors.mainColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Icon(Icons.check, color: Colors.white),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${productBody.product!.name}".capitalize!,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Text(
                        "${productBody.product!.category}",
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                      Text('Qty ${productBody.quantity}'),
                      Text(
                          '${DateFormat("MMM dd,yyyy, hh:m a").format(productBody.createdAt!)} '),
                    ],
                  )
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Text('BP/= ${productBody.product!.buyingPrice}'),
                  Text('SP/= ${productBody.product!.sellingPrice![0]}')
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
