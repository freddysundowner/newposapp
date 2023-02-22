import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/stock_transfer_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/models/shop_model.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';
import '../../widgets/snackBars.dart';

class ProductSelections extends StatelessWidget {
  final ShopModel shopModel;

  ProductSelections({Key? key, required this.shopModel}) : super(key: key);
  ProductController productController = Get.find<ProductController>();
  StockTransferController stockTransferController =
      Get.find<StockTransferController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          titleSpacing: 0.0,
          backgroundColor: Colors.white,
          elevation: 0.3,
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
              majorTitle(
                  title: "Product Selection", color: Colors.black, size: 16.0),
            ],
          ),
        ),
        body: Obx(() {
          return productController.products.length == 0
              ? Center(
                  child: Text("no products to transfer"),
                )
              : ListView.builder(
                  itemCount: productController.products.length,
                  // physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    ProductModel productBody =
                        productController.products.elementAt(index);

                    return InkWell(
                      onTap: () {
                        if (productBody.quantity! > 0) {
                          stockTransferController.addToList(productBody);
                        } else {
                          showSnackBar(
                              message:
                                  "You cannot transfer product that is outof stock",
                              color: Colors.red);
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          elevation: 4,
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    majorTitle(
                                        title: "${productBody.name}",
                                        color: Colors.black,
                                        size: 16.0),
                                    SizedBox(height: 10),
                                    minorTitle(
                                        title:
                                            "Category: ${productBody.category!.name}",
                                        color: Colors.grey),
                                    SizedBox(height: 10),
                                    Text(
                                        "Qty Available: ${productBody.quantity}",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 16))
                                  ],
                                ),
                                Checkbox(
                                    value: stockTransferController
                                                .selectedProducts
                                                .indexWhere((element) =>
                                                    element.id ==
                                                    productBody.id) !=
                                            -1
                                        ? true
                                        : false,
                                    onChanged: (value) {})
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  });
        }),
        bottomNavigationBar: BottomAppBar(
          color: Colors.white,
          child: Obx(() {
            return stockTransferController.selectedProducts.length == 0
                ? Container(
                    height: 0,
                  )
                : Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(10),
                    height: kToolbarHeight * 1.5,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey)),
                    child: InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 3, color: AppColors.mainColor),
                            borderRadius: BorderRadius.circular(40)),
                        child: Center(
                            child: majorTitle(
                                title: "Proceed",
                                color: AppColors.mainColor,
                                size: 18.0)),
                      ),
                    ),
                  );
          }),
        ));
  }
}
