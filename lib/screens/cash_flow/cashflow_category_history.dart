// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:pointify/controllers/cashflow_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/models/bank_transactions.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/cash_flow/cash_at_bank.dart';
import 'package:pointify/screens/cash_flow/cashflow_categories.dart';
import 'package:pointify/utils/helper.dart';
import 'package:pointify/widgets/loading_dialog.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:pointify/widgets/pdf/history_pdf.dart';
import 'package:pointify/widgets/pdf/sales_pdf.dart';
import 'package:pointify/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/receipt.dart';
import '../../utils/colors.dart';
import '../../widgets/sales_card.dart';

class CashCategoryHistory extends StatelessWidget {
  final title;
  final subtitle;
  final id;
  final page;
  ShopController shopController = Get.find<ShopController>();
  SalesController salesController = Get.find<SalesController>();
  CashflowController cashflowController = Get.find<CashflowController>();

  CashCategoryHistory(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.id,
      required this.page})
      : super(key: key) {
    if (title == "sales") {
      salesController.getSales(total: "true");
    } else if (page == "cashflowcategory") {
      cashflowController.getCategoryHistory(id);
    } else {
      cashflowController.getBankTransactions(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      largeScreen: Scaffold(
        backgroundColor: Colors.white,
        appBar: _appBar("large", context),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return cashflowController.loadingBankHistory.value
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : cashflowController.bankTransactions.isEmpty
                          ? noItemsFound(context, true)
                          : Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
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
                                        label: Text(
                                            'Amount(${shopController.currentShop.value?.currency})',
                                            textAlign: TextAlign.center)),
                                    DataColumn(
                                        label: Text('Date',
                                            textAlign: TextAlign.center)),
                                  ],
                                  rows: List.generate(
                                      cashflowController
                                          .bankTransactions.length, (index) {
                                    BankTransactions bankTransactions =
                                        cashflowController.bankTransactions
                                            .elementAt(index);
                                    final y = bankTransactions.amount;
                                    final x = bankTransactions.createdAt;

                                    return DataRow(cells: [
                                      DataCell(
                                          Container(child: Text(y.toString()))),
                                      DataCell(Container(
                                          child: Text(DateFormat("yyyy-dd-MM")
                                              .format(x!)))),
                                    ]);
                                  }),
                                ),
                              ),
                            );
                }),
                SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
      smallScreen: Helper(
        widget: Obx(() {
          if (title == "sales") {
            return salesController.loadingSales.value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : salesController.allSales.isEmpty
                    ? noItemsFound(context, true)
                    : _sales();
          }
          return cashflowController.loadingBankHistory.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : cashflowController.bankTransactions.isEmpty
                  ? noItemsFound(context, true)
                  : _sales();
        }),
        appBar: _appBar("small", context),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            padding: EdgeInsets.all(10),
            height: kToolbarHeight,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: title == "sales"
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total ${title}".capitalize!,
                      style: TextStyle(color: Colors.black),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(20)),
                      child: Obx(() => Text(
                          "${shopController.currentShop.value!.currency!} ${title == "sales" ? salesController.allSalesTotal : cashflowController.totalcashAtBankHistory.value}")),
                    )
                  ],
                ),
                if (title == "sales")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Returned Sales",
                        style: TextStyle(color: Colors.black),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(20)),
                        child: Obx(() => Text(
                            "${shopController.currentShop.value!.currency!} ${title == "sales" ? salesController.totalSalesReturned : cashflowController.totalcashAtBankHistory.value}")),
                      )
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListView _sales() {
    if (title == "sales") {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: salesController.allSales.length,
          itemBuilder: (context, index) {
            SalesModel salesModel = salesController.allSales.elementAt(index);
            return SalesCard(salesModel: salesModel);
          });
    }
    return ListView.builder(
        itemCount: cashflowController.bankTransactions.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          BankTransactions bankTransactions =
              cashflowController.bankTransactions.elementAt(index);
          return bankTransactionsCard(bankTransactions: bankTransactions);
        });
  }

  showBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 150,
              child: Center(
                  child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Container(child: Text('Download As'))],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.file_open_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Container(child: Text('PDF'.toUpperCase()))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.book),
                        SizedBox(
                          width: 10,
                        ),
                        Container(child: Text('Excel'.toUpperCase()))
                      ],
                    ),
                  ),
                ],
              )));
        });
  }

  Widget bankTransactionsCard({required BankTransactions bankTransactions}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.mainColor,
                child: Icon(Icons.check),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    DateFormat("MMM dd yyyy hh:mm a")
                        .format(bankTransactions.createdAt!),
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "@${Get.find<ShopController>().currentShop.value?.currency} ${bankTransactions.amount}",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            ],
          ),
        ),
        Divider(
          thickness: 0.2,
          color: Colors.grey,
        )
      ],
    );
  }

  AppBar _appBar(type, context) {
    return AppBar(
      elevation: 0.3,
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      titleSpacing: 0.0,
      centerTitle: false,
      iconTheme: IconThemeData(color: Colors.black),
      titleTextStyle: TextStyle(color: Colors.black),
      leading: IconButton(
          onPressed: () {
            if (type == "large") {
              if (page == "bank") {
                Get.find<HomeController>().selectedWidget.value = CashAtBank();
              } else {
                Get.find<HomeController>().selectedWidget.value =
                    CashFlowCategories();
              }
            } else {
              Get.back();
            }
          },
          icon: Icon(
            Icons.arrow_back_ios,
          )),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${title}".capitalize!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              )),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
            ),
          )
        ],
      ),
      actions: [
        IconButton(
            onPressed: () async {
              Get.defaultDialog(
                  title: "generating pdf document",
                  contentPadding: const EdgeInsets.all(10),
                  content: const CircularProgressIndicator(),
                  barrierDismissible: false);
              if (title == "sales") {
                if (salesController.allSales.isEmpty) {
                  showSnackBar(
                      message: "No Items to download", color: Colors.black);
                } else {
                  SalesPdf(
                      shop: shopController.currentShop.value!.name!,
                      sales: salesController.allSales,
                      type: "All");
                }
              } else {
                if (cashflowController.bankTransactions.isEmpty) {
                  showSnackBar(
                      message: "No Items to download", color: Colors.black);
                } else {
                  HistoryPdf(
                      shop: shopController.currentShop.value!.name!,
                      name: title,
                      sales: cashflowController.bankTransactions);
                }
              }
              Get.back();
            },
            icon: Icon(Icons.download))
      ],
    );
  }
}
