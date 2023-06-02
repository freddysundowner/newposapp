import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/customers/components/customer_table.dart';
import 'package:pointify/screens/customers/create_customers.dart';
import 'package:pointify/screens/home/home_page.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:get/get.dart';

import '../../Real/Models/schema.dart';
import '../../controllers/CustomerController.dart';
import '../../controllers/supplierController.dart';
import '../../controllers/user_controller.dart';
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
              customersController
                  .getCustomersInShop(value == 0 ? "all" : "debtors");
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
                  : StreamBuilder(
                      stream: Customer().getCustomersByShopId("all").changes,
                      builder: (context, snapshot) {
                        final data = snapshot.data;
                        if (data == null) {
                          return minorTitle(
                              title: "This shop doesn't have products yet",
                              color: Colors.black);
                        } else {
                          final results = data.results;
                          return ListView.builder(
                              itemCount:
                                  results.realm.isClosed ? 0 : results.length,
                              itemBuilder: (context, index) {
                                CustomerModel customerModel =
                                    results.elementAt(index);
                                return customerWidget(
                                    customerModel: customerModel,
                                    context: context,
                                    type: type);
                              });
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
                  : StreamBuilder(
                      stream:
                          Customer().getCustomersByShopId("debtors").changes,
                      builder: (context, snapshot) {
                        final data = snapshot.data;
                        if (data == null) {
                          return minorTitle(
                              title: "This shop doesn't have products yet",
                              color: Colors.black);
                        } else {
                          final results = data.results;
                          return ListView.builder(
                              itemCount:
                                  results.realm.isClosed ? 0 : results.length,
                              itemBuilder: (context, index) {
                                CustomerModel customerModel =
                                    results.elementAt(index);
                                return customerWidget(
                                    customerModel: customerModel,
                                    context: context);
                              });
                        }
                      });
        }),
      ),
    );
  }
}
