

import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/attendant_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/services/apiurls.dart';
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
    createShopController.getShopsByAdminId(adminId:attendantController.attendant.value!.shop!.owner);
    productController.getProductsBySort(shopId:attendantController.attendant.value!.shop!.id!,type: "all");
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.96),
      appBar: AppBar(
        elevation: 0.0,
        title: Text("Shops"),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
      ),
      body: Stack(
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
                        style: TextStyle(color: AppColors.mainColor),
                      ))
                      : Container(
                    // height: MediaQuery.of(context).size.height*0.6,
                    child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: productController.products.length,
                        shrinkWrap: true,
                        itemBuilder: ((context, index) {
                          ProductModel productBody = productController
                              .products
                              .elementAt(index);

                          return productCont( productBody);
                        })),
                  );
                }),
              ],
            ),
          ),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (_) {
                            return SimpleDialog(
                              children: List.generate(
                                  createShopController.AdminShops.length,
                                      (index) => SimpleDialogOption(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      createShopController.currentShop.value =
                                          createShopController.AdminShops
                                              .elementAt(index);
                                      productController.getProductsBySort(shopId:attendantController.attendant.value!.shop!.id!,type: "all");
                                    },
                                    child: Text(
                                      createShopController.AdminShops
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
                                return Text(createShopController
                                    .currentShop.value ==
                                    null
                                    ? ""
                                    : createShopController
                                    .currentShop.value!.name!);
                              }),
                              Icon(Icons.arrow_drop_down, color: Colors.grey)
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget productCont( ProductModel productBody){
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
                          Text("${productBody.name}".capitalize!,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
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