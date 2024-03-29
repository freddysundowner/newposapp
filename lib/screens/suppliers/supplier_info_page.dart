import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/controllers/supplierController.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/customers/customers_page.dart';
import 'package:pointify/screens/suppliers/edit_suppliere.dart';
import 'package:pointify/screens/suppliers/suppliers_page.dart';
import 'package:pointify/utils/helper.dart';
import 'package:pointify/widgets/alert.dart';
import 'package:pointify/widgets/purchase_order_card.dart';
import 'package:pointify/widgets/smalltext.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Real/schema.dart';
import '../../controllers/AuthController.dart';
import '../../controllers/user_controller.dart';
import '../../functions/functions.dart';
import '../../utils/colors.dart';
import '../../widgets/invoice_table.dart';
import '../../widgets/purchase_card.dart';
import '../../widgets/snackBars.dart';
import '../cash_flow/payment_history.dart';
import '../purchases/invoice_screen.dart';
import '../stock/purchase_order_item.dart';

class SupplierInfoPage extends StatelessWidget {
  final Supplier supplierModel;

  SupplierInfoPage({Key? key, required this.supplierModel}) : super(key: key) {
    supplierController.initialPage.value = 0;
    purchaseController.getPurchase(onCredit: true, supplier: supplierModel);
  }

  SupplierController supplierController = Get.find<SupplierController>();
  ShopController shopController = Get.find<ShopController>();
  UserController attendantController = Get.find<UserController>();
  ShopController createShopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();
  PurchaseController purchaseController = Get.find<PurchaseController>();

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
                          supplierModel.fullName!,
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
                                        number: supplierModel.phoneNumber,
                                        message:
                                            "A quick reminde that you owe our shop please pay your debt ");
                                  },
                                  icon: const Icon(Icons.message),
                                  color: Colors.white),
                              IconButton(
                                  onPressed: () {
                                    launchWhatsApp(
                                        number: supplierModel.phoneNumber,
                                        message:
                                            "A quick reminde that you owe our shop please pay your debt ");
                                  },
                                  icon: const Icon(Icons.whatshot),
                                  color: Colors.white),
                              IconButton(
                                  onPressed: () async {
                                    final Uri launchUri = Uri(
                                      scheme: 'tel',
                                      path: supplierController
                                          .supplier.value?.phoneNumber,
                                    );
                                    await launchUrl(launchUri);
                                  },
                                  icon: const Icon(Icons.phone),
                                  color: Colors.white),
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
                    supplierController.initialPage.value = 0;
                    Get.back();
                  },
                  icon: const Icon(Icons.arrow_back_ios)),
              actions: [
                IconButton(
                    onPressed: () {
                      supplierController.assignTextFields(supplierModel);

                      Get.to(() => EditSupplier(supplierModel: supplierModel));
                    },
                    icon: const Icon(Icons.edit)),
                if (checkPermission(
                    category: "suppliers", permission: "manage"))
                  IconButton(
                      onPressed: () {
                        generalAlert(
                            title:
                                "Are you sure you want to delete ${supplierModel.fullName}",
                            function: () {
                              supplierController.deleteSuppler(supplierModel);
                            });
                      },
                      icon: const Icon(Icons.delete)),
              ],
            ))
        : Scaffold(
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
                          title: supplierModel.fullName,
                          color: Colors.black,
                          size: 18)
                    ],
                  ),
                ],
              ),
              leading: IconButton(
                  onPressed: () {
                    Get.find<HomeController>().selectedWidget.value =
                        SuppliersPage();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  )),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: PopupMenuButton(
                    itemBuilder: (ctx) => [
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                          onTap: () {
                            Get.back();
                            supplierController.assignTextFields(supplierModel);
                            Get.find<HomeController>().selectedWidget.value =
                                EditSupplier(supplierModel: supplierModel);
                          },
                          title: const Text("Edit"),
                        ),
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          leading: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onTap: () {
                            Get.back();
                            generalAlert(
                                title:
                                    "Are you sure you want to delete ${supplierModel.fullName}",
                                function: () {
                                  supplierController.deleteSuppler(supplierModel);
                                });
                          },
                          title: Text("Delete"),
                        ),
                      ),
                    ],
                    icon: const Icon(
                      Icons.more_vert,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            body: customerInfoBody(context),
          );
    // ResponsiveWidget(
    //   largeScreen:
// ,
    //   smallScreen: ,
    // );
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
                      supplierController.initialPage.value = index;
                      if (index == 0) {
                        purchaseController.getPurchase(
                            onCredit: true, supplier: supplierModel);
                      } else if (index == 1) {
                        purchaseController.getPurchase(
                          supplier: supplierModel,
                          onCredit: false,
                        );
                      } else {
                        purchaseController.getReturns(
                          supplier: supplierModel,
                        );
                      }
                    },
                    tabs: const [
                      Tab(
                          child: Row(children: [
                        Text(
                          "Pending",
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        )
                      ])),
                      Tab(
                          child: Text(
                        "Invoices",
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
                        CreditInfo(supplierModel: supplierModel),
                        Purchase(supplierModel: supplierModel),
                        ReturnedPurchases(id: supplierModel.id)
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
          return Container(
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
                      child: Container(
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
                      child: Container(
                        width: double.infinity,
                        child: Row(
                          children: [
                            const Icon(Icons.cloud_download_outlined),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(child: const Text('Purchase History'))
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
                            const Icon(Icons.clear),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                                child: const Text(
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

  final Supplier supplierModel;

  Purchase({Key? key, required this.supplierModel}) : super(key: key);

  SupplierController supplierController = Get.find<SupplierController>();
  PurchaseController purchaseController = Get.find<PurchaseController>();
  ShopController createShopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return purchaseController.getPurchaseLoad.value
          ? const Center(child: CircularProgressIndicator())
          : purchaseController.purchasedItems.isEmpty
              ? Container(
                  margin: const EdgeInsets.only(top: 50),
                  child: const Text(
                    "No entries",
                    textAlign: TextAlign.center,
                  ))
              : isSmallScreen(context)
                  ? ListView.builder(
                      itemCount: purchaseController.purchasedItems.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        Invoice invoice =
                            purchaseController.purchasedItems.elementAt(index);
                        return InkWell(
                          onTap: () {
                            // showBottomSheet(context, purchaseOrder, supplier);
                          },
                          child: InvoiceCard(
                            invoice: invoice,
                          ),
                        );
                      })
                  : SingleChildScrollView(
                      child: invoiceTable(context: context,supplierModel: supplierModel),
                    );
    });
  }
}

class ReturnedPurchases extends StatelessWidget {
  final id;

  ReturnedPurchases({Key? key, required this.id}) : super(key: key);

  ShopController createShopController = Get.find<ShopController>();
  PurchaseController purchaseController = Get.find<PurchaseController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return purchaseController.currentInvoiceReturns.isEmpty
          ? Container(
              margin: const EdgeInsets.only(top: 50),
              child: const Text(
                "No entries",
                textAlign: TextAlign.center,
              ))
          : isSmallScreen(context)
              ? ListView.builder(
                  itemCount: purchaseController.currentInvoiceReturns.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    InvoiceItem purchaseReturn = purchaseController
                        .currentInvoiceReturns
                        .elementAt(index);
                    return InkWell(
                      onTap: () {
                        // showBottomSheet(context, purchaseOrder, supplier);
                      },
                      child: returnedIvoiceItemsCard(
                          context: context, invoiceItem: purchaseReturn),
                    );
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
                                  Text('Product', textAlign: TextAlign.center)),
                          DataColumn(
                              label: Text('Qty', textAlign: TextAlign.center)),
                          DataColumn(
                              label:
                                  Text('Total', textAlign: TextAlign.center)),
                          DataColumn(
                              label: Text('Attendant',
                                  textAlign: TextAlign.center)),
                          DataColumn(
                              label: Text('Date', textAlign: TextAlign.center)),
                          DataColumn(
                              label: Text('Action', textAlign: TextAlign.center)),
                        ],
                        rows: List.generate(
                            purchaseController.currentInvoiceReturns.length,
                            (index) {
                          InvoiceItem purchaseReturn = purchaseController
                              .currentInvoiceReturns
                              .elementAt(index);
                          final y = purchaseReturn.product!.name;
                          final x = purchaseReturn.itemCount;
                          final z = purchaseReturn.total;
                          final a = purchaseReturn.createdAt!;

                          return DataRow(cells: [
                            DataCell(Text(y!)),
                            DataCell(Text(x.toString())),
                            DataCell(Text(z.toString())),
                            DataCell(
                                Text(purchaseReturn.attendantid!.username!)),
                            DataCell(Text(DateFormat("dd-MM-yyyy").format(a))),
                            DataCell(Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1.0),
                              child: InkWell(
                                  onTap: () {
                                    Get.find<HomeController>().selectedWidget.value =
                                        InvoiceScreen(
                                            invoice: purchaseReturn.invoice, type: "returns", from: "supplierpage");
                                  },
                                  child: Text(
                                    "View",
                                    style: TextStyle(color: AppColors.mainColor),
                                  )),
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

class CreditInfo extends StatelessWidget {
  final Supplier supplierModel;
  SupplierController supplierController = Get.find<SupplierController>();
  UserController attendantController = Get.find<UserController>();
  ShopController createShopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();
  PurchaseController purchaseController = Get.find<PurchaseController>();

  CreditInfo({Key? key, required this.supplierModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return purchaseController.purchasedItems.isEmpty
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
                  itemCount: purchaseController.purchasedItems.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    Invoice purchaseOrder =
                        purchaseController.purchasedItems.elementAt(index);

                    return InvoiceCard(invoice: purchaseOrder, tab: "credit");
                  })
              : SingleChildScrollView(
                  child: invoiceTable(context: context,supplierModel: supplierModel),
                );
    });
  }
}

Widget CreditHistoryCard(context, Invoice salesBody, Supplier customerModel) {
  return InkWell(
    onTap: () {
      showBottomSheet(context, salesBody, customerModel);
    },
    child: Container(
        margin: const EdgeInsets.all(4),
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Center(
              child: Icon(Icons.arrow_downward, color: Colors.red),
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("#${salesBody.receiptNumber}"),
                Text("Date: ${DateFormat().format(salesBody.createdAt!)}"),
                // Text("Quantity: ${salesBody.quantity}"),
                Text(
                  "Due: ${Get.find<ShopController>().currentShop.value?.currency} ${salesBody.balance}",
                  style: const TextStyle(color: Colors.red),
                ),
              ],
            ),
            const Spacer(),
            const Align(
                child: Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey,
            )),
          ],
        )),
  );
}

showBottomSheet(
  BuildContext context,
  Invoice salesBody,
  Supplier customerModel,
) {
  SalesController salesController = Get.find<SalesController>();
  return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: MediaQuery.of(context).size.height * 0.40,
            child: Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    padding: const EdgeInsets.all(10),
                    width: double.infinity,
                    color: Colors.grey.withOpacity(0.7),
                    child: const Text('Select Action')),
                ListTile(
                  leading: const Icon(Icons.list),
                  onTap: () {
                    Navigator.pop(context);
                    if (MediaQuery.of(context).size.width > 600) {
                      Get.find<HomeController>().selectedWidget.value =
                          PurchaseOrderItems(
                        id: salesBody.id,
                        page: "customeInfo",
                      );
                    } else {
                      Get.to(() => PurchaseOrderItems(
                            id: salesBody.id,
                            page: "customeInfo",
                          ));
                    }
                  },
                  title: const Text('View Purchases'),
                ),
                if (salesBody.total! > 0)
                  ListTile(
                    leading: const Icon(Icons.payment),
                    onTap: () {
                      Navigator.pop(context);
                      showAmountDialog(context, salesBody);
                    },
                    title: const Text('Pay'),
                  ),
                ListTile(
                  leading: const Icon(Icons.wallet),
                  onTap: () {
                    Navigator.pop(context);
                    // if (MediaQuery.of(context).size.width > 600) {
                    //   Get.find<HomeController>().selectedWidget.value =
                    //       PaymentHistory(
                    //     id: salesBody.id!,
                    //   );
                    // } else {
                    //   Get.to(() => PaymentHistory(
                    //         id: salesBody.id!,
                    //         type: "purchase",
                    //       ));
                    // }
                  },
                  title: const Text('Payment History'),
                ),
                ListTile(
                  leading: const Icon(Icons.file_copy_outlined),
                  onTap: () async {
                    Navigator.pop(context);
                    // await salesController.getPaymentHistory(
                    //     id: salesBody.id!, type: "");

                    // PaymentHistoryPdf(
                    //     shop:
                    //         Get.find<ShopController>().currentShop.value!.name,
                    //     deposits: salesController.paymenHistory.value);
                  },
                  title: const Text('Generate Report'),
                ),
              ],
            )));
      });
}

showAmountDialog(context, Invoice salesBody) {
  SupplierController supplierController = Get.find<SupplierController>();
  PurchaseController purchaseController = Get.find<PurchaseController>();
  showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Enter Amount",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: supplierController.amountController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "eg ${salesBody.total}",
                      hintStyle: const TextStyle(color: Colors.black),
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                )
              ],
            )),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "Cancel".toUpperCase(),
                style: const TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                if (salesBody.total! <
                    int.parse(supplierController.amountController.text)) {
                } else {
                  purchaseController.paySupplierCredit(
                      invoice: salesBody,
                      amount: supplierController.amountController.text);
                }
              },
              child: Text(
                "Save".toUpperCase(),
                style: const TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      });
}
