import 'package:flutter/material.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/models/supplier.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/customers/components/customer_table.dart';
import 'package:pointify/screens/customers/create_customers.dart';
import 'package:pointify/screens/home/home_page.dart';
import 'package:pointify/screens/suppliers/create_suppliers.dart';
import 'package:pointify/screens/suppliers/supplier_card.dart';
import 'package:pointify/screens/suppliers/supplier_table.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:get/get.dart';

import '../../controllers/CustomerController.dart';
import '../../controllers/supplierController.dart';
import '../../models/customer_model.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/customer_card.dart';
import '../../widgets/smalltext.dart';

class SuppliersPage extends StatelessWidget {
  SuppliersPage({Key? key}) : super(key: key) {
    supplierController.getSuppliersInShop(
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
      initialIndex: 0,
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
              majorTitle(title: "Supplier", color: Colors.black, size: 16.0),
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
                      CreateSuppliers(
                    page: "suppliersPage",
                  );
                } else {
                  Get.to(() => CreateSuppliers(
                        page: "suppliersPage",
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
                        title: "Add Supplier",
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
              supplierController.getSuppliersInShop(
                  shopController.currentShop.value?.id,
                  value == 0 ? "all" : "debtors");
            },
            tabs: const [
              Tab(text: "All"),
              Tab(text: "Debtors"),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [Suppliers(), Suppliers()],
        ),
      ),
    );
  }
}

class Suppliers extends StatelessWidget {
  Suppliers({Key? key}) : super(key: key);
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
          return supplierController.getsupplierLoad.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : supplierController.suppliers.isEmpty
                  ? noItemsFound(context, true)
                  : MediaQuery.of(context).size.width > 600
                      ? supplierController.suppliers.isEmpty
                          ? noItemsFound(context, true)
                          : supplierTable(
                              customers: supplierController.suppliers,
                              context: context)
                      : ListView.builder(
                          itemCount: supplierController.suppliers.length,
                          itemBuilder: (context, index) {
                            SupplierModel supplierModel =
                                supplierController.suppliers.elementAt(index);
                            return supplierCard(
                                supplierModel: supplierModel, context: context);
                          });
        }),
      ),
    );
  }
}
