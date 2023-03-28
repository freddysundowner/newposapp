// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/cashflow_controller.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/bank_transactions.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/cash_flow/cash_at_bank.dart';
import 'package:flutterpos/screens/cash_flow/cashflow_categories.dart';
import 'package:flutterpos/utils/helper.dart';
import 'package:flutterpos/widgets/no_items_found.dart';
import 'package:flutterpos/widgets/pdf/history_pdf.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/colors.dart';

class CashHistory extends StatelessWidget {
  final title;
  final subtitle;
  final id;
  final page;
  ShopController createShopController = Get.find<ShopController>();
  CashflowController cashflowController = Get.find<CashflowController>();

  CashHistory(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.id,
      required this.page})
      : super(key: key) {
    if (page == "cashflowcategory") {
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
                      : cashflowController.bankTransactions.length == 0
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
                                            'Amount(${createShopController.currentShop.value?.currency})',
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
          return cashflowController.loadingBankHistory.value
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : cashflowController.bankTransactions.length == 0
                  ? noItemsFound(context, true)
                  : ListView.builder(
                      itemCount: cashflowController.bankTransactions.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        BankTransactions bankTransactions = cashflowController
                            .bankTransactions
                            .elementAt(index);
                        return bankTransactionsCard(
                            bankTransactions: bankTransactions);
                      });
        }),
        appBar: _appBar("small", context),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            padding: EdgeInsets.all(10),
            height: kToolbarHeight,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Totals",
                  style: TextStyle(color: Colors.black),
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20)),
                  child: Obx(() => Text(
                      "${createShopController.currentShop.value!.currency!} ${cashflowController.totalcashAtBankHistory.value}")),
                )
              ],
            ),
          ),
        ),
      ),
    );
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
                    "${DateFormat("MMM dd yyyy hh:mm a").format(bankTransactions.createdAt!)}",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "@${bankTransactions.amount}",
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
              if (cashflowController.bankTransactions.length == 0) {
                showSnackBar(
                    message: "No Items to download",
                    color: Colors.black,
                    context: context);
              } else {
                HistoryPdf(
                    shop: createShopController.currentShop.value!.name!,
                    name: title,
                    sales: cashflowController.bankTransactions);
              }
            },
            icon: Icon(Icons.download))
      ],
    );
  }
}
