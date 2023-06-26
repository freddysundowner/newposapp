import 'package:flutter/material.dart';
import 'package:pointify/controllers/cashflow_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/cash_flow/cash_at_bank.dart';
import 'package:pointify/screens/cash_flow/cashflow_categories.dart';
import 'package:pointify/utils/helper.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:pointify/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Real/schema.dart';
import '../../utils/colors.dart';
import '../../widgets/sales_card.dart';

class CashCategoryHistory extends StatelessWidget {
  final CashFlowCategory? cashFlowCategory;
  BankModel? bank;
  final page;
  ShopController shopController = Get.find<ShopController>();
  SalesController salesController = Get.find<SalesController>();
  CashflowController cashflowController = Get.find<CashflowController>();

  CashCategoryHistory(
      {Key? key, this.page, required this.cashFlowCategory, this.bank})
      : super(key: key) {
    cashflowController.getCategoryHistory(
        bankModel: bank, cashFlowCategory: cashFlowCategory);
    title = bank != null ? bank!.name! : cashFlowCategory!.name!;
  }
  String title = "";

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
                  return cashflowController.categoryCashflowTransactions.isEmpty
                      ? noItemsFound(context, true)
                      : Container(
                          width: double.infinity,
                          padding:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 10),
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
                                      .categoryCashflowTransactions
                                      .length, (index) {
                                CashFlowTransaction cashFlowTransaction =
                                    cashflowController
                                        .categoryCashflowTransactions
                                        .elementAt(index);
                                final y = cashFlowTransaction.amount;
                                final x = cashFlowTransaction.date;

                                return DataRow(cells: [
                                  DataCell(
                                      Container(child: Text(y.toString()))),
                                  DataCell(Container(
                                      child: Text(DateFormat("yyyy-dd-MM")
                                          .format(DateTime
                                              .fromMillisecondsSinceEpoch(
                                                  x!))))),
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
          if (title == "services") {
            return salesController.allSales.isEmpty
                ? noItemsFound(context, true)
                : _sales();
          }
          return cashflowController.categoryCashflowTransactions.isEmpty
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
              mainAxisAlignment: title == "services"
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
                          "${shopController.currentShop.value!.currency!} ${title == "services" ? salesController.allSalesTotal : cashflowController.categoryCashflowTransactions.fold(0, (previousValue, element) => previousValue + element.amount!)}")),
                    )
                  ],
                ),
                if (title == "services")
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
                            "${shopController.currentShop.value!.currency!} ${title == "services" ? salesController.totalSalesReturned : cashflowController.totalcashAtBankHistory.value}")),
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
    if (title == "services") {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: salesController.allSales.length,
          itemBuilder: (context, index) {
            SalesModel salesModel = salesController.allSales.elementAt(index);
            return SalesCard(salesModel: salesModel);
          });
    }
    return ListView.builder(
        itemCount: cashflowController.categoryCashflowTransactions.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          CashFlowTransaction cashFlowTransaction =
              cashflowController.categoryCashflowTransactions.elementAt(index);
          return bankTransactionsCard(cashFlowTransaction: cashFlowTransaction);
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

  Widget bankTransactionsCard(
      {required CashFlowTransaction cashFlowTransaction}) {
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
                    DateFormat("MMM dd yyyy hh:mm a").format(
                        DateTime.fromMillisecondsSinceEpoch(
                            cashFlowTransaction.date!)),
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "@${htmlPrice(cashFlowTransaction.amount)}",
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
            "All Records",
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
              if (title == "services") {
                if (salesController.allSales.isEmpty) {
                  showSnackBar(
                      message: "No Items to download", color: Colors.black);
                } else {
                  // SalesPdf(
                  //     shop: shopController.currentShop.value!.name!,
                  //     sales: salesController.allSales,
                  //     type: "All");
                }
              } else {
                // if (cashflowController.bankTransactions.isEmpty) {
                //   showSnackBar(
                //       message: "No Items to download", color: Colors.black);
                // } else {
                //   HistoryPdf(
                //       shop: shopController.currentShop.value!.name!,
                //       name: title,
                //       sales: cashflowController.bankTransactions);
                // }
              }
              Get.back();
            },
            icon: Icon(Icons.download))
      ],
    );
  }
}
