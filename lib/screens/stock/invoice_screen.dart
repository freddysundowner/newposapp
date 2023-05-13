import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pointify/controllers/CustomerController.dart';
import 'package:pointify/controllers/purchase_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/models/invoice.dart';
import 'package:pointify/screens/sales/components/return_stock.dart';
import '../../../widgets/bigtext.dart';
import '../../../widgets/normal_text.dart';
import '../../models/invoice_items.dart';

class InvoiceScreen extends StatelessWidget {
  Invoice? invoice;
  InvoiceScreen({Key? key, this.invoice}) : super(key: key) {
    purchaseController.getPurchaseOrderItems(purchaseId: invoice?.id);
  }
  ShopController shopController = Get.find<ShopController>();
  PurchaseController purchaseController = Get.find<PurchaseController>();

  @override
  Widget build(BuildContext context) {
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
          "Invoice#${invoice?.receiptNumber}",
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (invoice!.supplier?.fullName != null)
                  Text(
                    "Supplier: ${invoice!.supplier!.fullName}",
                    style: const TextStyle(fontSize: 13),
                  ),
                if (invoice!.supplier?.fullName != null) Spacer(),
                Row(
                  children: [
                    normalText(title: "Date:", color: Colors.black, size: 14.0),
                    const SizedBox(
                      width: 5,
                    ),
                    majorTitle(
                        title: DateFormat("yyyy/MM/dd hh:mm")
                            .format(invoice!.createdAt!),
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
                        title: "Total Amount", color: Colors.black, size: 14.0),
                    const SizedBox(
                      height: 10,
                    ),
                    majorTitle(
                        title: htmlPrice(invoice?.total!),
                        color: Colors.black,
                        size: 18.0)
                  ],
                ),
                SizedBox(
                  width: 80,
                ),
                if (invoice!.balance! > 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      normalText(
                          title: "Balance", color: Colors.black, size: 14.0),
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
                    _chechPayment(invoice!),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                if (invoice!.balance! > 0)
                  InkWell(
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                            border:
                                Border.all(color: _chechPaymentColor(invoice!)),
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
              flex: 1,
              child: Column(
                children: [
                  Expanded(
                    child: Obx(
                      () => ListView.builder(
                          itemCount: purchaseController.invoicesItems.length,
                          itemBuilder: (BuildContext c, int i) {
                            InvoiceItem sale =
                                purchaseController.invoicesItems[i];
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
                                InkWell(
                                    onTap: () {
                                      _dialog(invoice!, sale);
                                    },
                                    child: const Icon(Icons.more_vert)),
                              ],
                            );
                          }),
                    ),
                  ),
                  Divider(
                    color: Colors.black,
                  ),
                  Expanded(
                    flex: 3,
                    child: Table(children: [
                      TableRow(children: [
                        Text(
                          "",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          "",
                          style: const TextStyle(fontSize: 16),
                        ),
                        Column(
                          children: [
                            Text(
                              htmlPrice(invoice!.total),
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            Divider(
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
              flex: 2,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      normalText(
                          title: "Date", color: Colors.black, size: 14.0),
                      SizedBox(
                        height: 10,
                      ),
                      majorTitle(
                          title: DateFormat("yyyy-MM-dd hh:mm")
                              .format(invoice!.createdAt!),
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
                          title: invoice?.attendantId?.fullnames,
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
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(
          color: Colors.black,
          width: 1.0,
        ))),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                  padding: const EdgeInsets.only(right: 20, bottom: 20),
                  decoration: BoxDecoration(
                      border: Border(
                          right: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ))),
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    child: majorTitle(
                        title: "Print", color: Colors.black, size: 16.0),
                  )),
              Container(
                  padding: const EdgeInsets.only(right: 20, bottom: 20),
                  decoration: const BoxDecoration(
                      border: Border(
                          right: BorderSide(
                    color: Colors.black,
                    width: 1.0,
                  ))),
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    child: majorTitle(
                        title: "Email", color: Colors.black, size: 16.0),
                  )),
              Container(
                  padding: const EdgeInsets.only(right: 20, bottom: 20),
                  child: Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: majorTitle(
                        title: "PDF View", color: Colors.black, size: 16.0),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}

String _chechPayment(Invoice salesModel) {
  if (salesModel.total == 0) return "RETURNED";
  if (salesModel.balance == 0) return "PAID";
  if (salesModel.balance! > 0) return "NOT PAID";
  return "";
}

Color _chechPaymentColor(Invoice invoice) {
  if (invoice.total! == 0) return Colors.red;
  if (invoice.balance == 0) return Colors.green;
  if (invoice.balance! > 0) return Colors.red;
  return Colors.black;
}

void _dialog(Invoice invoice, InvoiceItem invoiceItem) {
  if (invoiceItem.itemCount! > 0) {
    returnInvoiceItem(invoiceItem: invoiceItem, invoice: invoice);
  }
}

showAmountDialog(Invoice salesBody) {
  CustomerController customerController = Get.find<CustomerController>();
  showDialog(
      context: Get.context!,
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
            height: MediaQuery.of(Get.context!).size.height * 0.2,
            child: Form(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: customerController.amountController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                      hintText: "eg ${salesBody.total}",
                      hintStyle: TextStyle(color: Colors.black),
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
                style: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.back();
                // if (salesBody.balance! <
                //     int.parse(customerController.amountController.text)) {
                // } else {
                //   salesController.payCredit(
                //       salesBody: salesBody,
                //       amount: customerController.amountController.text);
                // }
              },
              child: Text(
                "Save".toUpperCase(),
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
