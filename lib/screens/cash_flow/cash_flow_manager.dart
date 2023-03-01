// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:flutterpos/utils/helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/cashflow_controller.dart';
import '../../controllers/expense_controller.dart';
import '../../controllers/product_controller.dart';
import '../../controllers/sales_controller.dart';
import '../../controllers/shop_controller.dart';
import 'cash_at_bank.dart';
import 'cash_in_layout.dart';
import 'cashflow_categories.dart';
import 'cashout_layout.dart';

class CashFlowManager extends StatelessWidget {
  CashFlowManager({Key? key}) : super(key: key) {
    cashFlowController
        .fetchCashAtBank(createShopController.currentShop.value!.id);
  }

  ShopController createShopController = Get.find<ShopController>();
  CashflowController cashFlowController = Get.find<CashflowController>();
  ExpenseController expensesController = Get.find<ExpenseController>();
  SalesController salesController = Get.find<SalesController>();
  ProductController productController = Get.find<ProductController>();

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

  @override
  Widget build(BuildContext context) {
    return Helper(
        widget: RefreshIndicator(
          onRefresh: () async {
            print("hello");
          },
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white),
                  child: Column(
                    children: [
                      SizedBox(height: 10),
                      Center(child: Text("Cash In Hand")),
                      SizedBox(height: 10),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "KES ${20} /=",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Obx(() {
                        return cashFlowController.loadingCashAtBank.value
                            ? Center(
                                child: Text(
                                  "Calculating...",
                                  style: TextStyle(color: AppColors.mainColor),
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(
                                    left: 30.0, right: 30),
                                child: InkWell(
                                  onTap: () {
                                    Get.to(CashAtBank());
                                  },
                                  splashColor: Theme.of(context).splashColor,
                                  child: Container(
                                    padding: EdgeInsets.only(
                                        left: 20,
                                        right: 20,
                                        top: 10,
                                        bottom: 10),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.1),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Cash At Bank",
                                          style:
                                              TextStyle(color: Colors.black54),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "KES",
                                              style: TextStyle(
                                                  color: Colors.black54),
                                            ),
                                            SizedBox(width: 3),
                                            Text(
                                              "${200} /=",
                                              style: TextStyle(
                                                  color: Colors.black),
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
                              Get.to(() => CashInLayout());
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 5, bottom: 5, left: 10, right: 10),
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
                              Get.to(() => CashOutLayout());
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  top: 5, bottom: 5, left: 10, right: 10),
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
                ),
                GestureDetector(
                  onTap: () {
                    Get.to(CashFlowCategories());
                  },
                  child: Container(
                    margin: EdgeInsets.all(10),
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
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
                ),
                DataTable(
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
                        label: Text('Total'),
                      ),
                    ], rows: [
                  // Set the values to the columns
                  DataRow(cells: [
                    DataCell(Text(
                        "${DateFormat("MMM-yyyy").format(DateTime.now())}")),
                    DataCell(
                        Text("Sales",
                            style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold)), onTap: () {
                      print('row 1 pressed');
                    }),
                    DataCell(Text("300")),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(
                        "${DateFormat("MMM-yyyy").format(DateTime.now())}")),
                    DataCell(
                        Text(
                          "Stock Purchase",
                          style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold),
                        ), onTap: () {
                      print('row 2 pressed');
                    }),
                    DataCell(Text("300")),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(
                        "${DateFormat("MMM-yyyy").format(DateTime.now())}")),
                    DataCell(
                        Text(
                          "Expenses",
                          style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold),
                        ), onTap: () {
                      print('row 3 pressed');
                    }),
                    DataCell(Text("300")),
                  ]),
                  DataRow(cells: [
                    DataCell(Text(
                        "${DateFormat("MMM-yyyy").format(DateTime.now())}")),
                    DataCell(
                        Text(
                          "Customer Wallet",
                          style: TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold),
                        ), onTap: () {
                      print('row 4 pressed');
                    }),
                    DataCell(Text("300")),
                  ]),
                ]),
              ],
            ),
          ),
        ),
        appBar: AppBar(
          elevation: 0.3,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          titleSpacing: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black),
          leading: IconButton(
            onPressed: () {
              Get.back();
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
                  createShopController.currentShop.value == null
                      ? ""
                      : "${createShopController.currentShop.value!.name!}"
                          .capitalize!,
                  style: TextStyle(
                    fontSize: 10,
                  ),
                );
              })
            ],
          ),
          actions: [
            InkWell(
              onTap: () {
                // cashFlowController.showDatePicker(context: context);
              },
              child: Row(
                children: [
                  Text("${DateFormat("MMM-yyyy").format(DateTime.now())}"),
                  SizedBox(width: 3),
                  Icon(Icons.arrow_drop_down)
                ],
              ),
            ),
            IconButton(onPressed: () {}, icon: Icon(Icons.download))
          ],
        ),
        bottomNavigationBar: BottomAppBar(
          child: Container(
            height: kToolbarHeight,
            padding: EdgeInsets.all(10),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Text("Total CashIn"),
                    Text("KES ${300}",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12))
                  ],
                ),
                Column(
                  children: [
                    Text("Total CashOut"),
                    Text("KES ${200}",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
