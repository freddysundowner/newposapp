import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/product_controller.dart';
import 'package:flutterpos/controllers/stock_transfer_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:get/get.dart';

class StockSubmit extends StatelessWidget {
  StockSubmit({Key? key}) : super(key: key);
  StockTransferController stockTransferController = Get.find<StockTransferController>();
  ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.2,
        title: Text(
          "Transfer",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        actions: [
          Obx(() {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    Text(
                      "Submit",
                      style: TextStyle(
                          color:
                              stockTransferController.selectedProducts.length ==
                                      0
                                  ? Colors.grey
                                  : Colors.black),
                    ),
                    Icon(
                      Icons.check,
                      color:
                          stockTransferController.selectedProducts.length == 0
                              ? Colors.grey
                              : Colors.black,
                    ),
                  ],
                ),
              ),
            );
          })
        ],
      ),
      body: Obx(() => ListView.builder(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              ProductModel productModel =
                  stockTransferController.selectedProducts.elementAt(index);
              return Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey, //New
                        blurRadius: 2.0,
                        offset: Offset(1, 1))
                  ],
                ),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 7, top: 3),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${productModel.name}".capitalize!,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                    SizedBox(height: 5),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "System Count".capitalize!,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "${productModel.quantity}",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          flex: 4,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Transfer Count".capitalize!,
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        if (productModel.cartquantity! > 1) {
                                          productModel.cartquantity =
                                              productModel.cartquantity! - 1;
                                          stockTransferController
                                              .selectedProducts
                                              .refresh();
                                        }
                                      },
                                      child: Icon(Icons.remove_circle_outline)),
                                  Spacer(),
                                  Text(
                                    "${productModel.cartquantity}",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                  ),
                                  Spacer(),
                                  InkWell(
                                      onTap: () {
                                        if (productModel.cartquantity! <
                                            productModel.quantity!) {
                                          productModel.cartquantity =
                                              productModel.cartquantity! + 1;
                                          stockTransferController
                                              .selectedProducts
                                              .refresh();
                                        }
                                      },
                                      child: Icon(Icons.add_circle_outline)),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                stockTransferController.selectedProducts
                                    .removeWhere((element) =>
                                        element.id == productModel.id);
                                stockTransferController.selectedProducts
                                    .refresh();
                                productController.products.refresh();
                              },
                              child: Icon(
                                Icons.clear,
                                color: AppColors.mainColor,
                              ),
                            ))
                      ],
                    )
                  ],
                ),
              );
            },
            itemCount: stockTransferController.selectedProducts.length,
          )),
    );
  }
}
