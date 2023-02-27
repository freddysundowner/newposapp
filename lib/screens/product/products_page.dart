import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/utils/constants.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/product_card.dart';
import '../../widgets/smalltext.dart';

class ProductPage extends StatelessWidget {
  ProductPage({Key? key}) : super(key: key);
  ShopController createShopController = Get.find<ShopController>();
  ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    productController.searchProductController.text = "";
    productController.getProductsBySort(
        shopId: "${createShopController.currentShop.value?.id}",
        type: productController.selectedSortOrderSearch.value);
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
            majorTitle(title: "Shop Products", color: Colors.black, size: 16.0),
            minorTitle(
                title: "${createShopController.currentShop.value?.name}",
                color: Colors.grey)
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: productController.searchProductController,
                      onChanged: (value) {
                        if (value=="") {
                          productController.getProductsBySort(
                              shopId: "${createShopController.currentShop.value?.id}",
                              type: productController.selectedSortOrderSearch.value);
                        }  else{
                          productController.searchProduct(
                              createShopController.currentShop.value == null
                                  ? ""
                                  : "${createShopController.currentShop.value!.id}",
                              "product");
                        }

                      },
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                          suffixIcon: IconButton(
                            onPressed: () {
                              productController.searchProduct(
                                  createShopController.currentShop.value == null
                                      ? ""
                                      : "${createShopController.currentShop.value?.id}",
                                  "product");
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
                            shopId: createShopController.currentShop.value == null
                                ? ""
                                : "${createShopController.currentShop.value?.id}",
                            type: "product"
                        );
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
                  Text("Sort List By"),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return SimpleDialog(
                            children: List.generate(
                                Constants().sortOrder.length,
                                (index) => SimpleDialogOption(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        productController
                                                .selectedSortOrder.value =
                                            Constants()
                                                .sortOrder
                                                .elementAt(index);
                                        productController
                                                .selectedSortOrderSearch.value =
                                            Constants()
                                                .sortOrderList
                                                .elementAt(index);
                                        productController.getProductsBySort(
                                            shopId:
                                                "${createShopController.currentShop.value!.id}",
                                            type: productController
                                                .selectedSortOrderSearch.value);
                                      },
                                      child: Text(
                                        Constants().sortOrder.elementAt(index),
                                      ),
                                    )),
                          );
                        },
                      );
                    },
                    child: Row(
                      children: [
                        Obx(() {
                          return Text(productController.selectedSortOrder.value,
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
            SizedBox(height: 20),
            Obx(() {
              return productController.getProductLoad.value
                  ? Center(child: CircularProgressIndicator())
                  : productController.products.length == 0
                      ? Center(
                          child: Text(
                          "No Entries found",
                          style: TextStyle(color: AppColors.mainColor),
                        ))
                      : Container(
                          // height: MediaQuery.of(context).size.height*0.6,
                          child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: productController.products.length,
                              shrinkWrap: true,
                              itemBuilder: ((context, index) {
                                ProductModel productModel =
                                    productController.products.elementAt(index);
                                return productCard(
                                    shopId:
                                        "${createShopController.currentShop.value!.id}",
                                    context: context,
                                    product: productModel);
                              })),
                        );
            }),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
