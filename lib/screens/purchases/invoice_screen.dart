import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pointify/controllers/CustomerController.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/screens/sales/components/return_stock.dart';
import '../../../widgets/bigtext.dart';
import '../../../widgets/normal_text.dart';
import '../../Real/schema.dart';

class InvoiceScreen extends StatelessWidget {
  Invoice? invoice;
  String? type = "";
  String? from = "";
  InvoiceScreen({Key? key, this.invoice, this.type, this.from}) {
    purchaseController.currentInvoice.value = invoice;
    if (from == "supplierpage") {
    } else {
      purchaseController.getIvoiceById(invoice!);
    }
  }
  ShopController shopController = Get.find<ShopController>();
  PurchaseController purchaseController = Get.find<PurchaseController>();

  List<InvoiceItem> invoiceItems = [];
  @override
  Widget build(BuildContext context) {
    if (type == "returns") {
      invoiceItems = purchaseController.currentInvoice.value!.returneditems;
    } else {
      invoiceItems = purchaseController.currentInvoice.value!.items;
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          color: Colors.black,
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back_ios),
        ),
        title: Text(
          "Invoice #${purchaseController.currentInvoice.value!.receiptNumber}"
              .toUpperCase(),
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  if (purchaseController
                          .currentInvoice.value!.supplier?.fullName !=
                      null)
                    Text(
                      "Supplier: ${purchaseController.currentInvoice.value!.supplier!.fullName}",
                      style: const TextStyle(fontSize: 13),
                    ),
                  if (purchaseController
                          .currentInvoice.value!.supplier?.fullName !=
                      null)
                    Spacer(),
                  Row(
                    children: [
                      normalText(
                          title: "Date:", color: Colors.black, size: 14.0),
                      const SizedBox(
                        width: 5,
                      ),
                      majorTitle(
                          title: DateFormat("yyyy/MM/dd hh:mm").format(
                              purchaseController
                                  .currentInvoice.value!.createdAt!),
                          color: Colors.grey,
                          size: 11.0)
                    ],
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      normalText(
                          title: "Total", color: Colors.black, size: 14.0),
                      const SizedBox(
                        height: 10,
                      ),
                      majorTitle(
                          title: htmlPrice(invoice!.total!),
                          color: Colors.black,
                          size: 18.0)
                    ],
                  ),
                  if (purchaseController.currentInvoice.value!.balance! < 0)
                    SizedBox(
                      width: 30,
                    ),
                  if (purchaseController.currentInvoice.value!.balance! < 0)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        normalText(
                            title: "Total Paid",
                            color: Colors.black,
                            size: 14.0),
                        const SizedBox(
                          height: 10,
                        ),
                        majorTitle(
                            title: htmlPrice(
                                invoice!.total! - invoice!.balance!.abs()),
                            color: Colors.black,
                            size: 18.0)
                      ],
                    ),
                  SizedBox(
                    width: 80,
                  ),
                  if (purchaseController.currentInvoice.value!.balance! < 0 &&
                      type != "returns")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        normalText(
                            title: "Credit Balance",
                            color: Colors.black,
                            size: 14.0),
                        SizedBox(
                          height: 10,
                        ),
                        majorTitle(
                            title: htmlPrice(invoice?.balance!),
                            color: Colors.black,
                            size: 18.0)
                      ],
                    ),
                  SizedBox(
                    width: 30,
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                        color: _chechPaymentColor(invoice!),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      _chechPayment(invoice!, type!),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  if (purchaseController.currentInvoice.value!.balance! < 0 &&
                      invoiceItems.fold(
                              0,
                              (previousValue, element) =>
                                  previousValue + element.itemCount!) >
                          0 &&
                      type != "returns")
                    InkWell(
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: _chechPaymentColor(invoice!)),
                              borderRadius: BorderRadius.circular(5)),
                          child: const Text("Pay Now")),
                      onTap: () {
                        showAmountDialog(invoice!);
                      },
                    )
                ],
              ),
              Divider(
                color: Colors.grey,
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: invoiceItems.length,
                          itemBuilder: (BuildContext c, int i) {
                            InvoiceItem sale = invoiceItems[i];
                            return Row(
                              children: [
                                Expanded(
                                  child: Table(children: [
                                    TableRow(children: [
                                      Text(
                                        sale.product!.name!.capitalize!,
                                        style: TextStyle(
                                            fontSize: 16,
                                            decoration: sale.itemCount == 0
                                                ? TextDecoration.lineThrough
                                                : null),
                                      ),
                                      Text(
                                        "${sale.itemCount!} @${htmlPrice(sale.price)}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            decoration: sale.itemCount == 0
                                                ? TextDecoration.lineThrough
                                                : null),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _dialog(invoice!, sale);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              htmlPrice(sale.total!),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      sale.itemCount == 0
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : null),
                                            ),
                                            if (sale.itemCount == 0)
                                              const Icon(
                                                Icons.file_download,
                                                color: Colors.red,
                                                size: 15,
                                              )
                                          ],
                                        ),
                                      ),
                                    ]),
                                  ]),
                                ),
                                if (checkPermission(
                                    category: "stocks", permission: "return"))
                                  InkWell(
                                      onTap: () {
                                        _dialog(invoice!, sale);
                                      },
                                      child: const Icon(Icons.more_vert)),
                              ],
                            );
                          }),
                    ),
                    Divider(
                      color: Colors.black,
                    ),
                    Expanded(
                      flex: 3,
                      child: Table(children: [
                        TableRow(children: [
                          const Text(
                            "",
                            style: TextStyle(fontSize: 16),
                          ),
                          const Text(
                            "",
                            style: TextStyle(fontSize: 16),
                          ),
                          Column(
                            children: [
                              Text(
                                htmlPrice(invoiceItems.fold(
                                    0,
                                    (previousValue, element) =>
                                        previousValue +
                                        (element.price! * element.itemCount!))),
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const Divider(
                                thickness: 3,
                                color: Colors.black,
                              )
                            ],
                          ),
                        ]),
                      ]),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        normalText(
                            title: "Date", color: Colors.black, size: 14.0),
                        const SizedBox(
                          height: 10,
                        ),
                        majorTitle(
                            title: DateFormat("yyyy-MM-dd hh:mm").format(
                                purchaseController
                                    .currentInvoice.value!.createdAt!),
                            color: Colors.black,
                            size: 18.0)
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        normalText(
                            title: "Invoiced by",
                            color: Colors.black,
                            size: 14.0),
                        const SizedBox(
                          height: 10,
                        ),
                        majorTitle(
                            title: invoice?.attendantId?.username,
                            color: Colors.black,
                            size: 18.0)
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
            border: Border(
                top: BorderSide(
          color: Colors.black,
          width: 1.0,
        ))),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.only(top: 10),
                child:
                    majorTitle(title: "Print", color: Colors.black, size: 16.0),
              ),
              Container(
                padding: EdgeInsets.only(top: 10),
                child:
                    majorTitle(title: "Email", color: Colors.black, size: 16.0),
              ),
              Container(
                padding: const EdgeInsets.only(top: 10),
                child: majorTitle(
                    title: "PDF View", color: Colors.black, size: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _chechPayment(Invoice salesModel, String? type) {
  if (salesModel.total == 0 || type == "returns") {
    return type == "returns" ? "RETURNED ITEMS" : "RETURNED";
  }
  if (salesModel.total == 0) return "RETURNED";
  if (salesModel.balance == 0) return "CASH";
  if (salesModel.balance! < 0) return "ON CREDIT";
  return "";
}

Color _chechPaymentColor(Invoice invoice) {
  if (invoice.total! == 0) return Colors.red;
  if (invoice.balance == 0) return Colors.green;
  if (invoice.balance! < 0) return Colors.red;
  return Colors.black;
}

void _dialog(Invoice invoice, InvoiceItem invoiceItem) {
  if (invoiceItem.itemCount! > 0 && invoiceItem.type != "return") {
    returnInvoiceItem(invoiceItem: invoiceItem, invoice: invoice);
  }
}

showAmountDialog(Invoice invoice) {
  CustomerController customerController = Get.find<CustomerController>();
  showDialog(
      context: Get.context!,
      builder: (_) {
        return AlertDialog(
          title: const Text(
            "Enter Amount to pay",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Form(
              child: TextFormField(
            controller: customerController.amountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                hintText: "eg ${invoice.total}",
                hintStyle: TextStyle(color: Colors.black),
                fillColor: Colors.white,
                filled: true,
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
          )),
          actions: [
            TextButton(
              onPressed: () {
                Get.back();
              },
              child: Text(
                "Cancel".toUpperCase(),
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                if (invoice.balance!.abs() <
                    int.parse(customerController.amountController.text)) {
                } else {
                  Get.find<PurchaseController>().paySupplierCredit(
                      invoice: invoice,
                      amount: customerController.amountController.text);
                }
              },
              child: Text(
                "Pay".toUpperCase(),
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      });
}
