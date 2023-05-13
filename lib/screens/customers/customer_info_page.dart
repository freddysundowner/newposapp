import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/models/customer_model.dart';
import 'package:pointify/models/receipt.dart';
import 'package:pointify/models/sales_return.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/cash_flow/wallet_page.dart';
import 'package:pointify/screens/customers/customers_page.dart';
import 'package:pointify/screens/customers/edit_user.dart';
import 'package:pointify/utils/helper.dart';
import 'package:pointify/widgets/alert.dart';
import 'package:pointify/widgets/sales_card.dart';
import 'package:pointify/widgets/sales_rerurn_card.dart';
import 'package:pointify/widgets/smalltext.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../controllers/AuthController.dart';
import '../../controllers/CustomerController.dart';
import '../../controllers/attendant_controller.dart';
import '../../controllers/supplierController.dart';
import '../../utils/colors.dart';
import '../../widgets/delete_dialog.dart';
import '../../widgets/snackBars.dart';
import '../cash_flow/payment_history.dart';
import '../stock/purchase_order_item.dart';

class CustomerInfoPage extends StatelessWidget {
  final CustomerModel customerModel;

  CustomerInfoPage({Key? key, required this.customerModel}) : super(key: key) {
    customerController.initialPage.value = 0;
    salesController.getSales(
        onCredit: true, customer: customerModel.id, startingDate: "");
  }

  CustomerController customerController = Get.find<CustomerController>();
  SupplierController supplierController = Get.find<SupplierController>();
  ShopController shopController = Get.find<ShopController>();
  AttendantController attendantController = Get.find<AttendantController>();
  ShopController createShopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();
  SalesController salesController = Get.find<SalesController>();

  launchWhatsApp({required number, required message}) async {
    String url = "whatsapp://send?phone=+254${number}&text=$message";
    await canLaunchUrl(Uri.parse(url))
        ? canLaunchUrl(Uri.parse(url))
        : showSnackBar(message: "Cannot open whatsapp", color: Colors.red);
  }

  launchMessage({required number, required message}) async {
    Uri sms = Uri.parse('sms:$number?body=$message');
    if (await launchUrl(sms)) {
      //app opened
    } else {
      //app is not opened
    }
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
              InkWell(
                onTap: () {
                  Get.find<HomeController>().selectedWidget.value = WalletPage(
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
                Get.find<HomeController>().selectedWidget.value =
                    CustomersPage();
              },
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          actions: [
            IconButton(
                onPressed: () {
                  customerController.assignTextFields(customerModel);
                  Get.to(() => EditCustomer(customerModel: customerModel));
                },
                icon: Icon(
                  Icons.edit,
                  color: Colors.black,
                )),
            IconButton(
                onPressed: () {
                  generalAlert(
                      title:
                          "Are you sure you want to delete ${customerModel.fullName}",
                      function: () {
                        customerController.deleteCustomer(
                            context: context,
                            id: customerModel.id,
                            shopId: shopController.currentShop.value?.id);
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
                  height: MediaQuery.of(context).size.height * 0.2,
                  color: AppColors.mainColor,
                  child: Column(
                    children: [
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
                                      message:
                                          "Aquick reminde that you owe our shop please pay your debt ");
                                },
                                icon: Icon(Icons.message),
                                color: Colors.white),
                            IconButton(
                                onPressed: () {
                                  launchWhatsApp(
                                      number: customerModel.phoneNumber,
                                      message:
                                          "Aquick reminde that you owe our shop please pay your debt ");
                                },
                                icon: Icon(Icons.whatshot),
                                color: Colors.white),
                            IconButton(
                                onPressed: () async {
                                  final Uri launchUri = Uri(
                                    scheme: 'tel',
                                    path: customerController
                                        .customer.value?.phoneNumber,
                                  );
                                  await launchUrl(launchUri);
                                },
                                icon: Icon(Icons.phone),
                                color: Colors.white),
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
                    customerController.assignTextFields(customerModel);

                    Get.to(() => EditCustomer(customerModel: customerModel));
                  },
                  icon: Icon(Icons.edit)),
              IconButton(
                  onPressed: () {
                    generalAlert(
                        title:
                            "Are you sure you want to delete ${customerModel.fullName}",
                        function: () {
                          customerController.deleteCustomer(
                              context: context,
                              id: customerModel.id,
                              shopId: shopController.currentShop.value?.id);
                        });
                  },
                  icon: Icon(Icons.delete)),
            ],
          )),
    );
  }

  Widget customerInfoBody(context) {
    return SizedBox(
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
                      indicatorColor: Colors.purple,
                      indicatorWeight: 3,
                      onTap: (index) {
                        customerController.initialPage.value = index;
                        if (index == 0) {
                          salesController.getSales(
                            onCredit: true,
                            customer: customerModel.id,
                          );
                        } else if (index == 1) {
                          salesController.getSales(customer: customerModel.id);
                        } else {
                          customerController.getCustomerReturns(
                            uid: customerModel.id,
                          );
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
                  CreditInfo(customerModel: customerModel),
                  SalesTab(),
                  RetunsTab()
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

class SalesTab extends StatelessWidget {
  SalesTab({Key? key}) : super(key: key);

  CustomerController customerController = Get.find<CustomerController>();
  SupplierController supplierController = Get.find<SupplierController>();
  ShopController createShopController = Get.find<ShopController>();
  SalesController salesController = Get.find<SalesController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return salesController.loadingSales.value
          ? const Center(child: CircularProgressIndicator())
          : salesController.allSales.isEmpty
              ? Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: const Text(
                    "No entries",
                    textAlign: TextAlign.center,
                  ))
              : MediaQuery.of(context).size.width > 600
                  ? SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
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
                            columns: const [
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
                                customerController.customerSales.length,
                                (index) {
                              SalesModel saleOrder = customerController
                                  .customerSales
                                  .elementAt(index);
                              // final y = saleOrder.product!.name;
                              // final x = saleOrder.;
                              final z = saleOrder.grandTotal;
                              final a = saleOrder.createdAt!;

                              return DataRow(cells: [
                                // DataCell(Text(y!)),
                                // DataCell(Text(x.toString())),
                                DataCell(Text(z.toString())),
                                DataCell(
                                    Text(DateFormat("dd-MM-yyyy").format(a))),
                              ]);
                            }),
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: salesController.allSales.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        SalesModel saleOrder =
                            salesController.allSales.elementAt(index);
                        return SalesCard(
                          salesModel: saleOrder,
                        );
                      });
    });
  }
}

class RetunsTab extends StatelessWidget {
  RetunsTab({Key? key}) : super(key: key);

  SalesController salesController = Get.find<SalesController>();
  CustomerController customerController = Get.find<CustomerController>();
  SupplierController supplierController = Get.find<SupplierController>();
  ShopController createShopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return customerController.loadingcustomerReturns.value
          ? const Center(child: CircularProgressIndicator())
          : customerController.customerReturns.isEmpty
              ? Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: const Text(
                    "No entries",
                    textAlign: TextAlign.center,
                  ))
              : MediaQuery.of(context).size.width > 600
                  ? SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
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
                            columns: const [
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
                              SalesReturn saleOrder = customerController
                                  .customerReturns
                                  .elementAt(index);
                              final y = saleOrder.productModel!.name;
                              // final x = saleOrder.shop;
                              // final z = saleOrder.total;
                              // final a = saleOrder.createdAt!;

                              return DataRow(cells: [
                                // DataCell(Text(y!)),
                                // DataCell(Text(x.toString())),
                                // DataCell(Text(z.toString())),
                                // DataCell(
                                //     Text(DateFormat("dd-MM-yyyy").format(a))),
                              ]);
                            }),
                          ),
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: customerController.customerReturns.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        SalesReturn saleOrder =
                            customerController.customerReturns.elementAt(index);
                        return SaleReturnCard(saleOrder);
                      });
    });
  }
}

class CreditInfo extends StatelessWidget {
  final CustomerModel customerModel;
  SupplierController supplierController = Get.find<SupplierController>();
  CustomerController customerController = Get.find<CustomerController>();
  AttendantController attendantController = Get.find<AttendantController>();
  ShopController createShopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();
  SalesController salesController = Get.find<SalesController>();
  PurchaseController purchaseController = Get.find<PurchaseController>();

  CreditInfo({Key? key, required this.customerModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return salesController.loadingSales.value
          ? const Center(child: CircularProgressIndicator())
          : salesController.creditSales.isEmpty
              ? Center(
                  child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
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
                                  label: Text('', textAlign: TextAlign.center)),
                            ],
                            rows: List.generate(
                                salesController.creditSales.length, (index) {
                              SalesModel salesBody =
                                  salesController.creditSales.elementAt(index);
                              final y = salesBody.receiptNumber;
                              final x = salesBody.creditTotal;
                              final z = salesBody.grandTotal;
                              final a = salesBody.createdAt!;

                              return DataRow(cells: [
                                DataCell(Container(child: Text(y!))),
                                DataCell(Container(child: Text(x.toString()))),
                                DataCell(Container(child: Text(z.toString()))),
                                DataCell(Container(
                                    child: Text(
                                        DateFormat("dd-MM-yyyy").format(a)))),
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
                                                Get.to(() => PurchaseOrderItems(
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
                                            leading:
                                                Icon(Icons.file_copy_outlined),
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
                      itemCount: salesController.creditSales.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        SalesModel salesBody =
                            salesController.creditSales.elementAt(index);

                        return SalesCard(salesModel: salesBody);
                      });
    });
  }
}

showBottomSheet(BuildContext context) {
  return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 150,
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.7),
                    child: Text('Manage Bank')),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      // editingDialog(
                      //   context: context,
                      //   onPressed: () {},
                      // );
                    },
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(
                          width: 10,
                        ),
                        Container(child: Text('Edit'))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      deleteDialog(context: context, onPressed: () {});
                    },
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded),
                        SizedBox(
                          width: 10,
                        ),
                        Container(child: Text('Delete'))
                      ],
                    ),
                  ),
                ),
              ],
            )));
      });
}
