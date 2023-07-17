import 'package:flutter/material.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Real/schema.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/product_controller.dart';
import '../../utils/colors.dart';
import 'stock_counts.dart';

class CountHistory extends StatelessWidget {
  CountHistory({Key? key}) : super(key: key) {
    productController.getCountHistory();
  }

  ProductController productController = Get.find<ProductController>();
  ShopController createShopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            elevation: 0.0,
            leading: IconButton(
                onPressed: () {
                  if (isSmallScreen(context)) {
                    Get.back();
                  } else {
                    Get.find<HomeController>().selectedWidget.value =
                        StockCount();
                  }
                },
                icon: const Icon(
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
                    const Text(
                      'Count History',
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                    Obx(() {
                      return Text(
                          createShopController.currentShop.value == null
                              ? ""
                              : createShopController.currentShop.value!.name!,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black));
                    })
                  ],
                ),
              ],
            )),
        body: historyWidget(context));
  }

  Widget historyWidget(context) {
    return Obx(() {
      return productController.countHistory.isEmpty
          ? noItemsFound(context, true)
          : isSmallScreen(context)
              ? ListView.builder(
                  shrinkWrap: true,
                  itemCount: productController.countHistory.length,
                  // physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    ProductCountModel productBody =
                        productController.countHistory.elementAt(index);

                    return productHistoryContainer(productBody);
                  })
              : Theme(
                  data: Theme.of(context).copyWith(dividerColor: Colors.grey),
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: DataTable(
                          headingTextStyle: const TextStyle(fontSize:16,color: Colors.black,fontWeight: FontWeight.bold),
                          dataTextStyle: const TextStyle(fontSize: 18,color: Colors.black),
                          decoration: BoxDecoration(
                              border: Border.all(
                            width: 1,
                            color: Colors.black,
                          )),
                          columnSpacing: 30.0,
                          columns: const [
                            DataColumn(
                                label:
                                    Text('Name', textAlign: TextAlign.center)),
                            DataColumn(
                                label: Text('System Count',
                                    textAlign: TextAlign.center)),
                            DataColumn(
                                label: Text('Physical Count',
                                    textAlign: TextAlign.center)),
                            DataColumn(
                                label: Text('Buying Price ',
                                    textAlign: TextAlign.center)),
                            DataColumn(
                                label: Text('Selling Price ',
                                    textAlign: TextAlign.center)),
                            DataColumn(
                                label:
                                    Text('Date', textAlign: TextAlign.center)),
                          ],
                          rows: List.generate(
                              productController.countHistory.length, (index) {
                            ProductCountModel productBody =
                                productController.countHistory.elementAt(index);
                            final y = productBody.product?.name;
                            final x = productBody.initialquantity;
                            final f = productBody.quantity;
                            final b = productBody.product?.buyingPrice;
                            final s = productBody.product?.selling;
                            final z = productBody.createdAt!;
                            // final a =
                            //     productBody.attendantId!.username ?? "";

                            return DataRow(cells: [
                              DataCell(Text(y!)),
                              DataCell(Text(x.toString())),
                              DataCell(Text(f.toString())),
                              DataCell(Text(b.toString())),
                              DataCell(Text(s.toString())),
                              DataCell(
                                  Text(DateFormat("yyyy-MM-dd").format(z))),
                            ]);
                          }),
                        ),
                      ),
                    ),
                  ),
                );
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
                        child: const Icon(Icons.check, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${productBody.product!.name}".capitalize!,
                        style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 2, horizontal: 5),
                        decoration: BoxDecoration(
                            color: Colors.black12,
                            borderRadius: BorderRadius.circular(5)),
                        child: Text(
                          'System Count ${productBody.initialquantity}, Physical Count ${productBody.quantity}',
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                      if (productBody.createdAt != null)
                        Text(
                            '${DateFormat("MMM dd,yyyy, hh:m a").format(productBody.createdAt!)} '),
                    ],
                  )
                ],
              ),
              const Spacer(),
              Column(
                children: [
                  Text('BP/= ${productBody.product!.buyingPrice}'),
                  Text('SP/= ${productBody.product!.selling}')
                ],
              )
            ],
          )),
        ),
      ),
    );
  }
}
