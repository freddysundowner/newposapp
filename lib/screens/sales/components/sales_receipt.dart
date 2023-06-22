import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pointify/controllers/CustomerController.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/pdfFiles/pdf/sales_receipt.dart';
import 'package:realm/realm.dart';
import '../../../Real/schema.dart';
import '../../../pdfFiles/pdfpreview.dart';
import '../../../utils/colors.dart';
import '../../../utils/themer.dart';
import '../../../widgets/alert.dart';
import '../../../widgets/bigtext.dart';
import '../../../widgets/normal_text.dart';

class SalesReceipt extends StatelessWidget {
  SalesModel? salesModel;
  String? type = "";
  String? from = "";
  SalesReceipt({Key? key, this.salesModel, this.type, this.from})
      : super(key: key) {
    salesController.currentReceipt.value = salesModel;
    if (from == "customerpage") {
    } else {
      salesController.getSalesBySaleId(id: salesModel!.id);
    }
  }
  ShopController shopController = Get.find<ShopController>();
  SalesController salesController = Get.find<SalesController>();
  List<ReceiptItem> receiptItems = [];
  @override
  Widget build(BuildContext context) {
    if (type == "returns") {
      receiptItems = salesController.currentReceipt.value!.returneditems;
    } else {
      receiptItems = salesController.currentReceipt.value!.items;
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
          icon: Icon(Icons.clear),
        ),
        title: Text(
          "Receipt#${salesController.currentReceipt.value!.receiptNumber}"
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
              if (salesController.currentReceipt.value!.customerId != null)
                Row(
                  children: [
                    Text(
                      "Customer: ${salesController.currentReceipt.value!.customerId!.fullName!}",
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
                            title: DateFormat("yyyy/MM/dd hh:mm").format(
                                salesController
                                    .currentReceipt.value!.createdAt!),
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
                          title: "Total Amount",
                          color: Colors.black,
                          size: 14.0),
                      SizedBox(
                        height: 10,
                      ),
                      majorTitle(
                          title: htmlPrice(
                              salesController.currentReceipt.value!.grandTotal),
                          color: Colors.black,
                          size: 18.0)
                    ],
                  ),
                  SizedBox(
                    width: 80,
                  ),
                  if (onCredit(salesController.currentReceipt.value!) &&
                      type != "returns")
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        normalText(
                            title: "Balance", color: Colors.black, size: 14.0),
                        SizedBox(
                          height: 10,
                        ),
                        majorTitle(
                            title: htmlPrice(salesController
                                .currentReceipt.value!.creditTotal!
                                .abs()),
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
                        color: _chechPaymentColor(
                            salesController.currentReceipt.value!, type!),
                        borderRadius: BorderRadius.circular(5)),
                    child: Text(
                      _chechPayment(
                          salesController.currentReceipt.value!, type!),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  if (onCredit(salesController.currentReceipt.value!) &&
                      salesController.currentReceipt.value!.items.fold(
                              0,
                              (previousValue, element) =>
                                  previousValue + element.quantity!) >
                          0 &&
                      type != "returns")
                    InkWell(
                      child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: _chechPaymentColor(
                                      salesController.currentReceipt.value!,
                                      type!)),
                              borderRadius: BorderRadius.circular(5)),
                          child: const Text("Pay Now")),
                      onTap: () {
                        showAmountDialog(salesController.currentReceipt.value!);
                      },
                    )
                ],
              ),
              Divider(
                color: Colors.grey,
              ),
              Expanded(
                flex: receiptItems.length,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: receiptItems.length,
                          itemBuilder: (BuildContext c, int i) {
                            ReceiptItem receiptitem = receiptItems[i];
                            return Row(
                              children: [
                                Expanded(
                                  child: Table(children: [
                                    TableRow(children: [
                                      Text(
                                        receiptitem.product!.name!.capitalize!,
                                        style: TextStyle(
                                            fontSize: 16,
                                            decoration:
                                                receiptitem.quantity == 0
                                                    ? TextDecoration.lineThrough
                                                    : null),
                                      ),
                                      Text(
                                        "${receiptitem.quantity!} @${htmlPrice(receiptitem.price!)}",
                                        style: TextStyle(
                                            fontSize: 16,
                                            decoration:
                                                receiptitem.quantity == 0
                                                    ? TextDecoration.lineThrough
                                                    : null),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          if (checkPermission(
                                              category: "sales",
                                              permission: "return"))
                                            _dialog(receiptitem);
                                        },
                                        child: Row(
                                          children: [
                                            Text(
                                              htmlPrice(receiptitem.total!),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  decoration:
                                                      receiptitem.quantity == 0
                                                          ? TextDecoration
                                                              .lineThrough
                                                          : null),
                                            ),
                                            if (receiptitem.quantity == 0)
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
                                    category: "sales", permission: "return"))
                                  InkWell(
                                      onTap: () {
                                        _dialog(receiptitem);
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
                                htmlPrice(salesController
                                    .currentReceipt.value!.grandTotal),
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
                            title: DateFormat("yyyy-MM-dd hh:mm").format(
                                salesController
                                    .currentReceipt.value!.createdAt!),
                            color: Colors.black,
                            size: 18.0)
                      ],
                    ),
                    Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        normalText(
                            title: "Served by",
                            color: Colors.black,
                            size: 14.0),
                        const SizedBox(
                          height: 10,
                        ),
                        majorTitle(
                            title: salesController
                                .currentReceipt.value!.attendantId?.username,
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
              InkWell(
                onTap: () {
                  Get.to(() async => PdfPreviewPage(
                      widget: await salesReceipt(salesModel!),
                      type: "Invoice"));
                  // SalesPdf(sales: salesModel!, type: "All");
                },
                child: Container(
                    padding: const EdgeInsets.only(right: 20, bottom: 20),
                    child: Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: majorTitle(
                          title: "PDF View", color: Colors.black, size: 16.0),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _chechPayment(SalesModel salesModel, String? type) {
  if (salesModel.grandTotal == 0 || type == "returns") {
    return type == "returns" ? "RETURNED ITEMS" : "RETURNED";
  }
  if (salesModel.creditTotal == 0) return "PAID";
  if (onCredit(salesModel) == true) return "NOT PAID";
  return "";
}

onCredit(SalesModel salesModel) => salesModel.creditTotal! < 0;
Color _chechPaymentColor(SalesModel salesModel, String? type) {
  if (salesModel.grandTotal! == 0 || type == "returns") return Colors.red;
  if (salesModel.creditTotal == 0) return Colors.green;
  if (onCredit(salesModel) == true) return Colors.red;
  return Colors.black;
}

void _dialog(ReceiptItem sale) {
  if (sale.quantity! > 0 && sale.type != "return") {
    returnReceiptItem(receiptItem: sale);
  }
}

returnReceiptItem({required ReceiptItem receiptItem}) {
  SalesController salesController = Get.find<SalesController>();
  TextEditingController textEditingController = TextEditingController();
  textEditingController.text = receiptItem.quantity.toString();
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
                  if (receiptItem.quantity! <
                      int.parse(textEditingController.text)) {
                    generalAlert(
                        title: "Error",
                        message:
                            "You cannot return more than ${receiptItem.quantity}");
                  } else if (int.parse(textEditingController.text) <= 0) {
                    generalAlert(
                        title: "Error",
                        message: "You must atleast return 1 item");
                  } else {
                    Get.back();
                    salesController.returnSale(
                        receiptItem, int.parse(textEditingController.text));
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
            child: Form(
                child: TextFormField(
              controller: customerController.amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                  hintText: "eg ${salesBody.grandTotal}",
                  hintStyle: TextStyle(color: Colors.black),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8))),
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
                if (salesBody.creditTotal!.abs() <
                    int.parse(customerController.amountController.text)) {
                  generalAlert(
                      title: "Error",
                      message:
                          "You cannot pay more than ${htmlPrice(salesBody.creditTotal!.abs())}");
                } else {
                  salesController.payCredit(
                      salesBody: salesBody,
                      amount:
                          int.parse(customerController.amountController.text));
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
