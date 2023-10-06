import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
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

import '../../Real/schema.dart';
import '../../controllers/CustomerController.dart';
import '../../controllers/AuthController.dart';
import '../../controllers/user_controller.dart';
import '../../controllers/supplierController.dart';
import '../../functions/functions.dart';
import '../../utils/colors.dart';
import '../../widgets/delete_dialog.dart';
import '../../widgets/snackBars.dart';
import '../cash_flow/payment_history.dart';
import '../sales/components/sales_receipt.dart';
import '../stock/purchase_order_item.dart';

class CustomerInfoPage extends StatelessWidget {
  final CustomerModel customerModel;

  CustomerInfoPage({Key? key, required this.customerModel}) : super(key: key) {
    salesController.getSales(onCredit: true, customer: customerModel);
  }

  CustomerController customerController = Get.find<CustomerController>();
  SupplierController supplierController = Get.find<SupplierController>();
  ShopController shopController = Get.find<ShopController>();
  UserController attendantController = Get.find<UserController>();
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
    print("on credit ${customerModel.credit}");
    return isSmallScreen(context)
        ? Helper(
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
                            child: const Icon(
                              Icons.person,
                              color: Colors.grey,
                              size: 50,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Center(
                            child: Text(
                          customerModel.fullName!,
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                        const SizedBox(height: 15),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    launchMessage(
                                        number: customerModel.phoneNumber,
                                        message:
                                            "A quick reminder that you owe our shop please pay your debt ");
                                  },
                                  icon: const Icon(Icons.message),
                                  color: Colors.white),
                              IconButton(
                                  onPressed: () {
                                    launchWhatsApp(
                                        number: customerModel.phoneNumber,
                                        message:
                                            "A quick reminder that you owe our shop please pay your debt ");
                                  },
                                  icon: const Icon(Icons.whatshot),
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
                                  icon: const Icon(Icons.phone),
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
                                  padding: const EdgeInsets.only(
                                      top: 5, bottom: 5, left: 10, right: 15),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50),
                                      color: Colors.white.withOpacity(0.2)),
                                  child: const Row(
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
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              actions: [
                IconButton(
                    onPressed: () {
                      customerController.assignTextFields(customerModel);
                      Get.to(() => EditCustomer(customerModel: customerModel));
                    },
                    icon: const Icon(Icons.edit)),
                if (checkPermission(
                    category: "customers", permission: "manage"))
                  IconButton(
                      onPressed: () {
                        if (customerModel.onCredit == true) {
                          generateWarningAlert(
                              title: "Error",
                              message: "You cannot delete customer who is on credit ");
                        } else {
                          generalAlert(
                              title:
                                  "Are you sure you want to delete ${customerModel.fullName}",
                              function: () {
                                customerController
                                    .deleteCustomer(customerModel);
                              });
                        }
                      },
                      icon: const Icon(
                        Icons.delete,
                      )),
              ],
            ))
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              elevation: 0.0,
              backgroundColor: Colors.white,
              title: minorTitle(
                  title: customerModel.fullName, color: Colors.black, size: 18),
              leading: IconButton(
                  onPressed: () {
                    Get.find<HomeController>().selectedWidget.value =
                        CustomersPage();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              actions: [
                PopupMenuButton(
                  itemBuilder: (ctx) => [
                    PopupMenuItem(
                      child: ListTile(
                        leading:
                            const Icon(Icons.credit_card, color: Colors.black),
                        onTap: () {
                          Get.back();
                          Get.find<HomeController>().selectedWidget.value =
                              WalletPage(
                            customerModel: customerModel,
                          );
                        },
                        title: const Text("Wallet"),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.edit),
                        onTap: () {
                          Get.back();
                          customerController.assignTextFields(customerModel);
                          Get.find<HomeController>().selectedWidget.value =
                              EditCustomer(customerModel: customerModel);
                        },
                        title: const Text("Edit"),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: const Icon(Icons.delete, color: Colors.red),
                        onTap: () {
                          Get.back();
                          if (customerModel.onCredit == true) {
                            generateWarningAlert(
                              title: "Error",
                                message: "You cannot delete customer who is on credit ");
                          } else {
                            generalAlert(
                                title:
                                    "Are you sure you want to delete ${customerModel.fullName}",
                                function: () {
                                  customerController
                                      .deleteCustomer(customerModel);
                                });
                          }
                        },
                        title: const Text("Delete"),
                      ),
                    ),
                  ],
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                )
              ],
            ),
            body: customerInfoBody(context),
          );
  }

  Widget customerInfoBody(context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        height: kToolbarHeight,
        child: DefaultTabController(
          initialIndex: 0,
          length: 3,
          child: Builder(builder: (context) {
            return Column(
              children: [
                TabBar(
                    controller: DefaultTabController.of(context),
                    onTap: (index) {
                      if (index == 0) {
                        salesController.getSales(
                          onCredit: true,
                          customer: customerModel,
                        );
                      } else if (index == 1) {
                        salesController.getSales(customer: customerModel);
                      } else {
                        salesController.getReturns(
                            customerModel: customerModel, type: "return");
                      }
                    },
                    tabs: const [
                      Tab(
                          child: Text(
                        "Credit",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )),
                      Tab(
                          child: Text(
                        "Sales",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )),
                      Tab(
                          child: Text(
                        "Returns",
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      )),
                    ]),
                Expanded(
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                    child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        CreditInfo(customerModel: customerModel),
                        SalesTab(),
                        ReturnsTab()
                      ],
                    ),
                  ),
                )
              ],
            );
          }),
        ),
      ),
    );
  }

  showModalSheet(context) {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return SizedBox(
              height: 200,
              child: Center(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      color: Colors.grey.withOpacity(0.7),
                      child: const Text('Select Download Option')),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            const Icon(Icons.arrow_downward),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(child: const Text('Credit History '))
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
                      child: const SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            const Icon(Icons.cloud_download_outlined),
                            const SizedBox(
                              width: 10,
                            ),
                            Text('Purchase History')
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
                      child: const SizedBox(
                        width: double.infinity,
                        child: Row(
                          children: [
                            const Icon(Icons.clear),
                            const SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Cancel',
                              style: TextStyle(color: Colors.red),
                            )
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
              : isSmallScreen(context)
                  ? ListView.builder(
                      itemCount: salesController.allSales.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        SalesModel saleOrder =
                            salesController.allSales.elementAt(index);
                        return SalesCard(
                          salesModel: saleOrder,
                        );
                      })
                  : SingleChildScrollView(
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
                                  label: Text('Receipt',
                                      textAlign: TextAlign.center)),
                              DataColumn(
                                  label: Text('Total',
                                      textAlign: TextAlign.center)),
                              DataColumn(
                                  label: Text('Payment Method',
                                      textAlign: TextAlign.center)),
                              DataColumn(
                                  label: Text('Date',
                                      textAlign: TextAlign.center)),
                              DataColumn(
                                  label: Text('', textAlign: TextAlign.center)),
                            ],
                            rows: List.generate(salesController.allSales.length,
                                (index) {
                              SalesModel saleOrder =
                                  salesController.allSales.elementAt(index);
                              final y = saleOrder.receiptNumber;
                              final x = saleOrder.grandTotal;
                              final z = saleOrder.paymentMethod;
                              final a = saleOrder.createdAt!;

                              return DataRow(cells: [
                                DataCell(Text("#${y!}")),
                                DataCell(Text(x.toString())),
                                DataCell(Text(z.toString())),
                                DataCell(
                                    Text(DateFormat("dd-MM-yyyy").format(a))),
                                DataCell(InkWell(
                                  onTap: () {
                                    Get.find<HomeController>()
                                        .selectedWidget
                                        .value = SalesReceipt(
                                      salesModel: saleOrder,
                                      type: "",
                                      from: "CustomerInfoPage",
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 1.0),
                                    child: Text(
                                      "View",
                                      style:
                                          TextStyle(color: AppColors.mainColor),
                                    ),
                                  ),
                                )),
                              ]);
                            }),
                          ),
                        ),
                      ),
                    );
    });
  }
}

class ReturnsTab extends StatelessWidget {
  ReturnsTab({Key? key}) : super(key: key);

  SalesController salesController = Get.find<SalesController>();

  @override
  Widget build(BuildContext context) {
    print(
        "salesController.currentReceiptReturns.length ${salesController.currentReceiptReturns.length}");
    return Obx(() {
      return salesController.currentReceiptReturns.isEmpty
          ? Container(
              margin: const EdgeInsets.only(top: 50),
              child: const Text(
                "No entries",
                textAlign: TextAlign.center,
              ))
          : isSmallScreen(context)
              ? ListView.builder(
                  itemCount: salesController.currentReceiptReturns.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    ReceiptItem receiptItem =
                        salesController.currentReceiptReturns.elementAt(index);
                    return SaleReturnCard(receiptItem);
                  })
              : SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 10),
                    width: double.infinity,
                    child: Theme(
                      data:
                          Theme.of(context).copyWith(dividerColor: Colors.grey),
                      child: DataTable(
                        decoration: BoxDecoration(
                            border: Border.all(
                          width: 1,
                          color: Colors.black,
                        )),
                        columnSpacing: 30.0,
                        columns: const [
                          DataColumn(
                              label:
                                  Text('Receipt', textAlign: TextAlign.center)),
                          DataColumn(
                              label:
                                  Text('Product', textAlign: TextAlign.center)),
                          DataColumn(
                              label: Text('Qty', textAlign: TextAlign.center)),
                          DataColumn(
                              label:
                                  Text('Total', textAlign: TextAlign.center)),
                          DataColumn(
                              label: Text('', textAlign: TextAlign.center)),
                        ],
                        rows: List.generate(
                            salesController.currentReceiptReturns.length,
                            (index) {
                          ReceiptItem receiptItem = salesController
                              .currentReceiptReturns
                              .elementAt(index);

                          final r = receiptItem.receipt?.receiptNumber;
                          final y = receiptItem.product!.name;
                          final x = receiptItem.quantity;
                          final z = receiptItem.total;
                          // final a = receiptItem.createdAt;

                          return DataRow(cells: [
                            DataCell(Text("#${r!}")),
                            DataCell(Text(y!)),
                            DataCell(Text(x.toString())),
                            DataCell(Text(z.toString())),
                            DataCell(InkWell(
                              onTap: () {
                                Get.find<HomeController>()
                                    .selectedWidget
                                    .value = SalesReceipt(
                                  salesModel: receiptItem.receipt,
                                  type: "returns",
                                  from: "CustomerInfoPage",
                                );
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 1.0),
                                child: Text(
                                  "View",
                                  style: TextStyle(color: AppColors.mainColor),
                                ),
                              ),
                            )),

                            // DataCell(Text(DateFormat("dd-MM-yyyy").format(a!))),
                          ]);
                        }),
                      ),
                    ),
                  ),
                );
    });
  }
}

class CreditInfo extends StatelessWidget {
  final CustomerModel customerModel;
  SalesController salesController = Get.find<SalesController>();

  CreditInfo({Key? key, required this.customerModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return salesController.loadingSales.value
          ? const Center(child: CircularProgressIndicator())
          : salesController.allSales.isEmpty
              ? const Center(
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
              : isSmallScreen(context)
                  ? ListView.builder(
                      itemCount: salesController.allSales.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        SalesModel salesBody =
                            salesController.allSales.elementAt(index);

                        return SalesCard(salesModel: salesBody);
                      })
                  : SingleChildScrollView(
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
                            rows: List.generate(salesController.allSales.length,
                                (index) {
                              SalesModel salesBody =
                                  salesController.allSales.elementAt(index);

                              final y = salesBody.receiptNumber;
                              final x = salesBody.creditTotal;
                              final z = salesBody.grandTotal;
                              final a = salesBody.createdAt!;

                              return DataRow(cells: [
                                DataCell(Text("#${y!}")),
                                DataCell(Text(x.toString())),
                                DataCell(Text(z.toString())),
                                DataCell(
                                    Text(DateFormat("dd-MM-yyyy").format(a))),
                                DataCell(InkWell(
                                  onTap: () {
                                    Get.find<HomeController>()
                                        .selectedWidget
                                        .value = SalesReceipt(
                                      salesModel: salesBody,
                                      type: "",
                                      from: "CustomerInfoPage",
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 1.0),
                                    child: Text(
                                      "View",
                                      style:
                                          TextStyle(color: AppColors.mainColor),
                                    ),
                                  ),
                                )),
                              ]);
                            }),
                          ),
                        ),
                      ),
                    );
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
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.7),
                    child: const Text('Manage Bank')),
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
                        const Icon(Icons.edit),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(child: const Text('Edit'))
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
                        const Icon(Icons.delete_outline_rounded),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(child: const Text('Delete'))
                      ],
                    ),
                  ),
                ),
              ],
            )));
      });
}
