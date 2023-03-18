import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/widgets/no_items_found.dart';
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
    productController.getProductCount(createShopController.currentShop.value?.id);
    return Scaffold(
      backgroundColor: Colors.white,
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
        largeScreen: Obx(() {
          return productController.loadingCountHistory.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : productController.countHistoryList.length == 0
                  ? noItemsFound(context, true)
                  : SingleChildScrollView(
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
                                  label: Text('Name',
                                      textAlign: TextAlign.center)),
                              DataColumn(
                                  label: Text('Quantity',
                                      textAlign: TextAlign.center)),
                              DataColumn(
                                  label: Text('Attendant',
                                      textAlign: TextAlign.center)),
                              DataColumn(
                                  label: Text('Date',
                                      textAlign: TextAlign.center)),
                            ],
                            rows: List.generate(
                                productController.countHistoryList.length,
                                (index) {
                              ProductCountModel productBody = productController
                                  .countHistoryList
                                  .elementAt(index);
                              final y = productBody.product?.name;
                              final x = productBody.quantity;
                              final z = productBody.createdAt!;
                              final a = productBody.attendantId!.fullnames??"";

                              return DataRow(cells: [
                                DataCell(Container(child: Text(y!))),
                                DataCell(Container(child: Text(x.toString()))),
                                DataCell(Container(child: Text(a))),
                                DataCell(Container(
                                    child: Text(
                                        DateFormat("yyyy-MM-dd").format(z)))),
                              ]);
                            }),
                          ),
                        ),
                      ),
                    );
          ;
        }),
        smallScreen: historyWidget(context),
      ),
    );
  }

  Widget historyWidget(context) {
    return Obx(() {
      return productController.loadingCountHistory.value
          ? Center(
              child: CircularProgressIndicator(),
            )
          : productController.countHistoryList.length == 0
              ? noItemsFound(context, true)
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
