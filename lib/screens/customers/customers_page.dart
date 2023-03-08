import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/responsive/large_screen.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/customers/create_customers.dart';
import 'package:get/get.dart';

import '../../controllers/CustomerController.dart';
import '../../controllers/supplierController.dart';
import '../../models/customer_model.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/customer_card.dart';
import '../../widgets/customer_debt_card.dart';
import '../../widgets/smalltext.dart';

class CustomersPage extends StatelessWidget {
  final type;

  CustomersPage({Key? key, required this.type}) : super(key: key);
  ShopController createShopController = Get.find<ShopController>();
  CustomerController customerController = Get.find<CustomerController>();

  List customesidePages = [
    {"page": "All"},
    {"page": "Debtors"},
  ];

  Widget showPage() {
    switch (customerController.activeItem.value) {
      case "All":
        return AllCustomers(type: type);

      case "Debtors":
        return Debtors(type: type);

      default:
        return AllCustomers(type: type);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
        largeScreen: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            titleSpacing: 0.0,
            elevation: 0.3,
            centerTitle: false,
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
                majorTitle(title: type, color: Colors.black, size: 16.0),
                minorTitle(
                    title: "${createShopController.currentShop.value?.name}",
                    color: Colors.grey)
              ],
            ),
          ),
          body: Obx(() => LargeScreen(
                sideBar: ListView(
                  children: customesidePages
                      .map((e) =>
                          sideMenuItems(title: e["page"], context: context))
                      .toList(),
                ),
                body: showPage(),
              )),
        ),
        smallScreen: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              titleSpacing: 0.0,
              elevation: 0.3,
              centerTitle: false,
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
                  majorTitle(title: type, color: Colors.black, size: 16.0),
                  minorTitle(
                      title: "${createShopController.currentShop.value?.name}",
                      color: Colors.grey)
                ],
              ),
              actions: [
                InkWell(
                  onTap: () {
                    Get.to(CreateCustomer(
                      type: type,
                    ));
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
                onTap: (value) {},
                tabs: [
                  Tab(text: "All"),
                  Tab(text: "Debtors"),
                ],
              ),
            ),
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: [AllCustomers(type: type), Debtors(type: type)],
            ),
          ),
        ));
  }

  Widget sideMenuItems({required title, required context}) {
    return Obx(() => InkWell(
          onTap: () {
            customerController.activeItem.value = title;
          },
          onHover: (value) {},
          child: Container(
            padding: EdgeInsets.only(top: 10, left: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "${title}",
                    style: TextStyle(
                        color: customerController.activeItem.value == title
                            ? AppColors.mainColor
                            : Colors.grey,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}

class AllCustomers extends StatelessWidget {
  final type;

  AllCustomers({Key? key, required this.type}) : super(key: key) {
    if (type == "suppliers") {
      supplierController
          .getSuppliersInShop(shopController.currentShop.value?.id);
    } else {
      customersController
          .getCustomersInShop(shopController.currentShop.value?.id);
    }
  }

  CustomerController customersController = Get.find<CustomerController>();
  ShopController shopController = Get.find<ShopController>();
  SupplierController supplierController = Get.find<SupplierController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        return type == "suppliers"
            ? supplierController.getsupplierLoad.value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : supplierController.suppliers.length == 0
                    ? Center(
                        child: minorTitle(
                            title: "No ${type} in this shop",
                            color: Colors.black),
                      )
                    : MediaQuery.of(context).size.width > 600
                        ? GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    childAspectRatio:
                                        MediaQuery.of(context).size.width *
                                            1.3 /
                                            MediaQuery.of(context).size.height,
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 5,
                                    mainAxisSpacing: 5),
                            itemCount: supplierController.suppliers.length,
                            shrinkWrap: true,
                            itemBuilder: (context, index) {
                              CustomerModel customerModel =
                                  supplierController.suppliers.elementAt(index);
                              return customerWidget(
                                  customerModel: customerModel, type: type);
                            })
                        : ListView.builder(
                            itemCount: supplierController.suppliers.length,
                            itemBuilder: (context, index) {
                              CustomerModel customerModel =
                                  supplierController.suppliers.elementAt(index);
                              return customerWidget(
                                  customerModel: customerModel, type: type);
                            })
            : customersController.gettingCustomersLoad.value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : MediaQuery.of(context).size.width > 600
                    ? GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio:
                                MediaQuery.of(context).size.width *
                                    1.3 /
                                    MediaQuery.of(context).size.height,
                            crossAxisCount: 3,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5),
                        itemCount: customersController.customers.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          CustomerModel customerModel =
                              customersController.customers.elementAt(index);
                          return customerWidget(
                              customerModel: customerModel, type: type);
                        })
                    : customersController.customers.length == 0
                        ? Center(
                            child: minorTitle(
                                title: "No ${type} in this shop",
                                color: Colors.black),
                          )
                        : ListView.builder(
                            itemCount: customersController.customers.length,
                            itemBuilder: (context, index) {
                              CustomerModel customerModel = customersController
                                  .customers
                                  .elementAt(index);
                              return customerWidget(
                                  customerModel: customerModel, type: type);
                            });
      }),
    );
  }
}

class Debtors extends StatelessWidget {
  final type;

  Debtors({Key? key, required this.type}) : super(key: key) {
    if (type == "suppliers") {
      supplierController.getSuppliersOnCredit(
          shopId: shopController.currentShop.value?.id);
    } else {
      customersController
          .getCustomersOnCredit("${shopController.currentShop.value?.id!}");
    }
  }

  CustomerController customersController = Get.find<CustomerController>();
  SupplierController supplierController = Get.find<SupplierController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return type == "suppliers"
          ? supplierController.suppliersOnCreditLoad.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : supplierController.suppliersOnCredit.length == 0
                  ? Center(
                      child: minorTitle(
                          title: "No ${type} On debt", color: Colors.black),
                    )
                  : MediaQuery.of(context).size.width > 600
                      ? GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio: MediaQuery
                                              .of(context)
                                          .size
                                          .width *
                                      1.3 /
                                      MediaQuery.of(context).size.height,
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5),
                          itemCount: supplierController
                              .suppliersOnCredit.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            CustomerModel customerModel = supplierController
                                .suppliersOnCredit
                                .elementAt(index);
                            return customerWidget(
                                customerModel: customerModel, type: type);
                          })
                      : ListView.builder(
                          itemCount: supplierController
                              .suppliersOnCredit.length,
                          itemBuilder: (context, index) {
                            CustomerModel customerModel = supplierController
                                .suppliersOnCredit
                                .elementAt(index);
                            return customerDebtCard(
                                customerModel: customerModel, type: type);
                          })
          : customersController.customerOnCreditLoad.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : customersController.customersOnCredit.length == 0
                  ? Center(
                      child: minorTitle(
                          title: "No ${type} On debt", color: Colors.black),
                    )
                  : MediaQuery.of(context).size.width > 600
                      ? GridView.builder(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  childAspectRatio:
                                      MediaQuery.of(context).size.width *
                                          1.3 /
                                          MediaQuery.of(context).size.height,
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 5,
                                  mainAxisSpacing: 5),
                          itemCount:
                              customersController.customersOnCredit.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            CustomerModel customerModel = customersController
                                .customersOnCredit
                                .elementAt(index);
                            return customerWidget(
                                customerModel: customerModel, type: type);
                          })
                      : ListView.builder(
                          itemCount:
                              customersController.customersOnCredit.length,
                          itemBuilder: (context, index) {
                            CustomerModel customerModel = customersController
                                .customersOnCredit
                                .elementAt(index);
                            return customerDebtCard(
                                customerModel: customerModel, type: type);
                          });
    });
  }
}
