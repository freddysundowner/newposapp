import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/utils/constants.dart';
import 'package:flutterpos/widgets/increament_widget.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';
import 'count_history.dart';

class CountingPage extends StatelessWidget {
  CountingPage({Key? key}) : super(key: key) {
    productController.searchProductQuantityController.text = "";
    productController.getProductsByCount(
        "${shopController.currentShop.value?.id}",
        productController.selectedSortOrderCountSearch.value);
  }

  ProductController productController = Get.find<ProductController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                majorTitle(
                    title: "Stock Count", color: Colors.black, size: 16.0),
                minorTitle(
                    title: "${shopController.currentShop.value?.name}",
                    color: Colors.grey)
              ],
            ),
            MediaQuery.of(context).size.width > 600
                ? Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: InkWell(
                      onTap: () {
                        Get.to(CountHistory());
                      },
                      child: majorTitle(
                          title: "Count History",
                          color: Colors.black,
                          size: 16.0),
                    ),
                  )
                : Container()
          ],
        ),
      ),
      body: ResponsiveWidget(
        largeScreen: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(child: searchTextField()),
                    SizedBox(width: 50),
                    sortWidget(context)
                  ],
                ),
              ),
              SizedBox(height: 15),
              Obx(() {
                return productController.getProductCountLoad.value
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio:
                                MediaQuery.of(context).size.width *
                                    1.4 /
                                    MediaQuery.of(context).size.height,
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10),
                        shrinkWrap: true,
                        itemCount: productController.products.length,
                        itemBuilder: (context, index) {
                          ProductModel productBody =
                              productController.products.elementAt(index);
                          return incrementWidget(
                              index: index,
                              product: productBody,
                              context: context);
                        });
              })
            ],
          ),
        ),
        smallScreen: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              child: Row(
                children: [
                  Expanded(
                    child: searchTextField(),
                  ),
                  IconButton(
                      onPressed: () async {
                        productController.scanQR(
                            shopId: "${shopController.currentShop.value!.id}",
                            type: "count",
                            context: context);
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
            if (Get.find<AuthController>().currentUser.value != null)
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
                      child:
                          minorTitle(title: "View", color: AppColors.mainColor),
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
                  sortWidget(context),
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
                            index: index,
                            product: productBody,
                            context: context);
                      });
            })
          ]),
        ),
      ),
    );
  }

  Widget sortWidget(context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) {
            return SimpleDialog(
              children: List.generate(
                  Constants().sortOrderCaunt.length,
                  (index) => SimpleDialogOption(
                        onPressed: () {
                          productController.selectedSortOrderCount.value =
                              Constants().sortOrderCaunt.elementAt(index);
                          productController.selectedSortOrderCountSearch.value =
                              Constants().sortOrderCauntList.elementAt(index);
                          productController.getProductsByCount(
                              "${shopController.currentShop.value?.id}",
                              productController
                                  .selectedSortOrderCountSearch.value);
                          Navigator.pop(context);
                        },
                        child: Text(
                          Constants().sortOrderCaunt.elementAt(index),
                        ),
                      )),
            );
          },
        );
      },
      child: Row(
        children: [
          Obx(() {
            return Text(productController.selectedSortOrderCount.value,
                style: TextStyle(color: AppColors.mainColor));
          }),
          Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.mainColor,
          )
        ],
      ),
    );
  }

  Widget searchTextField() {
    return TextFormField(
      controller: productController.searchProductQuantityController,
      onChanged: (value) {
        if (value == "") {
          productController.products.clear();
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
                "${shopController.currentShop.value!.id}", "count");
          },
          icon: Icon(Icons.search),
        ),
        hintText: "Quick Search Item",
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey, width: 1)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey, width: 1)),
      ),
    );
  }
}
