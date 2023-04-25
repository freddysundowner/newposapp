import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/customers/customers_page.dart';
import 'package:flutterpos/screens/product/create_product.dart';
import 'package:flutterpos/screens/sales/create_sale.dart';
import 'package:flutterpos/screens/stock/create_purchase.dart';
import 'package:get/get.dart';

import '../../../../utils/colors.dart';
import '../../controllers/CustomerController.dart';
import '../../controllers/shop_controller.dart';
import '../../controllers/supplierController.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';

class CreateCustomer extends StatelessWidget {
  final type;
  final page;

  CreateCustomer({Key? key, required this.type, required this.page})
      : super(key: key);

  CustomerController customersController = Get.find<CustomerController>();
  SupplierController supplierController = Get.find<SupplierController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.96),
      appBar: AppBar(
          elevation: 0.3,
          titleSpacing: 0.0,
          centerTitle: false,
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              if (MediaQuery.of(context).size.width > 600) {
                if (page == "customersPage") {
                  Get.find<HomeController>().selectedWidget.value =
                      CustomersPage(type: type);
                }
                if (page == "createSale") {
                  Get.find<HomeController>().selectedWidget.value =
                      CreateSale();
                }
                if (page == "createProduct") {
                  Get.find<HomeController>().selectedWidget.value =
                      CreateProduct(
                    page: "create",
                    productModel: ProductModel(),
                  );
                }
                if (page == "createPurchase") {
                  Get.find<HomeController>().selectedWidget.value =
                      CreatePurchase();
                }
              } else {
                Get.back();
              }
            },
            icon: Icon(Icons.arrow_back_ios, color: Colors.black),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              majorTitle(
                  title: "${type} Details", color: Colors.black, size: 16.0),
              minorTitle(
                  title: shopController.currentShop.value?.name,
                  color: Colors.grey),
            ],
          )),
      body: ResponsiveWidget(
          largeScreen: Align(
              alignment: Alignment.center,
              child: Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: customerInfoCard(context))),
          smallScreen: SingleChildScrollView(
            child: customerInfoCard(context),
          )),
    );
  }

  Widget customerInfoCard(context) {
    return Card(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20),
                Text("${type} Name".capitalize!),
                SizedBox(height: 10),
                TextFormField(
                  controller: type == "supplier"
                      ? supplierController.nameController
                      : customersController.nameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      isDense: true,
                      hintStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                      hintText: "eg.John Doe",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      filled: true,
                      fillColor: Colors.white),
                )
              ],
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Phone"),
                SizedBox(height: 10),
                TextFormField(
                    controller: type == "supplier"
                        ? supplierController.phoneController
                        : customersController.phoneController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      isDense: true,
                      hintStyle: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                      hintText: "eg.07XXXXXXXX",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey, width: 1),
                      ),
                    ))
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.10),
            InkWell(
              splashColor: Colors.transparent,
              hoverColor: Colors.transparent,
              onTap: () {
                if (type == "supplier") {
                  supplierController.createSupplier(
                      shopId: shopController.currentShop.value?.id,
                      context: context,page:page);
                } else {
                  customersController.createCustomer(
                      shopId: shopController.currentShop.value?.id,
                      context: context,page:page);
                }
              },
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: MediaQuery.of(context).size.width * 0.25,
                  decoration: BoxDecoration(
                      border: Border.all(width: 3, color: AppColors.mainColor),
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                      child: majorTitle(
                          title: "Save",
                          color: AppColors.mainColor,
                          size: 18.0)),
                ),
              ),
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
