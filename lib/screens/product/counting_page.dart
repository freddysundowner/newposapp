import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/utils/constants.dart';
import 'package:flutterpos/widgets/increament_widget.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';
import 'count_history.dart';

class CountingPage extends StatelessWidget {
  CountingPage({Key? key}) : super(key: key);
  ProductController productController = Get.find<ProductController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    productController.searchProductQuantityController.text = "";
    productController.getProductsByCount(
        "${shopController.currentShop.value?.id}",
        productController.selectedSortOrderCountSearch.value);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        titleSpacing: 0.0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            majorTitle(title: "Stock Count", color: Colors.black, size: 16.0),
            minorTitle(
                title: "${shopController.currentShop.value?.name}",
                color: Colors.grey)
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(children: [
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller:
                        productController.searchProductQuantityController,
                    onChanged: (value) {
                      if (value == "") {
                        productController.getProductsByCount(
                            "${shopController.currentShop.value?.id}",
                            productController
                                .selectedSortOrderCountSearch.value);
                      } else {
                        productController.searchProduct(
                            "${shopController.currentShop.value!.id}", "count");
                      }
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                        suffixIcon: IconButton(
                          onPressed: () {
                            productController.searchProduct(
                                "${shopController.currentShop.value!.id}",
                                "count");
                          },
                          icon: Icon(Icons.search),
                        ),
                        hintText: "Quick Search Item",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                ),
                IconButton(
                    onPressed: () async {
                      productController.scanQR(
                          shopId: "${shopController.currentShop.value!.id}",
                          type: "count", context: context);
                    },
                    icon: Icon(Icons.qr_code))
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Items Available'),
                Obx(() {
                  return Text("${productController.products.length}");
                })
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Count History'),
                InkWell(
                  onTap: () {
                    Get.to(CountHistory());
                  },
                  child: minorTitle(title: "View", color: AppColors.mainColor),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Sort By"),
                InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) {
                        return SimpleDialog(
                          children: List.generate(
                              Constants().sortOrderCaunt.length,
                              (index) => SimpleDialogOption(
                                    onPressed: () {
                                      productController
                                              .selectedSortOrderCount.value =
                                          Constants()
                                              .sortOrderCaunt
                                              .elementAt(index);
                                      productController
                                              .selectedSortOrderCountSearch
                                              .value =
                                          Constants()
                                              .sortOrderCauntList
                                              .elementAt(index);
                                      productController.getProductsByCount(
                                          "${shopController.currentShop.value?.id}",
                                          productController
                                              .selectedSortOrderCountSearch
                                              .value);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      Constants()
                                          .sortOrderCaunt
                                          .elementAt(index),
                                    ),
                                  )),
                        );
                      },
                    );
                  },
                  child: Row(
                    children: [
                      Obx(() {
                        return Text(
                            productController.selectedSortOrderCount.value,
                            style: TextStyle(color: AppColors.mainColor));
                      }),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.mainColor,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10),
          Obx(() {
            return productController.getProductCountLoad.value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: productController.products.length,
                    itemBuilder: (context, index) {
                      ProductModel productBody =
                          productController.products.elementAt(index);
                      return incrementWidget(
                          index: index, product: productBody, context: context);
                    });
          })
        ]),
      ),
    );
  }
}
