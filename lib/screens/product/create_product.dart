import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:get/get.dart';

import '../../../controllers/AuthController.dart';
import '../../../controllers/product_controller.dart';
import '../../../utils/colors.dart';
import '../../../widgets/bigtext.dart';
import '../../../widgets/smalltext.dart';

class CreateProduct extends StatelessWidget {
  CreateProduct({Key? key}) : super(key: key);
  ShopController shopController = Get.find<ShopController>();
  ProductController productController = Get.find<ProductController>();

  // SupplierController supplierController = Get.find<SupplierController>();
  AuthController authController = Get.find<AuthController>();
  var measures = [
    'Kg',
    "Litter",
    "Pieces",
    'Ml',
    'Box',
  ];

  @override
  Widget build(BuildContext context) {
    // supplierController.getSuppliersByAttendantId(createShopController.currentShop.value!.id!);
    productController.getProductCategory(
        shopId: shopController.currentShop.value?.id);
    return Scaffold(
      appBar: AppBar(
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
                title: "Add New Product", color: Colors.black, size: 16.0),
            minorTitle(
                title: "${shopController.currentShop.value?.name}",
                color: Colors.grey)
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Text("Item Name *"),
              SizedBox(height: 5),
              TextFormField(
                controller: productController.itemNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  SizedBox(width: 3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Buying Price *"),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: productController.buyingPriceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "0",
                            fillColor: Colors.white,
                            filled: true,
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Selling price *"),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: productController.sellingPriceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "0",
                            fillColor: Colors.white,
                            filled: true,
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Min Selling price "),
                        SizedBox(height: 5),
                        TextFormField(
                          controller:
                          productController.minsellingPriceController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            hintText: "0",
                            fillColor: Colors.white,
                            filled: true,
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Qty *"),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: productController.qtyController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "0",
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Max Discount "),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: productController.discountController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "0",
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Re-Order Level "),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: productController.reOrderController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "0",
                            labelStyle: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Category *",
                            style: TextStyle(color: Colors.black)),
                        SizedBox(height: 5),
                        InkWell(
                          onTap: () {
                            if (productController.productCategory.length == 0) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content:
                                      Text("Add Category to continue."),
                                      actions: [
                                        TextButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            Get.back();
                                          },
                                        )
                                      ],
                                    );
                                  });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                      children: List.generate(
                                          productController
                                              .productCategory.length,
                                              (index) =>
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  productController
                                                      .categoryName.value =
                                                  productController
                                                      .productCategory
                                                      .elementAt(index)
                                                      .name!;
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                    "${productController
                                                        .productCategory
                                                        .elementAt(index)
                                                        .name}"),
                                              )),
                                    );
                                  });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() {
                                  return Text(
                                      productController.categoryName.value);
                                }),
                                Icon(Icons.arrow_drop_down, color: Colors.grey)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Add Category Name"),
                                  content: Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: TextFormField(
                                        controller: productController.category,
                                        decoration: InputDecoration(
                                            hintText: "eg. fruits",
                                            border: OutlineInputBorder(
                                              borderRadius:
                                              BorderRadius.circular(10),
                                            ))),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        "Cancel".toUpperCase(),
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        productController.createCategory(
                                            shopId: shopController
                                                .currentShop.value!.id!,
                                            context: context);
                                      },
                                      child: Text(
                                        "Save now".toUpperCase(),
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ],
                                );
                              });
                        },
                        child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            child: Text(
                              "+ Add",
                              style: TextStyle(color: Colors.green),
                            )),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Unit Of Measure "),
                        SizedBox(height: 5),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return SimpleDialog(
                                    children: List.generate(
                                        measures.length,
                                            (index) =>
                                            SimpleDialogOption(
                                              onPressed: () {
                                                productController
                                                    .selectedMeasure.value =
                                                    measures.elementAt(index);

                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                  "${measures.elementAt(
                                                      index)}"),
                                            )),
                                  );
                                });
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() {
                                  return Text(
                                      productController.selectedMeasure.value);
                                }),
                                Icon(Icons.arrow_drop_down, color: Colors.grey)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Supplier", style: TextStyle(color: Colors.black)),
                        SizedBox(height: 5),
                        InkWell(
                          onTap: () {
                            if (productController.selectedSupplier.length ==
                                0) {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      content:
                                      Text("Add suppliers to continue."),
                                      actions: [
                                        TextButton(
                                          child: Text("OK"),
                                          onPressed: () {
                                            Get.back();
                                          },
                                        )
                                      ],
                                    );
                                  });
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return SimpleDialog(
                                      children: List.generate(
                                          productController
                                              .selectedSupplier.length,
                                              (index) =>
                                              SimpleDialogOption(
                                                onPressed: () {
                                                  productController
                                                      .supplierName.value =
                                                  productController
                                                      .selectedSupplier
                                                      .elementAt(
                                                      index)["name"]!;
                                                  productController
                                                      .supplierId.value =
                                                  productController
                                                      .selectedSupplier
                                                      .elementAt(
                                                      index)["id"]!;

                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                    "${productController
                                                        .selectedSupplier
                                                        .elementAt(
                                                        index)["name"]}"),
                                              )),
                                    );
                                  });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Obx(() {
                                  return Text(
                                      productController.supplierName.value);
                                }),
                                Icon(Icons.arrow_drop_down, color: Colors.grey)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: TextButton(
                        onPressed: () {
                          // Get.to(() => CustomerCreate(
                          //       type: "suppliers",
                          //       shopId:
                          //           createShopController.currentShop.value!.id,
                          //     ));
                        },
                        child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.grey.withOpacity(0.2),
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10))),
                            child: Text(
                              "+ Add",
                              style: TextStyle(color: Colors.green),
                            )),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Description"),
                  SizedBox(height: 5),
                  TextFormField(
                    controller: productController.descriptionController,
                    keyboardType: TextInputType.text,
                    minLines: 3,
                    maxLines: 6,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "optional",
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          height: kToolbarHeight * 1.5,
          decoration:
          BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: Obx(() {
            return productController.creatingProductLoad.value ? Center(
              child: CircularProgressIndicator(),) :
            InkWell(
              splashColor: Colors.transparent,
              onTap: () {
                productController.saveProducts(
                    "${shopController.currentShop.value!.id}",
                    authController.currentUser.value!.id!,
                    context);
              },
              child: Container(
                padding: EdgeInsets.all(10),
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(width: 3, color: AppColors.mainColor),
                    borderRadius: BorderRadius.circular(40)),
                child: Center(
                    child: majorTitle(
                        title: "Add Product",
                        color: AppColors.mainColor,
                        size: 18.0)),
              ),
            );
          }),
        ),
      ),
    );
  }
}
