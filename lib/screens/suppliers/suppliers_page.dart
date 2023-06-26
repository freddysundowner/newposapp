import 'package:flutter/material.dart';
import 'package:pointify/controllers/AuthController.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/home/home_page.dart';
import 'package:pointify/screens/suppliers/create_suppliers.dart';
import 'package:pointify/screens/suppliers/supplier_card.dart';
import 'package:pointify/screens/suppliers/supplier_info_page.dart';
import 'package:pointify/screens/suppliers/supplier_table.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';

import '../../Real/schema.dart';
import '../../controllers/CustomerController.dart';
import '../../controllers/supplierController.dart';
import '../../controllers/user_controller.dart';
import '../../functions/functions.dart';
import '../../services/supplier.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/smalltext.dart';

class SuppliersPage extends StatelessWidget {
  SuppliersPage({Key? key}) : super(key: key) {
    supplierController.getSuppliersInShop("all");
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
          leading:
              Get.find<UserController>().user.value?.usertype == "attendant" &&
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
            if (checkPermission(category: "suppliers", permission: "manage"))
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
                        border:
                            Border.all(color: AppColors.mainColor, width: 1)),
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
              supplierController
                  .getSuppliersInShop(value == 0 ? "all" : "debtors");
            },
            tabs: const [
              Tab(text: "All"),
              Tab(text: "Debtors"),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Suppliers(
              from: "all",
            ),
            Suppliers(
              from: "debtors",
            )
          ],
        ),
      ),
    );
  }
}

class Suppliers extends StatelessWidget {
  Suppliers({Key? key, this.type, this.from}) : super(key: key);
  CustomerController customersController = Get.find<CustomerController>();
  ShopController shopController = Get.find<ShopController>();
  SupplierController supplierController = Get.find<SupplierController>();
  PurchaseController purchaseController = Get.find<PurchaseController>();
  String? type = "";
  String? from = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: StreamBuilder<RealmResultsChanges<Supplier>>(
            stream: SupplierService().getSuppliersByShopId(type: from!).changes,
            builder: (context, AsyncSnapshot snapshot) {
              final data = snapshot.data;
              if (data == null) {
                return noItemsFound(context, true);
              } else {
                final results = data.results;
                return MediaQuery.of(context).size.width > 600
                    ? supplierTable(customers: results, context: context)
                    : ListView.builder(
                        itemCount: results.realm.isClosed ? 0 : results.length,
                        itemBuilder: (context, index) {
                          Supplier supplierModel = results.elementAt(index);
                          return supplierCard(
                              supplierModel: supplierModel,
                              type: type ?? "",
                              function: (Supplier supplier) {
                                if (type == "purchases") {
                                  purchaseController.invoice.value?.supplier =
                                      supplier;
                                  Get.back();
                                } else {
                                  if (MediaQuery.of(Get.context!).size.width >
                                      600) {
                                    Get.find<HomeController>()
                                        .selectedWidget
                                        .value = SupplierInfoPage(
                                      supplierModel: supplierModel,
                                    );
                                  } else {
                                    Get.to(() => SupplierInfoPage(
                                          supplierModel: supplierModel,
                                        ));
                                  }
                                }
                              });
                        });
              }
            }),
      ),
    );
  }
}
