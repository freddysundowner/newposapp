import 'package:flutter/material.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/customers/components/customer_table.dart';
import 'package:pointify/screens/customers/create_customers.dart';
import 'package:pointify/screens/home/home_page.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:get/get.dart';

import '../../controllers/CustomerController.dart';
import '../../controllers/supplierController.dart';
import '../../models/customer_model.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/customer_card.dart';
import '../../widgets/smalltext.dart';

class CustomersPage extends StatelessWidget {
  CustomersPage({Key? key}) : super(key: key) {
    customersController.getCustomersInShop(
        shopController.currentShop.value?.id, "all");
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
          leading: Get.find<AuthController>().usertype.value == "attendant" &&
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
              majorTitle(title: "Customer", color: Colors.black, size: 16.0),
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
                  );
                } else {
                  Get.to(() => CreateCustomer(
                        page: "customersPage",
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
                        title: "Add Customer",
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
              customersController.getCustomersInShop(
                  shopController.currentShop.value?.id,
                  value == 0 ? "all" : "debtors");
            },
            tabs: [
              Tab(text: "All"),
              Tab(text: "Debtors"),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [Customers(), Customers()],
        ),
      ),
    );
  }
}

class Customers extends StatelessWidget {
  Customers({Key? key}) : super(key: key);
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
          return customersController.gettingCustomersLoad.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : MediaQuery.of(context).size.width > 600
                  ? customersController.customers.isEmpty
                      ? noItemsFound(context, true)
                      : customerTable(
                          customers: customersController.customers,
                          context: context)
                  : customersController.customers.isEmpty
                      ? noItemsFound(context, true)
                      : ListView.builder(
                          itemCount: customersController.customers.length,
                          itemBuilder: (context, index) {
                            CustomerModel customerModel =
                                customersController.customers.elementAt(index);
                            return customerWidget(
                                customerModel: customerModel, context: context);
                          });
        }),
      ),
    );
  }
}
