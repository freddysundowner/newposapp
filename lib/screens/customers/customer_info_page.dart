// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/sales_model.dart';
import 'package:flutterpos/models/sales_order_item_model.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/cash_flow/wallet_page.dart';
import 'package:flutterpos/screens/customers/customers_page.dart';
import 'package:flutterpos/utils/helper.dart';
import 'package:flutterpos/widgets/bigtext.dart';
import 'package:flutterpos/widgets/no_items_found.dart';
import 'package:flutterpos/widgets/smalltext.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/AuthController.dart';
import '../../controllers/CustomerController.dart';
import '../../controllers/attendant_controller.dart';
import '../../controllers/credit_controller.dart';
import '../../controllers/supplierController.dart';
import '../../models/stock_in_credit.dart';
import '../../utils/colors.dart';
import '../../widgets/delete_dialog.dart';
import '../../widgets/edit_dialog.dart';
import '../../widgets/credit_history_card.dart';
import '../../widgets/purchase_card.dart';

class CustomerInfoPage extends StatelessWidget {
  final id;
  final user;
  final name;
  final phone;

  CustomerInfoPage(
      {Key? key,
      required this.id,
      required this.user,
      required this.name,
      required this.phone})
      : super(key: key);
  CustomerController customerController = Get.find<CustomerController>();
  SupplierController supplierController = Get.find<SupplierController>();
  ShopController shopController = Get.find<ShopController>();
  CreditController creditController = Get.find<CreditController>();
  AttendantController attendantController = Get.find<AttendantController>();
  ShopController createShopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();

  launchWhatsApp({required number, required message}) async {
    // String url = "whatsapp://send?phone=+254${number}&text=$message";
    // await canLaunch(url)
    //     ? launch(url)
    //     : showSnackBar(
    //         message: "Cannot open whatsapp", color: Colors.red, context: null);
  }

  launchMessage({required number, required message}) async {
    // Uri sms = Uri.parse('sms:$number?body=$message');
    // if (await launchUrl(sms)) {
    //   //app opened
    // } else {
    //   //app is not opened
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (user == "suppliers") {
      supplierController.getSupplierById(id);
    } else {
      customerController.getCustomerById(id);
    }

    return WillPopScope(
      onWillPop: () async {
        customerController.initialPage.value = 0;
        return true;
      },
      child: ResponsiveWidget(
        largeScreen: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.white,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // majorTitle(title: name, color: Colors.black, size: 18),
                    minorTitle(title: phone, color: Colors.grey)
                  ],
                ),
                if (user != "suppliers")
                  InkWell(
                    onTap: () {
                      Get.find<HomeController>().selectedWidget.value =
                          WalletPage(
                        title: name,
                        uid: "${customerController.customer.value?.id}",
                        phone: phone,
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.only(
                          top: 5, bottom: 5, left: 10, right: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white.withOpacity(0.2)),
                      child: Row(
                        children: [
                          Icon(Icons.credit_card, color: Colors.black),
                          SizedBox(width: 10),
                          Text(
                            "Wallet",
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                  )
              ],
            ),
            leading: IconButton(
                onPressed: () {
                  Get.find<HomeController>().selectedWidget.value =
                      CustomersPage(
                    type: user,
                  );
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
            actions: [
              IconButton(
                  onPressed: () {
                    if (user == "suppliers") {
                      supplierController.assignTextFields();
                    } else {
                      customerController.assignTextFields();
                    }
                    showEditDialog(
                      user: user,
                      context: context,
                    );
                  },
                  icon: Icon(
                    Icons.edit,
                    color: Colors.black,
                  )),
              IconButton(
                  onPressed: () {
                    deleteDialog(
                        context: context,
                        onPressed: () {
                          if (user == "suppliers") {
                            supplierController.deleteSuppler(
                                context: context,
                                id: customerController.customer.value?.id,
                                shopId: shopController.currentShop.value?.id);
                          } else {
                            customerController.deleteCustomer(
                                context: context,
                                id: customerController.customer.value?.id,
                                shopId: shopController.currentShop.value?.id);
                          }
                        });
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                  )),
            ],
          ),
          body: customerInfoBody(context),
        ),
        smallScreen: Helper(
            widget: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    color: AppColors.mainColor,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        Center(
                          child: Container(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                                border:
                                    Border.all(color: Colors.white, width: 2)),
                            child: Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 50,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Obx(() {
                            return Text(
                              supplierController.supplier.value == null ||
                                      customerController.customer.value == null
                                  ? name
                                  : user == "suppliers"
                                      ? "${supplierController.supplier.value == null ? "" : supplierController.supplier.value?.fullName}"
                                      : "${customerController.customer.value == null ? "" : customerController.customer.value?.fullName}",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            );
                          }),
                        ),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.phone,
                              color: Colors.white,
                              size: 14,
                            ),
                            Obx(() {
                              return Text(
                                supplierController.supplier.value == null ||
                                        customerController.customer.value ==
                                            null
                                    ? phone
                                    : user == "suppliers"
                                        ? "${supplierController.supplier.value?.phoneNumber}"
                                        : "${customerController.customer.value?.phoneNumber}",
                                style: TextStyle(color: Colors.white),
                              );
                            }),
                          ],
                        ),
                        SizedBox(height: 10),
                        Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    launchMessage(
                                        number: user == "suppliers"
                                            ? "${supplierController.supplier.value?.phoneNumber}"
                                            : "${customerController.customer.value?.phoneNumber}",
                                        message: user == "suppliers"
                                            ? "we will be paying your debt very soon"
                                            : "Aquick reminde that you owe our shop please pay your debt ");
                                  },
                                  icon: Icon(Icons.message),
                                  color: Colors.white),
                              IconButton(
                                  onPressed: () {
                                    launchWhatsApp(
                                        number: user == "suppliers"
                                            ? "${supplierController.supplier.value?.phoneNumber}"
                                            : "${customerController.customer.value?.phoneNumber}",
                                        message: user == "suppliers"
                                            ? "we will be paying your debt very soon"
                                            : "Aquick reminde that you owe our shop please pay your debt ");
                                  },
                                  icon: Icon(Icons.whatshot),
                                  color: Colors.white),
                              IconButton(
                                  onPressed: () async {
                                    // await launch(
                                    //     "tel://${user == "suppliers" ? "${supplierController.supplier.value?.phoneNumber}" : "${customerController.customer.value?.phoneNumber}"}");
                                  },
                                  icon: Icon(Icons.phone),
                                  color: Colors.white),
                              if (user != "suppliers")
                                InkWell(
                                  onTap: () {
                                    Get.to(
                                      () => WalletPage(
                                          title: customerController
                                                  .customer.value?.fullName ,
                                          uid: "${customerController.customer.value?.id }",
                                          phone: customerController.customer
                                                  .value?.phoneNumber
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        top: 5, bottom: 5, left: 10, right: 15),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Colors.white.withOpacity(0.2)),
                                    child: Row(
                                      children: [
                                        Icon(Icons.credit_card,
                                            color: Colors.white),
                                        SizedBox(width: 10),
                                        Text(
                                          "Wallet",
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  customerInfoBody(context)
                ],
              ),
            ),
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: AppColors.mainColor,
              leading: IconButton(
                  onPressed: () {
                    customerController.initialPage.value = 0;
                    Get.back();
                  },
                  icon: Icon(Icons.arrow_back_ios)),
              actions: [
                IconButton(
                    onPressed: () {
                      if (user == "suppliers") {
                        supplierController.assignTextFields();
                      } else {
                        customerController.assignTextFields();
                      }
                      showEditDialog(
                        user: user,
                        context: context,
                      );
                    },
                    icon: Icon(Icons.edit)),
                IconButton(
                    onPressed: () {
                      deleteDialog(
                          context: context,
                          onPressed: () {
                            if (user == "suppliers") {
                              supplierController.deleteSuppler(
                                  context: context,
                                  id: customerController.customer.value?.id,
                                  shopId: shopController.currentShop.value?.id);
                            } else {
                              customerController.deleteCustomer(
                                  context: context,
                                  id: customerController.customer.value?.id,
                                  shopId: shopController.currentShop.value?.id);
                            }
                          });
                    },
                    icon: Icon(Icons.delete)),
              ],
            )),
      ),
    );
  }

  Widget customerInfoBody(context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          Container(
            color: Colors.white,
            width: double.infinity,
            height: kToolbarHeight,
            child: Obx(() => DefaultTabController(
                  length: 3,
                  initialIndex: customerController.initialPage.value,
                  child: TabBar(
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.purple,
                      physics: NeverScrollableScrollPhysics(),
                      indicatorColor: Colors.purple,
                      controller: customerController.tabController,
                      indicatorWeight: 3,
                      onTap: (index) {
                        customerController.initialPage.value = index;
                        if (index == 0) {
                          print(index);
                          if (user == "suppliers") {
                            supplierController.getSupplierCredit("${shopController.currentShop.value!.id!}", id);
                          } else {
                            creditController.getCustomerCredit(
                                authController.currentUser.value == null
                                    ? attendantController.attendant.value?.id
                                    : authController.currentUser.value?.id,
                                "${createShopController.currentShop.value!.id!}",
                                id);
                          }
                        }
                        else if (index == 1) {
                          customerController.getCustomerPurchases(id, user);
                        } else {
                          if (user == "suppliers") {
                          } else {
                            customerController.getCustomerReturns(id);
                          }
                        }
                      },
                      tabs: customerController.tabs),
                )),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: TabBarView(
                controller: customerController.tabController,
                children: [
                  CreditInfo(id: id, user: user),
                  Purchase(id: id, user: user),
                  Returns(id: id, user: user)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  showModalSheet(context) {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 200,
              child: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      color: Colors.grey.withOpacity(0.7),
                      child: Text('Select Download Option')),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Icon(Icons.arrow_downward),
                            SizedBox(
                              width: 10,
                            ),
                            Container(child: Text('Credit History '))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Icon(Icons.cloud_download_outlined),
                            SizedBox(
                              width: 10,
                            ),
                            Container(child: Text('Purchase History'))
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            Icon(Icons.clear),
                            SizedBox(
                              width: 10,
                            ),
                            Container(
                                child: Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            ))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )));
        });
  }
}

class Purchase extends StatelessWidget {
  final id;
  final user;

  Purchase({Key? key, required this.id, required this.user}) : super(key: key);

  CustomerController customerController = Get.find<CustomerController>();
  SupplierController supplierController = Get.find<SupplierController>();
  ShopController createShopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return customerController.customerPurchaseLoad.value
          ? Center(child: CircularProgressIndicator())
          : customerController.customerPurchases.length == 0
              ? noItemsFound(context, true)
              : MediaQuery.of(context).size.width > 600
                  ? SingleChildScrollView(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        width: double.infinity,
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.grey),
                          child: DataTable(
                            decoration: BoxDecoration(
                                border: Border.all(
                              width: 1,
                              color: Colors.black,
                            )),
                            columnSpacing: 30.0,
                            columns: [
                              DataColumn(
                                  label: Text('Name',
                                      textAlign: TextAlign.center)),
                              DataColumn(
                                  label:
                                      Text('Qty', textAlign: TextAlign.center)),
                              DataColumn(
                                  label: Text('Total',
                                      textAlign: TextAlign.center)),
                              DataColumn(
                                  label: Text('Date',
                                      textAlign: TextAlign.center)),
                            ],
                            rows: List.generate(
                                customerController.customerPurchases.length,
                                (index) {
                              SaleOrderItemModel saleOrder = customerController
                                  .customerPurchases
                                  .elementAt(index);
                              final y = saleOrder.product!.name;
                              final x = saleOrder.itemCount;
                              final z = saleOrder.total;
                              final a = saleOrder.createdAt!;

                              return DataRow(cells: [
                                DataCell(Container(child: Text(y!))),
                                DataCell(Container(child: Text(x.toString()))),
                                DataCell(Container(child: Text(z.toString()))),
                                DataCell(Container(
                                    child: Text(
                                        DateFormat("dd-MM-yyyy").format(a)))),
                              ]);
                            }),
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: customerController.customerPurchases.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        SaleOrderItemModel saleOrder = customerController
                            .customerPurchases
                            .elementAt(index);
                        return purchaseCard(
                            context: context, saleOrderItemModel: saleOrder);
                      });
    });
  }
}

class Returns extends StatelessWidget {
  CustomerController customerController = Get.find<CustomerController>();
  SupplierController supplierController = Get.find<SupplierController>();

  final id;
  final user;

  Returns({Key? key, required this.id, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return customerController.customerReturnsLoad.value
          ? Center(child: CircularProgressIndicator())
          : customerController.customerReturns.length == 0
              ? noItemsFound(context, true)
              : MediaQuery.of(context).size.width > 600
                  ? SingleChildScrollView(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        width: double.infinity,
                        child: Theme(
                          data: Theme.of(context)
                              .copyWith(dividerColor: Colors.grey),
                          child: DataTable(
                            decoration: BoxDecoration(
                                border: Border.all(
                              width: 1,
                              color: Colors.black,
                            )),
                            columnSpacing: 30.0,
                            columns: [
                              DataColumn(
                                  label: Text('Name',
                                      textAlign: TextAlign.center)),
                              DataColumn(
                                  label:
                                      Text('Qty', textAlign: TextAlign.center)),
                              DataColumn(
                                  label: Text('Total',
                                      textAlign: TextAlign.center)),
                              DataColumn(
                                  label: Text('Date',
                                      textAlign: TextAlign.center)),
                            ],
                            rows: List.generate(
                                customerController.customerReturns.length,
                                (index) {
                              SaleOrderItemModel saleOrder = customerController
                                  .customerReturns
                                  .elementAt(index);
                              final y = saleOrder.product!.name;
                              final x = saleOrder.itemCount;
                              final z = saleOrder.total;
                              final a = saleOrder.createdAt!;

                              return DataRow(cells: [
                                DataCell(Container(child: Text(y!))),
                                DataCell(Container(child: Text(x.toString()))),
                                DataCell(Container(child: Text(z.toString()))),
                                DataCell(Container(
                                    child: Text(
                                        DateFormat("dd-MM-yyyy").format(a)))),
                              ]);
                            }),
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: customerController.customerReturns.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        SaleOrderItemModel saleOrderItemModel =
                            customerController.customerReturns.elementAt(index);
                        return purchaseCard(
                            context: context,
                            saleOrderItemModel: saleOrderItemModel);
                      });
    });
  }
}

class CreditInfo extends StatelessWidget {
  final id;
  final user;
  CreditController creditController = Get.find<CreditController>();
  SupplierController supplierController = Get.find<SupplierController>();
  CustomerController customerController = Get.find<CustomerController>();
  AttendantController attendantController = Get.find<AttendantController>();
  ShopController createShopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();

  CreditInfo({Key? key, required this.id, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return user == "suppliers"
          ? supplierController.stockInCredit.length == 0
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "No entries found.",
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    Center(
                      child: Text(
                        "For now",
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ))
              : ListView.builder(
                  itemCount: supplierController.stockInCredit.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    StockInCredit salesBody =
                        supplierController.stockInCredit.elementAt(index);

                    return Container();
                  })
          : creditController.getCreditLoad.value
              ? Center(child: CircularProgressIndicator())
              : creditController.credit.length == 0
                  ? Center(
                      child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            "No entries found.",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        Center(
                          child: Text(
                            "For now",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ))
                  : ListView.builder(
                      itemCount: creditController.credit.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        SalesModel salesBody =
                            creditController.credit.elementAt(index);

                        return CreditHistoryCard(context, salesBody);
                      });
    });
  }
}
