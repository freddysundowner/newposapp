// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:pointify/Real/schema.dart';
import 'package:pointify/controllers/CustomerController.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/cash_flow/components/loading_shimmer.dart';
import 'package:pointify/screens/finance/financial_page.dart';
import 'package:pointify/utils/colors.dart';
import 'package:pointify/utils/helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/cashflow_controller.dart';
import '../../controllers/expense_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/sales_controller.dart';
import '../../controllers/shop_controller.dart';
import '../home/home_page.dart';
import 'cash_at_bank.dart';
import 'cash_in_layout.dart';
import 'cashflow_categories.dart';
import 'cashout_layout.dart';

class CashFlowManager extends StatelessWidget {
  ShopController shopController = Get.find<ShopController>();
  CashflowController cashFlowController = Get.find<CashflowController>();
  CustomerController customerController = Get.find<CustomerController>();
  ExpenseController expensesController = Get.find<ExpenseController>();
  SalesController salesController = Get.find<SalesController>();
  ProductController productController = Get.find<ProductController>();

  CashFlowManager({Key? key}) : super(key: key) {
    cashFlowController.fromDate.value = DateTime.now();
  }

  Widget transactionWidget(
      {required onPressed,
      required date,
      required name,
      required cashIn,
      required cashOut}) {
    return InkWell(
      onTap: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(date, style: TextStyle(color: Colors.black.withOpacity(0.5))),
          Text(name, style: TextStyle(color: Colors.blue)),
          Text(cashIn, style: TextStyle(color: Colors.black.withOpacity(0.5))),
          Text(cashOut, style: TextStyle(color: Colors.black.withOpacity(0.5))),
        ],
      ),
    );
  }

// sitiweshen  pale bird app
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.3,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleSpacing: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black),
        leading: IconButton(
          onPressed: () {
            if (isSmallScreen(context)) {
              Get.back();
            } else {
              Get.find<HomeController>().selectedWidget.value = HomePage();
            }
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Cash flow",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                )),
            Obx(() {
              return Text(
                shopController.currentShop.value == null
                    ? ""
                    : shopController.currentShop.value!.name!.capitalize!,
                style: TextStyle(
                  fontSize: 10,
                ),
              );
            })
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                // if (cashFlowController.cashflowSummary.value == null) {
                //   showSnackBar(
                //       message: "no data to display", color: Colors.black);
                // } else {
                //   CashFlowPdf(
                //       shop: shopController.currentShop.value!.name,
                //       type: "type",
                //       currency: shopController.currentShop.value!.currency,
                //       cashflowSummary: cashFlowController.cashflowSummary.value!,
                //       date: DateFormat("MM-dd-yyyy")
                //           .format(cashFlowController.fromDate.value));
                // }
              },
              icon: Icon(Icons.download))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            cashInHandWidget(context, "small"),
            cashFlowCategory(context),
            dataTable(context),
          ],
        ),
      ),
    );
  }

  Widget cashTotals(String size) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: size == "large"
          ? MainAxisAlignment.center
          : MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            Text("Total CashIn"),
            Obx(() {
              return cashFlowController.loadingCashflowSummry.value
                  ? cashFlowloadingShimmer()
                  : Text(htmlPrice(cashFlowController.totalCashIn.value),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12));
            })
          ],
        ),
        if (size == "large") Spacer(),
        Column(
          children: [
            Text("Total CashOut"),
            Obx(() {
              return cashFlowController.loadingCashflowSummry.value
                  ? cashFlowloadingShimmer()
                  : Text(htmlPrice(cashFlowController.totalCashOut.value),
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 12));
            })
          ],
        )
      ],
    );
  }

  Widget cashInHandWidget(context, type) {
    return Container(
      width: type == "small"
          ? double.infinity
          : MediaQuery.of(context).size.width * 0.5,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: Column(
        children: [
          SizedBox(height: 5),
          Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(" From "),
                      Row(
                        children: [
                          Obx(
                            () => Text(DateFormat("dd-MM-yyyy")
                                .format(cashFlowController.fromDate.value)),
                          ),
                        ],
                      ),
                      Text(" to "),
                      Row(
                        children: [
                          Obx(
                            () => Text(DateFormat("dd-MM-yyyy")
                                .format(cashFlowController.toDate.value)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      final picked = await showDateRangePicker(
                          context: context,
                          lastDate: DateTime(2079),
                          firstDate: DateTime(2019),
                          builder: (context, child) {
                            return Column(
                              children: [
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    maxWidth: MediaQuery.of(context).size.width,
                                  ),
                                  child: Container(
                                      margin: EdgeInsets.only(
                                          left: isSmallScreen(context)
                                              ? 0
                                              : MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.2,
                                         ),
                                      child: child),
                                )
                              ],
                            );
                          });

                      print(picked);
                      cashFlowController.fromDate.value = picked!.start;
                      cashFlowController.toDate.value = picked.end;
                      cashFlowController.getCashflowSummary(
                        shopId:
                            Get.find<ShopController>().currentShop.value!.id,
                        from: DateTime.parse(
                            DateFormat("yyyy-MM-dd").format(picked.start)),
                        to: DateTime.parse(
                                DateFormat("yyyy-MM-dd").format(picked.end))
                            .add(Duration(days: 1)),
                      );
                    },
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      decoration: BoxDecoration(
                          border: Border.all(color: AppColors.mainColor),
                          borderRadius: BorderRadius.circular(5)),
                      child: Text("Filter"),
                    ),
                  )
                ],
              ),
              Divider(
                color: AppColors.mainColor,
              )
            ],
          ),
          SizedBox(height: 10),
          Center(child: Text("Cash In Hand")),
          SizedBox(height: 10),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  return Text(
                    htmlPrice(cashFlowController.cashatHand),
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  );
                }),
              ],
            ),
          ),
          SizedBox(height: 10),
          Obx(() {
            return Padding(
              padding: const EdgeInsets.only(left: 30.0, right: 30),
              child: InkWell(
                onTap: () {
                  if (isSmallScreen(context)) {
                    Get.to(() => CashAtBank());
                  } else {
                    Get.find<HomeController>().selectedWidget.value =
                        CashAtBank();
                  }
                },
                splashColor: Theme.of(context).splashColor,
                child: Container(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10)),
                  child: Column(
                    children: [
                      Text(
                        "Cash At Bank",
                        style: TextStyle(color: Colors.black54),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            shopController.currentShop.value!.currency!,
                            style: TextStyle(color: Colors.black54),
                          ),
                          SizedBox(width: 3),
                          Text(
                            "${htmlPrice(cashFlowController.totalcashAtBankHistory.value)} /=",
                            style: TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  if (!isSmallScreen(context)) {
                    Get.find<HomeController>().selectedWidget.value =
                        CashInLayout();
                  } else {
                    Get.to(() => CashInLayout());
                  }
                },
                child: Container(
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    "Add Cash In",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  if (!isSmallScreen(context)) {
                    Get.find<HomeController>().selectedWidget.value =
                        CashOutLayout(date: cashFlowController.fromDate.value);
                  } else {
                    Get.to(() =>
                        CashOutLayout(date: cashFlowController.fromDate.value));
                  }
                },
                child: Container(
                  padding:
                      EdgeInsets.only(top: 5, bottom: 5, left: 10, right: 10),
                  decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20)),
                  child: Text(
                    "Add Cash Out",
                    style: TextStyle(color: Colors.redAccent),
                  ),
                ),
              )
            ],
          ),
          SizedBox(height: 3),
        ],
      ),
    );
  }

  Widget cashFlowCategory(context) {
    return InkWell(
      onTap: () {
        if (isSmallScreen(context)) {
          Get.to(CashFlowCategories());
        } else {
          Get.find<HomeController>().selectedWidget.value =
              CashFlowCategories();
        }
      },
      child: Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Categories",
                  style: TextStyle(color: Colors.black),
                ),
                Text(
                  "Manage Cashflow Categories",
                  style: TextStyle(color: Colors.grey),
                )
              ],
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.black,
            )
          ],
        ),
      ),
    );
  }

  _displayDate({int? date}) => date != null
      ? Text(
          DateFormat("dd-MMM-yyyy")
              .format(DateTime.fromMillisecondsSinceEpoch(date)),
          style: TextStyle(fontSize: 11),
        )
      : Text(
          DateFormat("MMM-yyyy").format(cashFlowController.fromDate.value),
          style: TextStyle(fontSize: 11),
        );

  Widget dataTable(context) {
    return Obx(() {
      return Column(
        children: [
          Container(
            height: 250,
            width: MediaQuery.of(context).size.width,
            child: DataTable(
                // Datatable widget that have the property columns and rows.
                columns: [
                  // Set the name of the colum
                  DataColumn(
                    label: Text('Date'),
                  ),
                  DataColumn(
                    label: Text('Name'),
                  ),
                  DataColumn(
                    label: Text('In'),
                  ),
                  DataColumn(
                    label: Text('Out'),
                  ),
                ],
                rows: [
                  // Set the values to the columns
                  DataRow(cells: [
                    DataCell(_displayDate()),
                    DataCell(
                        Text("Sales",
                            style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold)),
                        onTap: () {}),
                    DataCell(cashFlowController.loadingCashflowSummry.value
                        ? cashFlowloadingShimmer()
                        : Text(salesController.allSalesTotal.toString())),
                    DataCell(Text("")),
                  ]),
                  DataRow(cells: [
                    DataCell(_displayDate()),
                    DataCell(
                        Text(
                          "Stock Purchase",
                          style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {}),
                    DataCell(Text("")),
                    DataCell(cashFlowController.loadingCashflowSummry.value
                        ? cashFlowloadingShimmer()
                        : Text(
                            cashFlowController.purchasedItemsTotal.toString())),
                  ]),
                  DataRow(cells: [
                    DataCell(_displayDate()),
                    DataCell(
                        Text(
                          "Expenses",
                          style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {}),
                    DataCell(Text("")),
                    DataCell(cashFlowController.loadingCashflowSummry.value
                        ? cashFlowloadingShimmer()
                        : Text(expensesController.totalExpenses.toString())),
                  ]),
                  DataRow(cells: [
                    DataCell(_displayDate()),
                    DataCell(
                        Text(
                          "Customer Wallets",
                          style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold),
                        ),
                        onTap: () {}),
                    DataCell(cashFlowController.loadingCashflowSummry.value
                        ? cashFlowloadingShimmer()
                        : Text(customerController.walletbalancessTotal
                            .toString())),
                    DataCell(Text("")),
                  ]),
                  // DataRow(cells: [
                  //   DataCell(_displayDate()),
                  //   DataCell(
                  //       Text(
                  //         "Banked",
                  //         style: TextStyle(
                  //             color: Colors.purple,
                  //             fontWeight: FontWeight.bold),
                  //       ),
                  //       onTap: () {}),
                  //   DataCell(Text("")),
                  //   DataCell(cashFlowController.loadingCashflowSummry.value
                  //       ? cashFlowloadingShimmer()
                  //       : Text(cashFlowController.totalcashAtBankHistory
                  //           .toString())),
                  // ]),
                ]),
          ),
          Divider(),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            height: 300,
            // margin: EdgeInsets.only(top: 30),
            child: ListView.separated(
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                CashFlowTransaction c =
                    cashFlowController.cashflowTransactions[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _displayDate(date: c.date),
                    SizedBox(
                      width: 60,
                    ),
                    Text(
                      c.description ?? "",
                      style: TextStyle(
                          color: Colors.purple, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.start,
                    ),
                    Spacer(),
                    if (c.type == "cash-in")
                      Expanded(
                        child: Row(
                          children: [
                            Text(c.amount.toString()),
                            Text(""),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                      ),
                    if (c.type == "cash-out")
                      Expanded(
                        child: Row(
                          children: [
                            Text(""),
                            Text(c.amount.toString()),
                          ],
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        ),
                      ),
                    // Row(
                    //   crossAxisAlignment: c.type == "cash-in"
                    //       ? CrossAxisAlignment.end
                    //       : CrossAxisAlignment.start,
                    //   children: [Text(c.amount.toString()), Text("")],
                    // )
                  ],
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return Divider();
              },
              itemCount: cashFlowController.cashflowTransactions.length,
            ),
          )
        ],
      );
    });
  }
}
