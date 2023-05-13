import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/controllers/stock_transfer_controller.dart';
import 'package:pointify/models/product_model.dart';
import 'package:pointify/models/shop_model.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/stock/products_selection.dart';
import 'package:pointify/utils/colors.dart';
import 'package:get/get.dart';

class StockSubmit extends StatelessWidget {
  final to;
  ShopModel shopModel;

  StockSubmit({Key? key, required this.to, required this.shopModel})
      : super(key: key);
  StockTransferController stockTransferController =
      Get.find<StockTransferController>();
  ProductController productController = Get.find<ProductController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        elevation: 0.2,
        title: Text(
          "Transfer",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            onPressed: () {
              if (MediaQuery.of(context).size.width > 600) {
                Get.find<HomeController>().selectedWidget.value =
                    ProductSelections(shopModel: shopModel);
              } else {
                Get.back();
              }
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
                onTap: () {
                  stockTransferController.submitTranster(
                      to: to,
                      from: shopController.currentShop.value!.id,
                      context: context);
                },
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
      body: ResponsiveWidget(
          largeScreen: Obx(() => SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  width: double.infinity,
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: Colors.grey),
                    child: DataTable(
                      decoration: BoxDecoration(
                          border: Border.all(
                        width: 1,
                        color: Colors.black,
                      )),
                      columnSpacing: 30.0,
                      columns: [
                        DataColumn(
                            label: Text('Name', textAlign: TextAlign.center)),
                        DataColumn(
                            label: Text('System Count',
                                textAlign: TextAlign.center)),
                        DataColumn(
                            label:
                                Text('Quantity', textAlign: TextAlign.center)),
                        DataColumn(
                            label: Text('', textAlign: TextAlign.center)),
                      ],
                      rows: List.generate(
                          stockTransferController.selectedProducts.length,
                          (index) {
                        ProductModel productModel = stockTransferController
                            .selectedProducts
                            .elementAt(index);
                        final y = productModel.name;
                        final x = productModel.quantity;
                        final z = productModel.cartquantity;

                        return DataRow(cells: [
                          DataCell(Container(width: 75, child: Text(y!))),
                          DataCell(
                              Container(width: 75, child: Text(x.toString()))),
                          DataCell(Container(
                              width: 75,
                              child: Row(
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
                              ))),
                          DataCell(Container(
                              width: 75,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                    onTap: () {
                                      stockTransferController.selectedProducts
                                          .removeWhere((element) =>
                                              element.id == productModel.id);
                                      stockTransferController.selectedProducts
                                          .refresh();
                                      productController.products.refresh();
                                    },
                                    child: Icon(Icons.clear)),
                              ))),
                        ]);
                      }),
                    ),
                  ),
                ),
              )),
          smallScreen: Obx(
            () => ListView.builder(
              shrinkWrap: true,
              itemBuilder: (context, index) {
                ProductModel productModel =
                    stockTransferController.selectedProducts.elementAt(index);
                return selectedProducts(productModel);
              },
              itemCount: stockTransferController.selectedProducts.length,
            ),
          )),
    );
  }

  selectedProducts(ProductModel productModel) {
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
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 16),
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
                      style: TextStyle(color: Colors.grey, fontSize: 15),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "${productModel.quantity}",
                      style: TextStyle(color: Colors.grey, fontSize: 15),
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
                      style: TextStyle(color: Colors.grey, fontSize: 15),
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
                                stockTransferController.selectedProducts
                                    .refresh();
                              }
                            },
                            child: Icon(Icons.remove_circle_outline)),
                        Spacer(),
                        Text(
                          "${productModel.cartquantity}",
                          style: TextStyle(color: Colors.grey, fontSize: 15),
                        ),
                        Spacer(),
                        InkWell(
                            onTap: () {
                              if (productModel.cartquantity! <
                                  productModel.quantity!) {
                                productModel.cartquantity =
                                    productModel.cartquantity! + 1;
                                stockTransferController.selectedProducts
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
                      stockTransferController.selectedProducts.removeWhere(
                          (element) => element.id == productModel.id);
                      stockTransferController.selectedProducts.refresh();
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
  }
}
