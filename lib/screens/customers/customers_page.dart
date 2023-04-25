import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/customers/components/customer_table.dart';
import 'package:flutterpos/screens/customers/create_customers.dart';
import 'package:flutterpos/screens/home/home_page.dart';
import 'package:flutterpos/widgets/no_items_found.dart';
import 'package:get/get.dart';

import '../../controllers/CustomerController.dart';
import '../../controllers/supplierController.dart';
import '../../models/customer_model.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/customer_card.dart';
import '../../widgets/smalltext.dart';

class CustomersPage extends StatelessWidget {
  final type;

  CustomersPage({Key? key, required this.type}) : super(key: key) {
    if (type == "supplier") {
      supplierController.getSuppliersInShop(
          shopController.currentShop.value?.id, "all");
    } else {
      customersController.getCustomersInShop(
          shopController.currentShop.value?.id, "all");
    }
  }

  ShopController createShopController = Get.find<ShopController>();
  CustomerController customerController = Get.find<CustomerController>();
  CustomerController customersController = Get.find<CustomerController>();
  ShopController shopController = Get.find<ShopController>();
  SupplierController supplierController = Get.find<SupplierController>();

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
        largeScreen: defaultTab("large", context),
        smallScreen: defaultTab("small", context));
  }

  Widget defaultTab(types, context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleSpacing: 0.0,
          elevation: 0.3,
          centerTitle: false,
          leading: Get.find<AuthController>().usertype == "attendant" &&
                  MediaQuery.of(context).size.width > 600
              ? Container()
              : IconButton(
                  onPressed: () {
                    if (types == "large") {
                      Get.find<HomeController>().selectedWidget.value =
                          HomePage();
                    } else {
                      Get.back();
                    }
                  },
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              majorTitle(title: type, color: Colors.black, size: 16.0),
              minorTitle(
                  title: "${createShopController.currentShop.value?.name}",
                  color: Colors.grey)
            ],
          ),
          actions: [
            InkWell(
              onTap: () {
                if (types == "large") {
                  Get.find<HomeController>().selectedWidget.value =
                      CreateCustomer(
                    page: "customersPage",
                    type: type,
                  );
                } else {
                  Get.to(() => CreateCustomer(
                        page: "customersPage",
                        type: type,
                      ));
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Container(
                  padding: EdgeInsets.fromLTRB(5, 2, 5, 2),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: (BorderRadius.circular(10)),
                      border: Border.all(color: AppColors.mainColor, width: 1)),
                  child: Center(
                    child: majorTitle(
                        title: "Add ${type}",
                        color: AppColors.mainColor,
                        size: 12.0),
                  ),
                ),
              ),
            )
          ],
          bottom: TabBar(
            indicatorColor: AppColors.mainColor,
            labelColor: AppColors.mainColor,
            unselectedLabelColor: Colors.grey,
            onTap: (value) {
              if (type == "supplier") {
                supplierController.getSuppliersInShop(
                    shopController.currentShop.value?.id,
                    value == 0 ? "all" : "debtors");
              } else {
                customersController.getCustomersInShop(
                    shopController.currentShop.value?.id,
                    value == 0 ? "all" : "debtors");
              }
            },
            tabs: [
              Tab(text: "All"),
              Tab(text: "Debtors"),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Customers(
              type: type,
            ),
            Customers(type: type)
          ],
        ),
      ),
    );
  }
}

class Customers extends StatelessWidget {
  final type;

  Customers({Key? key, required this.type}) : super(key: key);
  CustomerController customersController = Get.find<CustomerController>();
  ShopController shopController = Get.find<ShopController>();
  SupplierController supplierController = Get.find<SupplierController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.only(top: 5),
        child: Obx(() {
          return type == "supplier"
              ? supplierController.getsupplierLoad.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : supplierController.suppliers.length == 0
                      ? noItemsFound(context, true)
                      : MediaQuery.of(context).size.width > 600
                          ? supplierController.suppliers.length == 0
                              ? noItemsFound(context, true)
                              : customerTable(
                                  customers: supplierController.suppliers,
                                  context: context,
                                  type: type)
                          : ListView.builder(
                              itemCount: supplierController.suppliers.length,
                              itemBuilder: (context, index) {
                                CustomerModel customerModel = supplierController
                                    .suppliers
                                    .elementAt(index);
                                return customerWidget(
                                    customerModel: customerModel,
                                    type: type,
                                    context: context);
                              })
              : customersController.gettingCustomersLoad.value
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : MediaQuery.of(context).size.width > 600
                      ? customersController.customers.length == 0
                          ? noItemsFound(context, true)
                          : customerTable(
                              customers: customersController.customers,
                              context: context,
                              type: type)
                      : customersController.customers.length == 0
                          ? noItemsFound(context, true)
                          : ListView.builder(
                              itemCount: customersController.customers.length,
                              itemBuilder: (context, index) {
                                CustomerModel customerModel =
                                    customersController.customers
                                        .elementAt(index);
                                return customerWidget(
                                    customerModel: customerModel,
                                    type: type,
                                    context: context);
                              });
        }),
      ),
    );
  }
}
