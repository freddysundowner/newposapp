import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pointify/controllers/CustomerController.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/models/receipt.dart';
import 'package:pointify/screens/sales/components/return_stock.dart';

import '../../../models/invoice_items.dart';
import '../../../utils/colors.dart';
import '../../../utils/themer.dart';
import '../../../widgets/alert.dart';
import '../../../widgets/bigtext.dart';
import '../../../widgets/normal_text.dart';

class SalesReceipt extends StatelessWidget {
  SalesModel? salesModel;
  SalesReceipt({Key? key, this.salesModel}) : super(key: key) {
    salesController.getSalesBySaleId(uid: salesModel?.id);
  }
  ShopController shopController = Get.find<ShopController>();
  SalesController salesController = Get.find<SalesController>();

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
          "Receipt#${salesModel?.receiptNumber}",
          style: const TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (salesModel!.customerId != null)
              Row(
                children: [
                  Text(
                    "Customer: ${salesModel!.customerId!.fullName!}",
                    style: const TextStyle(fontSize: 13),
                  ),
                  Spacer(),
                  Row(
                    children: [
                      normalText(
                          title: "Date:", color: Colors.black, size: 14.0),
                      const SizedBox(
                        width: 5,
                      ),
                      majorTitle(
                          title: DateFormat("yyyy/MM/dd hh:mm")
                              .format(salesModel!.createdAt!),
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
                    SizedBox(
                      height: 10,
                    ),
                    majorTitle(
                        title: htmlPrice(salesModel?.grandTotal!),
                        color: Colors.black,
                        size: 18.0)
                  ],
                ),
                SizedBox(
                  width: 80,
                ),
                if (salesModel!.creditTotal! > 0)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      normalText(
                          title: "Balance", color: Colors.black, size: 14.0),
                      SizedBox(
                        height: 10,
                      ),
                      majorTitle(
                          title: htmlPrice(salesModel?.creditTotal!),
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
                      color: _chechPaymentColor(salesModel!),
                      borderRadius: BorderRadius.circular(5)),
                  child: Text(
                    _chechPayment(salesModel!),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                if (salesModel!.creditTotal! > 0)
                  InkWell(
                    child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                        decoration: BoxDecoration(
                            border: Border.all(
                                color: _chechPaymentColor(salesModel!)),
                            borderRadius: BorderRadius.circular(5)),
                        child: const Text("Pay Now")),
                    onTap: () {
                      showAmountDialog(salesModel!);
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
                          itemCount: salesController.salesHistory.length,
                          itemBuilder: (BuildContext c, int i) {
                            InvoiceItem sale = salesController.salesHistory[i];
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
                                        "${sale.itemCount!} @${htmlPrice(sale.price!)}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            decoration: sale.itemCount == 0
                                                ? TextDecoration.lineThrough
                                                : null),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          _dialog(sale);
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
                                      _dialog(sale);
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
                              htmlPrice(salesModel!.grandTotal),
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
                              .format(salesModel!.createdAt!),
                          color: Colors.black,
                          size: 18.0)
                    ],
                  ),
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      normalText(
                          title: "Served by", color: Colors.black, size: 14.0),
                      const SizedBox(
                        height: 10,
                      ),
                      majorTitle(
                          title: salesModel?.attendantId?.fullnames,
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

String _chechPayment(SalesModel salesModel) {
  if (salesModel.grandTotal == 0) return "RETURNED";
  if (salesModel.creditTotal == 0) return "PAID";
  if (salesModel.creditTotal! > 0) return "NOT PAID";
  return "";
}

Color _chechPaymentColor(SalesModel salesModel) {
  if (salesModel.grandTotal! == 0) return Colors.red;
  if (salesModel.creditTotal == 0) return Colors.green;
  if (salesModel.creditTotal! > 0) return Colors.red;
  return Colors.black;
}

void _dialog(InvoiceItem sale) {
  if (sale.itemCount! > 0) {
    returnInvoiceItem(invoiceItem: sale);
  }
}

returnInvoiceItem({required InvoiceItem invoiceItem}) {
  SalesController salesController = Get.find<SalesController>();
  TextEditingController textEditingController = TextEditingController();
  textEditingController.text = invoiceItem.itemCount.toString();
  return showDialog(
      context: Get.context!,
      builder: (_) {
        return AlertDialog(
          title: const Text("Return Product?"),
          content: Container(
            decoration: ThemeHelper().inputBoxDecorationShaddow(),
            child: TextFormField(
              controller: textEditingController,
              decoration: ThemeHelper()
                  .textInputDecorationDesktop('Quantity', 'Enter quantity'),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Get.back();
                },
                child: Text(
                  "Cancel".toUpperCase(),
                  style: TextStyle(color: AppColors.mainColor),
                )),
            TextButton(
                onPressed: () {
                  if (invoiceItem.itemCount! <
                      int.parse(textEditingController.text)) {
                    generalAlert(
                        title: "Error",
                        message:
                            "You cannot return more than ${invoiceItem.itemCount}");
                  } else if (int.parse(textEditingController.text) <= 0) {
                    generalAlert(
                        title: "Error",
                        message: "You must atleast return 1 item");
                  } else {
                    Get.back();
                    salesController.returnSale(
                        invoiceItem, int.parse(textEditingController.text));
                  }
                },
                child: Text(
                  "Okay".toUpperCase(),
                  style: TextStyle(color: AppColors.mainColor),
                ))
          ],
        );
      });
}

showAmountDialog(SalesModel salesBody) {
  CustomerController customerController = Get.find<CustomerController>();
  SalesController salesController = Get.find<SalesController>();
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
                      hintText: "eg ${salesBody.grandTotal}",
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
                if (salesBody.creditTotal! <
                    int.parse(customerController.amountController.text)) {
                } else {
                  salesController.payCredit(
                      salesBody: salesBody,
                      amount: customerController.amountController.text);
                }
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
