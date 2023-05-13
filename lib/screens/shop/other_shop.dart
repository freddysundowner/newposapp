import 'package:flutter/material.dart';
import 'package:pointify/controllers/attendant_controller.dart';
import 'package:pointify/models/product_model.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:get/get.dart';

import '../../controllers/product_controller.dart';
import '../../controllers/shop_controller.dart';
import '../../utils/colors.dart';

class ViewOtherShop extends StatelessWidget {
  ViewOtherShop({Key? key}) : super(key: key);
  ShopController createShopController = Get.find<ShopController>();
  AttendantController attendantController = Get.find<AttendantController>();
  ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    createShopController.getShops(
        adminId: attendantController.attendant.value!.shop!.owner);
    productController.getProductsBySort(type: "all");
    return WillPopScope(
      onWillPop: () async {
        createShopController.currentShop.value =
            attendantController.attendant.value?.shop;
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white.withOpacity(0.96),
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.white,
          centerTitle: false,
          titleSpacing: 0.0,
          title: Text(
            "Shops",
            style: TextStyle(color: Colors.black),
          ),
          leading: MediaQuery.of(context).size.width > 600
              ? Container()
              : IconButton(
                  onPressed: () {
                    Get.back();
                    createShopController.currentShop.value =
                        attendantController.attendant.value?.shop;
                  },
                  icon: Icon(Icons.arrow_back_ios, color: Colors.black),
                ),
        ),
        body: ResponsiveWidget(
            largeScreen: Container(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    searchWidget(context),
                    Obx(() {
                      return productController.getProductLoad.value
                              ? Center(
                                  child: CircularProgressIndicator(),
                                )
                              : productController.products.length == 0
                                  ? Center(
                                      child: Text(
                                      "No Entries found",
                                      style:
                                          TextStyle(color: AppColors.mainColor),
                                    ))
                                  : Theme(
                                      data: Theme.of(context)
                                          .copyWith(dividerColor: Colors.grey),
                                      child: Container(
                                        width: double.infinity,
                                        margin: EdgeInsets.only(
                                            right: 15, left: 15, bottom: 20),
                                        child: DataTable(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                            width: 1,
                                            color: Colors.black,
                                          )),
                                          columnSpacing: 30.0,
                                          columns: [
                                            DataColumn(
                                                label: Text('Product',
                                                    textAlign:
                                                        TextAlign.center)),
                                            DataColumn(
                                                label: Text('Category',
                                                    textAlign:
                                                        TextAlign.center)),
                                            DataColumn(
                                                label: Text('Available',
                                                    textAlign:
                                                        TextAlign.center)),
                                            DataColumn(
                                                label: Text('Buying Price',
                                                    textAlign:
                                                        TextAlign.center)),
                                            DataColumn(
                                                label: Text('Selling Price',
                                                    textAlign:
                                                        TextAlign.center)),
                                          ],
                                          rows: List.generate(
                                              productController.products.length,
                                              (index) {
                                            ProductModel productBody =
                                                productController.products
                                                    .elementAt(index);
                                            final y = productBody.name;
                                            final x =
                                                productBody.category!.name;
                                            final w = productBody.quantity;
                                            final z = productBody.buyingPrice;
                                            final a =
                                                productBody.sellingPrice![0];

                                            return DataRow(cells: [
                                              DataCell(Container(
                                                  width: 75, child: Text(y!))),
                                              DataCell(Container(
                                                  width: 75,
                                                  child: Text(x.toString()))),
                                              DataCell(Container(
                                                  width: 75,
                                                  child: Text(w.toString()))),
                                              DataCell(Container(
                                                  width: 75,
                                                  child: Text(z.toString()))),
                                              DataCell(Container(
                                                  width: 75,
                                                  child: Text(a.toString()))),
                                            ]);
                                          }),
                                        ),
                                      ),
                                    )

                          // GridView.builder(
                          //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          //         childAspectRatio: MediaQuery.of(context).size.width *
                          //             1.2 /
                          //             MediaQuery.of(context).size.height,
                          //         crossAxisCount: 3,
                          //         crossAxisSpacing: 10,
                          //         mainAxisSpacing: 10),
                          //     shrinkWrap: true,
                          //     itemCount: productController.products.length,
                          //     itemBuilder: (context, index) {
                          //       ProductModel productBody =
                          //           productController.products.elementAt(index);
                          //       return incrementWidget(
                          //           index: index, product: productBody, context: context);
                          //     })
                          //
                          ;
                    }),
                  ],
                ),
              ),
            ),
            smallScreen: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: kToolbarHeight * 1.5),
                      Obx(() {
                        return productController.getProductLoad.value
                            ? Center(child: CircularProgressIndicator())
                            : productController.products.length == 0
                                ? Center(
                                    child: Text(
                                    "No Entries found",
                                    style:
                                        TextStyle(color: AppColors.mainColor),
                                  ))
                                : Container(
                                    // height: MediaQuery.of(context).size.height*0.6,
                                    child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount:
                                            productController.products.length,
                                        shrinkWrap: true,
                                        itemBuilder: ((context, index) {
                                          ProductModel productBody =
                                              productController.products
                                                  .elementAt(index);

                                          return productCont(productBody);
                                        })),
                                  );
                      }),
                    ],
                  ),
                ),
                Positioned(
                    top: 0, left: 0, right: 0, child: searchWidget(context)),
              ],
            )),
      ),
    );
  }

  Widget searchWidget(context) {
    return Container(
      color: Colors.white,
      height: kToolbarHeight * 1.5,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(15, 3, 15, 3),
            child: Text(
              'Select Shop',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: () {
              showDialog(
                context: context,
                builder: (_) {
                  return SimpleDialog(
                    children: List.generate(
                        createShopController.allShops.length,
                        (index) => SimpleDialogOption(
                              onPressed: () {
                                Navigator.pop(context);
                                createShopController.currentShop.value =
                                    createShopController.allShops
                                        .elementAt(index);
                                productController.getProductsBySort(
                                    type: "all");
                              },
                              child: Text(
                                createShopController.allShops
                                    .elementAt(index)
                                    .name!,
                              ),
                            )),
                  );
                },
              );
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(50)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      return Text(createShopController.currentShop.value == null
                          ? ""
                          : createShopController.currentShop.value!.name!);
                    }),
                    Icon(Icons.arrow_drop_down, color: Colors.grey)
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget productCont(ProductModel productBody) {
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${productBody.name}".capitalize!,
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      Text("Category: ${productBody.category!.name}"),
                      Text('Available: ${productBody.quantity}'),
                    ],
                  )
                ],
              ),
              Spacer(),
              Row(children: [
                Column(
                  children: [
                    Text('BP/= ${productBody.buyingPrice}'),
                    Text('SP/= ${productBody.sellingPrice![0]}')
                  ],
                ),
              ])
            ],
          )),
        ),
      ),
    );
  }
}
