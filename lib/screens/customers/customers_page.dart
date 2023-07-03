import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/customers/components/customer_table.dart';
import 'package:pointify/screens/customers/create_customers.dart';
import 'package:pointify/screens/home/home_page.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:get/get.dart';

import '../../Real/schema.dart';
import '../../controllers/CustomerController.dart';
import '../../controllers/supplierController.dart';
import '../../controllers/user_controller.dart';
import '../../functions/functions.dart';
import '../../services/customer.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/customer_card.dart';
import '../../widgets/smalltext.dart';

class CustomersPage extends StatelessWidget {
  CustomersPage({Key? key}) : super(key: key) {
    customersController.getCustomersInShop("all");
  }

  ShopController createShopController = Get.find<ShopController>();
  CustomerController customerController = Get.find<CustomerController>();
  CustomerController customersController = Get.find<CustomerController>();
  ShopController shopController = Get.find<ShopController>();
  SupplierController supplierController = Get.find<SupplierController>();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleSpacing: 0.0,
          elevation: 0.3,
          centerTitle: false,
          leading:
              Get.find<UserController>().user.value?.usertype == "attendant" &&
                      !isSmallScreen(context)
                  ? Container()
                  : IconButton(
                      onPressed: () {
                        if (isSmallScreen(context)) {
                          Get.back();
                        } else {
                          Get.find<HomeController>().selectedWidget.value =
                              HomePage();
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
              majorTitle(title: "Customer", color: Colors.black, size: 16.0),
              minorTitle(
                  title: "${createShopController.currentShop.value?.name}",
                  color: Colors.grey)
            ],
          ),
          actions: [
            if (checkPermission(category: "customers", permission: "manage"))
              InkWell(
                onTap: () {
                  if (!isSmallScreen(context)) {
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
                    padding: const EdgeInsets.fromLTRB(5, 2, 5, 2),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: (BorderRadius.circular(10)),
                        border:
                            Border.all(color: AppColors.mainColor, width: 1)),
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
              customersController
                  .getCustomersInShop(value == 0 ? "all" : "debtors");
            },
            tabs: [
              const Tab(text: "All"),
              const Tab(text: "Debtors"),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          children: [
            Customers(
              type: "",
            ),
            Debtors()
          ],
        ),
      ),
    );
  }
}

class Customers extends StatelessWidget {
  String type;

  Customers({Key? key, required this.type}) : super(key: key);
  CustomerController customersController = Get.find<CustomerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Obx(() {
          return customersController.gettingCustomersLoad.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : StreamBuilder(
                  stream: Customer().getCustomersByShopId("all").changes,
                  builder: (context, snapshot) {
                    final data = snapshot.data;
                    if (data == null || data.results.isEmpty) {
                      return Center(
                        child: InkWell(
                          onTap: () {
                            Get.to(() => CreateCustomer(
                                  page: "",
                                ));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Add",
                                style: TextStyle(
                                    color: AppColors.mainColor, fontSize: 21),
                              ),
                              Icon(
                                Icons.add_circle_outline_outlined,
                                size: 60,
                                color: AppColors.mainColor,
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      final results = data.results;
                      return isSmallScreen(context)
                          ? ListView.builder(
                              itemCount:
                                  results.realm.isClosed ? 0 : results.length,
                              itemBuilder: (context, index) {
                                CustomerModel customerModel =
                                    results.elementAt(index);
                                return customerWidget(
                                    customerModel: customerModel,
                                    context: context,
                                    type: type);
                              })
                          : customerTable(
                              customers: results, context: context, type: type);
                    }
                  });
        }),
      ),
    );
  }
}

class Debtors extends StatelessWidget {
  Debtors({Key? key}) : super(key: key);
  CustomerController customersController = Get.find<CustomerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Obx(() {
          return customersController.gettingCustomersLoad.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : StreamBuilder(
                  stream: Customer().getCustomersByShopId("debtors").changes,
                  builder: (context, snapshot) {
                    final data = snapshot.data;
                    if (data == null) {
                      print("object");
                      return minorTitle(
                          title: "This shop doesn't have products yet",
                          color: Colors.black);
                    } else {
                      final results = data.results;
                      return isSmallScreen(context)
                          ? ListView.builder(
                              itemCount:
                                  results.realm.isClosed ? 0 : results.length,
                              itemBuilder: (context, index) {
                                CustomerModel customerModel =
                                    results.elementAt(index);
                                return customerWidget(
                                    customerModel: customerModel,
                                    context: context);
                              })
                          : customerTable(
                              type: "other",
                              customers: results,
                              context: context);
                    }
                  });
        }),
      ),
    );
  }
}
