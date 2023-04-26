// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/purchase_controller.dart';
import 'package:flutterpos/controllers/sales_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/customer_model.dart';
import 'package:flutterpos/models/sales_model.dart';
import 'package:flutterpos/models/sales_order_item_model.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/cash_flow/wallet_page.dart';
import 'package:flutterpos/screens/customers/customers_page.dart';
import 'package:flutterpos/utils/helper.dart';
import 'package:flutterpos/widgets/no_items_found.dart';
import 'package:flutterpos/widgets/smalltext.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/AuthController.dart';
import '../../controllers/CustomerController.dart';
import '../../controllers/attendant_controller.dart';
import '../../controllers/supplierController.dart';
import '../../models/purchase_order.dart';
import '../../models/stock_in_credit.dart';
import '../../models/supply_order_model.dart';
import '../../utils/colors.dart';
import '../../widgets/creditPurchaseCard.dart';
import '../../widgets/credit_history_card.dart';
import '../../widgets/delete_dialog.dart';
import '../../widgets/edit_dialog.dart';
import '../../widgets/purchase_card.dart';
import '../cash_flow/payment_history.dart';
import '../stock/purchase_order_item.dart';

class CustomerInfoPage extends StatelessWidget {
  final user;
  final CustomerModel customerModel;

  CustomerInfoPage({Key? key, required this.user, required this.customerModel})
      : super(key: key) {
    customerController.initialPage.value = 0;
    if (user == "supplier") {
      Get.find<PurchaseController>().getPurchase(
          shopId: createShopController.currentShop.value!.id,
          onCredit: "true",
          attendantId: authController.usertype == "admin"
              ? ""
              : attendantController.attendant.value!.id,
          customer: customerModel.id);
    } else {
      Get.find<SalesController>().getSalesByShop(
          id: shopController.currentShop.value?.id,
          attendantId: authController.usertype == "admin"
              ? ""
              : attendantController.attendant.value!.id,
          onCredit: true,
          customer: customerModel.id,
          startingDate: "");
    }
  }

  CustomerController customerController = Get.find<CustomerController>();
  SupplierController supplierController = Get.find<SupplierController>();
  ShopController shopController = Get.find<ShopController>();
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
    return ResponsiveWidget(
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
                  minorTitle(
                      title: customerModel.fullName,
                      color: Colors.black,
                      size: 18)
                ],
              ),
              if (user != "supplier")
                InkWell(
                  onTap: () {
                    Get.find<HomeController>().selectedWidget.value =
                        WalletPage(
                      customerModel: customerModel,
                    );
                  },
                  child: Container(
                    padding:
                        EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 15),
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
                Get.find<HomeController>().selectedWidget.value = CustomersPage(
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
                  if (user == "supplier") {
                    supplierController.assignTextFields(customerModel);
                  } else {
                    customerController.assignTextFields(customerModel);
                  }
                  showEditDialog(
                      user: user,
                      context: context,
                      customerModel: customerModel);
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
                        if (user == "supplier") {
                          supplierController.deleteSuppler(
                              context: context,
                              id: customerModel.id,
                              shopId: shopController.currentShop.value?.id);
                        } else {
                          customerController.deleteCustomer(
                              context: context,
                              id: customerModel.id,
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
                          child: Text(
                        customerModel.fullName!,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      )),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.phone,
                            color: Colors.white,
                            size: 14,
                          ),
                          Text(
                            customerModel.phoneNumber!,
                            style: TextStyle(color: Colors.white),
                          )
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
                                      number: customerModel.phoneNumber,
                                      message: user == "supplier"
                                          ? "we will be paying your debt very soon"
                                          : "Aquick reminde that you owe our shop please pay your debt ");
                                },
                                icon: Icon(Icons.message),
                                color: Colors.white),
                            IconButton(
                                onPressed: () {
                                  launchWhatsApp(
                                      number: customerModel.phoneNumber,
                                      message: user == "supplier"
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
                            if (user != "supplier")
                              InkWell(
                                onTap: () {
                                  Get.to(
                                    () => WalletPage(
                                      customerModel: customerModel,
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
                    if (user == "supplier") {
                      supplierController.assignTextFields(customerModel);
                    } else {
                      customerController.assignTextFields(customerModel);
                    }
                    showEditDialog(
                        user: user,
                        context: context,
                        customerModel: customerModel);
                  },
                  icon: Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    deleteDialog(
                        context: context,
                        onPressed: () {
                          if (user == "supplier") {
                            supplierController.deleteSuppler(
                                context: context,
                                id: customerModel.id,
                                shopId: shopController.currentShop.value?.id);
                          } else {
                            customerController.deleteCustomer(
                                context: context,
                                id: customerModel.id,
                                shopId: shopController.currentShop.value?.id);
                          }
                        });
                  },
                  icon: Icon(Icons.delete)),
            ],
          )),
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
                  length: customerController.tabs.length,
                  initialIndex: customerController.initialPage.value,
                  child: TabBar(
                      controller: customerController.tabController,
                      unselectedLabelColor: Colors.grey,
                      labelColor: Colors.purple,
                      physics: NeverScrollableScrollPhysics(),
                      indicatorColor: Colors.purple,
                      indicatorWeight: 3,
                      onTap: (index) {
                        customerController.initialPage.value = index;
                        if (index == 0) {
                          if (user == "supplier") {
                            Get.find<PurchaseController>().getPurchase(
                                shopId:
                                    createShopController.currentShop.value!.id,
                                onCredit: "true",
                                attendantId: authController.usertype == "admin"
                                    ? ""
                                    : attendantController.attendant.value!.id,
                                customer: customerModel.id);
                          } else {
                            Get.find<SalesController>().getSalesByShop(
                                id: shopController.currentShop.value?.id,
                                attendantId: authController.usertype == "admin"
                                    ? ""
                                    : attendantController.attendant.value!.id,
                                onCredit: true,
                                customer: customerModel.id,
                                startingDate: "");
                          }
                        } else if (index == 1) {
                          if (user == "supplier") {
                            supplierController.getSupplierSupplies(
                                returned: "",
                                attendantId: authController.usertype == "admin"
                                    ? ""
                                    : attendantController.attendant.value!.id,
                                supplierId: customerModel.id);
                          } else {
                            customerController.getCustomerPurchases(
                                uid: customerModel.id,
                                type: user,
                                operation: "purchases",
                                attendantId: authController.usertype == "admin"
                                    ? ""
                                    : attendantController.attendant.value!.id);
                          }
                        } else {
                          if (user == "supplier") {
                            supplierController.getSupplierSupplies(
                                returned: "true",
                                attendantId: authController.usertype == "admin"
                                    ? ""
                                    : attendantController.attendant.value!.id,
                                supplierId: customerModel.id);
                          } else {
                            customerController.getCustomerPurchases(
                                uid: customerModel.id,
                                type: user,
                                operation: "returns",
                                attendantId: authController.usertype == "admin"
                                    ? ""
                                    : attendantController.attendant.value!.id);
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
                physics: NeverScrollableScrollPhysics(),
                controller: customerController.tabController,
                children: [
                  CreditInfo(customerModel: customerModel, user: user),
                  Purchase(id: customerModel.id, user: user),
                  Purchase(id: customerModel.id, user: user)
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
    print(user);
    return Obx(() {
      return customerController.customerPurchaseLoad.value ||
              supplierController.gettingSupplierSuppliesLoad.value
          ? Center(child: CircularProgressIndicator())
          : customerController.customerPurchases.length == 0 &&
                      user != "supplier" ||
                  supplierController.supplierSupplies.isEmpty &&
                      user == "supplier"
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
                  : user == "supplier"
                      ? ListView.builder(
                          itemCount: supplierController.supplierSupplies.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            SupplyOrderModel supplyOrderModel =
                                supplierController.supplierSupplies
                                    .elementAt(index);
                            return purchaseCard(
                                context: context,
                                supplyOrderModel: supplyOrderModel);
                          })
                      : ListView.builder(
                          itemCount:
                              customerController.customerPurchases.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            SaleOrderItemModel saleOrder = customerController
                                .customerPurchases
                                .elementAt(index);

                            return purchaseCard(
                              context: context,
                              saleOrderItemModel: saleOrder,
                            );
                          });
    });
  }
}

class CreditInfo extends StatelessWidget {
  final CustomerModel customerModel;
  final user;
  SupplierController supplierController = Get.find<SupplierController>();
  CustomerController customerController = Get.find<CustomerController>();
  AttendantController attendantController = Get.find<AttendantController>();
  ShopController createShopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();
  SalesController salesController = Get.find<SalesController>();
  PurchaseController purchaseController = Get.find<PurchaseController>();

  CreditInfo({Key? key, required this.customerModel, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return user == "supplier"
          ? purchaseController.getPurchaseLoad.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : purchaseController.purchasedItems.length == 0
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
                  : MediaQuery.of(context).size.width > 600
                      ? SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
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
                                      label: Text('Receipt Number',
                                          textAlign: TextAlign.center)),
                                  DataColumn(
                                      label: Text('Balance',
                                          textAlign: TextAlign.center)),
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
                                  StockInCredit salesBody = supplierController
                                      .stockInCredit
                                      .elementAt(index);
                                  final y = salesBody.recietNumber;
                                  final x = salesBody.balance;
                                  final z = salesBody.total;
                                  final a = salesBody.createdAt!;

                                  return DataRow(cells: [
                                    DataCell(Container(child: Text(y!))),
                                    DataCell(
                                        Container(child: Text(x.toString()))),
                                    DataCell(
                                        Container(child: Text(z.toString()))),
                                    DataCell(Container(
                                        child: Text(DateFormat("dd-MM-yyyy")
                                            .format(a)))),
                                  ]);
                                }),
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: purchaseController.purchasedItems.length,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            PurchaseOrder salesBody = purchaseController
                                .purchasedItems
                                .elementAt(index);

                            return CreditPurchaseHistoryCard(
                                context, salesBody);
                          })
          : salesController.salesByShopLoad.value
              ? Center(child: CircularProgressIndicator())
              : salesController.sales.length == 0
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
                  : MediaQuery.of(context).size.width > 600
                      ? SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
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
                                      label: Text('Receipt Number',
                                          textAlign: TextAlign.center)),
                                  DataColumn(
                                      label: Text('Balance',
                                          textAlign: TextAlign.center)),
                                  DataColumn(
                                      label: Text('Total',
                                          textAlign: TextAlign.center)),
                                  DataColumn(
                                      label: Text('Date',
                                          textAlign: TextAlign.center)),
                                  DataColumn(
                                      label: Text('',
                                          textAlign: TextAlign.center)),
                                ],
                                rows: List.generate(
                                    salesController.sales.length, (index) {
                                  SalesModel salesBody =
                                      salesController.sales.elementAt(index);
                                  final y = salesBody.receiptNumber;
                                  final x = salesBody.creditTotal;
                                  final z = salesBody.grandTotal;
                                  final a = salesBody.createdAt!;

                                  return DataRow(cells: [
                                    DataCell(Container(child: Text(y!))),
                                    DataCell(
                                        Container(child: Text(x.toString()))),
                                    DataCell(
                                        Container(child: Text(z.toString()))),
                                    DataCell(Container(
                                        child: Text(DateFormat("dd-MM-yyyy")
                                            .format(a)))),
                                    DataCell(Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        child: PopupMenuButton(
                                          itemBuilder: (ctx) => [
                                            PopupMenuItem(
                                              child: ListTile(
                                                leading: Icon(Icons.list),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  if (MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      600) {
                                                    Get.find<HomeController>()
                                                            .selectedWidget
                                                            .value =
                                                        PurchaseOrderItems(
                                                            id: salesBody.id);
                                                  } else {
                                                    Get.to(() =>
                                                        PurchaseOrderItems(
                                                            id: salesBody.id));
                                                  }
                                                },
                                                title: Text('View Purchases'),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              child: ListTile(
                                                leading: Icon(Icons.payment),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                title: Text('Pay'),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              child: ListTile(
                                                leading: Icon(Icons.wallet),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  if (MediaQuery.of(context)
                                                          .size
                                                          .width >
                                                      600) {
                                                    Get.find<HomeController>()
                                                        .selectedWidget
                                                        .value = PaymentHistory(
                                                      id: salesBody.id!,
                                                    );
                                                  } else {
                                                    Get.to(() => PaymentHistory(
                                                          id: salesBody.id!,
                                                        ));
                                                  }
                                                },
                                                title: Text('Payment History'),
                                              ),
                                            ),
                                            PopupMenuItem(
                                              child: ListTile(
                                                leading: Icon(
                                                    Icons.file_copy_outlined),
                                                onTap: () async {
                                                  Navigator.pop(context);
                                                },
                                                title: Text('Generate Report'),
                                              ),
                                            ),
                                          ],
                                          icon: Icon(Icons.more_vert),
                                        ),
                                      ),
                                    )),
                                  ]);
                                }),
                              ),
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: salesController.sales.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            SalesModel salesBody =
                                salesController.sales.elementAt(index);

                            return CreditHistoryCard(
                                context, salesBody, customerModel);
                          });
    });
  }
}
