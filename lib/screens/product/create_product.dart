import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/product/products_page.dart';
import 'package:get/get.dart';
import 'package:pointify/screens/suppliers/create_suppliers.dart';
import 'package:realm/realm.dart';

import '../../../controllers/product_controller.dart';
import '../../../utils/colors.dart';
import '../../../widgets/bigtext.dart';
import '../../../widgets/smalltext.dart';
import '../../Real/schema.dart';
import '../../controllers/AuthController.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/supplierController.dart';
import '../../data/interests.dart';
import '../../services/category.dart';
import '../../services/supplier.dart';
import '../stock/stock_page.dart';

class CreateProduct extends StatelessWidget {
  final page;
  final Product? productModel;

  CreateProduct({Key? key, required this.page, required this.productModel})
      : super(key: key) {
    if (page == "create") {
      productController.clearControllers();
      supplierController.getSuppliersInShop("all");
    } else {
      productController.assignTextFields(productModel!);
    }
  }

  ShopController shopController = Get.find<ShopController>();
  ProductController productController = Get.find<ProductController>();
  SupplierController supplierController = Get.find<SupplierController>();
  AuthController authController = Get.find<AuthController>();
  UserController userController = Get.find<UserController>();
  var measures = [
    'Kg',
    "Liter",
    "Pieces",
    'Ml',
    'Box',
  ];

  @override
  Widget build(BuildContext context) {
    print(page);
    // Categories().getProductsCategories();
    return WillPopScope(
      onWillPop: () async {
        productController.selectedSupplier.clear();
        return true;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.1,
          titleSpacing: 0.0,
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              if (!isSmallScreen(context)) {
                if (page == "edit") {
                  Get.find<HomeController>().selectedWidget.value =
                      ProductPage();
                } else if (userController.user.value?.usertype == "attendant") {
                  Get.find<HomeController>().selectedWidget.value =
                      ProductPage();
                } else {
                  Get.find<HomeController>().selectedWidget.value = StockPage();
                }
              } else {
                productController.selectedSupplier.clear();
                Get.back();
              }
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              majorTitle(
                  title: page == "edit" ? "Edit Product" : "Add New Product",
                  color: Colors.black,
                  size: 16.0),
              minorTitle(
                  title: "${shopController.currentShop.value?.name}",
                  color: Colors.grey)
            ],
          ),
          actions: [
            if (!isSmallScreen(context))
              InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  productController.saveProducts(productData: productModel);
                },
                child: Container(
                  height: kTextTabBarHeight,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.symmetric(vertical: 5)
                      .copyWith(right: 15),
                  decoration: BoxDecoration(
                      border: Border.all(width: 3, color: AppColors.mainColor),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                      child: majorTitle(
                          title: page == "create" ? "Save product" : "Update",
                          color: AppColors.mainColor,
                          size: 14.0)),
                ),
              )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, top: 5.0, bottom: 10),
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 10),
              const Text("Product Name *"),
              const SizedBox(height: 5),
              TextFormField(
                controller: productController.itemNameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const SizedBox(width: 3),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Buying Price *"),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: productController.buyingPriceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            hintText: "0",
                            fillColor: Colors.white,
                            filled: true,
                            labelStyle: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Selling price *"),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: productController.sellingPriceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            hintText: "0",
                            fillColor: Colors.white,
                            filled: true,
                            labelStyle: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Min Selling price "),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller:
                              productController.minsellingPriceController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            hintText: "0",
                            fillColor: Colors.white,
                            filled: true,
                            labelStyle: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Qty *"),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: productController.qtyController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "0",
                            labelStyle: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Max Discount "),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: productController.discountController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "0",
                            labelStyle: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Re-Order Level "),
                        const SizedBox(height: 5),
                        TextFormField(
                          controller: productController.reOrderController,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "0",
                            labelStyle: const TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Category *",
                            style: TextStyle(color: Colors.black)),
                        const SizedBox(height: 5),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return StreamBuilder<
                                          RealmResultsChanges<ProductCategory>>(
                                      stream:
                                          Categories().getProductCategories(),
                                      builder: (context, snapshot) {
                                        final data = snapshot.data;
                                        print(data);

                                        if (data == null) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }

                                        final results = data.results;

                                        return SimpleDialog(
                                          children: List.generate(
                                              results.realm.isClosed
                                                  ? 0
                                                  : results.length,
                                              (index) => SimpleDialogOption(
                                                    onPressed: () {
                                                      productController
                                                              .categoryId
                                                              .value =
                                                          results
                                                              .elementAt(index);
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                        "${results.elementAt(index).name}"),
                                                  )),
                                        );
                                      });
                                });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
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
                                      productController.categoryId.value != null
                                          ? productController
                                              .categoryId.value!.name!
                                          : "choose category");
                                }),
                                const Icon(Icons.arrow_drop_down,
                                    color: Colors.grey)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Unit Of Measure "),
                        const SizedBox(height: 5),
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return SimpleDialog(
                                    children: List.generate(
                                        measures.length,
                                        (index) => SimpleDialogOption(
                                              onPressed: () {
                                                productController
                                                        .selectedMeasure.value =
                                                    measures.elementAt(index);

                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                  "${measures.elementAt(index)}"),
                                            )),
                                  );
                                });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
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
                                const Icon(Icons.arrow_drop_down,
                                    color: Colors.grey)
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (page == "create")
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Supplier",
                              style: TextStyle(color: Colors.black)),
                          const SizedBox(height: 5),
                          InkWell(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StreamBuilder<
                                            RealmResultsChanges<Supplier>>(
                                        stream: SupplierService()
                                            .getSuppliersByShopId(
                                                shop: shopController
                                                    .currentShop.value!)
                                            .changes,
                                        builder:
                                            (context, AsyncSnapshot snapshot) {
                                          final data = snapshot.data;

                                          if (data == null) {
                                            return CreateSuppliers(
                                              page: "createProduct",
                                            );
                                          } else {
                                            final results = data.results;
                                            return SimpleDialog(
                                              children: List.generate(
                                                  results.realm.isClosed
                                                      ? 0
                                                      : results.length,
                                                  (index) => SimpleDialogOption(
                                                        onPressed: () {
                                                          productController
                                                                  .supplierName
                                                                  .value =
                                                              results
                                                                  .elementAt(
                                                                      index)
                                                                  .fullName!;
                                                          productController
                                                                  .supplierId
                                                                  .value =
                                                              results
                                                                  .elementAt(
                                                                      index)
                                                                  .id
                                                                  .toString();

                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            "${results.elementAt(index).fullName}"),
                                                      )),
                                            );
                                          }
                                        });
                                  });
                            },
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.grey,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(() {
                                    return Text(
                                        productController.supplierName.value);
                                  }),
                                  const Icon(Icons.arrow_drop_down,
                                      color: Colors.grey)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: TextButton(
                          onPressed: () {
                            _navigateToCreate(context);
                          },
                          child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.2),
                                  borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              child: const Text(
                                "+ Add",
                                style: TextStyle(color: Colors.green),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 10),
              const Text("Description"),
              const SizedBox(height: 5),
              TextFormField(
                controller: productController.descriptionController,
                keyboardType: TextInputType.text,
                minLines: 3,
                maxLines: 6,
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "optional",
                  labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Obx(() {
                return productController.creatingProductLoad.value ||
                        productController.updateProductLoad.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : isSmallScreen(context)
                        ? InkWell(
                            splashColor: Colors.transparent,
                            onTap: () {
                              productController.saveProducts(
                                  productData: productModel);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 3, color: AppColors.mainColor),
                                  borderRadius: BorderRadius.circular(40)),
                              child: Center(
                                  child: majorTitle(
                                      title: page == "create"
                                          ? "Add Product"
                                          : "Update",
                                      color: AppColors.mainColor,
                                      size: 18.0)),
                            ),
                          )
                        : Container(
                            height: 0,
                          );
              })
            ],
          ),
        ),
      ),
    );
  }

  _navigateToCreate(context) {
    if (MediaQuery.of(context).size.width > 600) {
      Get.find<HomeController>().selectedWidget.value = CreateSuppliers(
        page: "createProduct",
      );
    } else {
      Get.to(() => CreateSuppliers(
            page: "createProduct",
          ));
    }
  }
}
