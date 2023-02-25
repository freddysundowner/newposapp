// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/cashflow_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/shop_controller.dart';

class CashOutLayout extends StatelessWidget {
  CashOutLayout({Key? key}) : super(key: key);
  CashflowController cashFlowController = Get.find<CashflowController>();
  ShopController createShopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    // cashOutController.getCategoriesByType(
    //     createShopController.currentShop.value?.id, "cash-out");
    // cashOutController.getBankNames();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.3,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleSpacing: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black),
        title: Text("Add Cash Out"),
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back_ios)),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
              padding: const EdgeInsets.all(20.0),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(5)),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Category",
                                  style: TextStyle(color: Colors.grey)),
                              SizedBox(height: 2),
                              InkWell(
                                onTap: () {
                                  if (cashFlowController.categories.length ==
                                      0) {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            content: Text(
                                                "Add Category to continue."),
                                            actions: [
                                              TextButton(
                                                child: Text("OK"),
                                                onPressed: () {
                                                  Get.back();
                                                },
                                              )
                                            ],
                                          );
                                        });
                                  }
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return SimpleDialog(
                                          children: List.generate(
                                              cashFlowController
                                                  .categories.length,
                                              (index) => SimpleDialogOption(
                                                    onPressed: () {
                                                      // cashFlowController
                                                      //     .changeSelectedCashOut(
                                                      //         "${cashFlowController.categories.elementAt(index).name}",
                                                      //         "${cashFlowController.categories.elementAt(index).id}");
                                                      //
                                                      // if (index == 0) {
                                                      //   cashFlowController
                                                      //       .getBankNames();
                                                      // }
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text(
                                                        "${cashFlowController.categories.elementAt(index).name}"),
                                                  )),
                                        );
                                      });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.grey,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Banks"),
                                      Icon(Icons.arrow_drop_down,
                                          color: Colors.grey)
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: TextButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        title: Text("Add Category"),
                                        content: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: TextFormField(
                                              decoration: InputDecoration(
                                                  hintText: "eg.Personaal use etc",
                                                  border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                  ))),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Cancel".toUpperCase(),
                                              style: TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Save now".toUpperCase(),
                                              style: TextStyle(color: Colors.blue),
                                            ),
                                          ),
                                        ],
                                      );
                                    });
                              },
                              child: Container(
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: Colors.grey.withOpacity(0.2),
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10))),
                                  child: Text(
                                    "+ Add",
                                    style: TextStyle(color: Colors.green),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5),

                      // Row(
                      //         children: [
                      //           Expanded(
                      //             flex: 3,
                      //             child: Column(
                      //               crossAxisAlignment:
                      //                   CrossAxisAlignment.start,
                      //               children: [
                      //                 Text("Select Bank",
                      //                     style: TextStyle(color: Colors.grey)),
                      //                 InkWell(
                      //                   onTap: () {
                      //                     if (cashFlowController
                      //                             .banksLists.length ==
                      //                         0) {
                      //                       showDialog(
                      //                           context: context,
                      //                           builder:
                      //                               (BuildContext context) {
                      //                             return AlertDialog(
                      //                               content: Text(
                      //                                   "Add bank to continue."),
                      //                               actions: [
                      //                                 TextButton(
                      //                                   child: Text("OK"),
                      //                                   onPressed: () {
                      //                                     Get.back();
                      //                                   },
                      //                                 )
                      //                               ],
                      //                             );
                      //                           });
                      //                     }
                      //                     showDialog(
                      //                         context: context,
                      //                         builder: (context) {
                      //                           return SimpleDialog(
                      //                             children: List.generate(
                      //                                 cashFlowController
                      //                                     .banksLists.length,
                      //                                 (index) =>
                      //                                     SimpleDialogOption(
                      //                                       onPressed: () {
                      //                                         cashFlowController
                      //                                             .changeSelectedBank(
                      //                                                 "${cashFlowController.banksLists.elementAt(index).name}",
                      //                                                 "${cashFlowController.banksLists.elementAt(index).id}");
                      //
                      //                                         Navigator.pop(
                      //                                             context);
                      //                                       },
                      //                                       child: Text(
                      //                                           "${cashFlowController.banksLists.elementAt(index).name}"),
                      //                                     )),
                      //                           );
                      //                         });
                      //                   },
                      //                   child: Container(
                      //                     padding: EdgeInsets.all(8),
                      //                     decoration: BoxDecoration(
                      //                         border: Border.all(
                      //                           color: Colors.grey,
                      //                         ),
                      //                         borderRadius:
                      //                             BorderRadius.circular(10)),
                      //                     child: Row(
                      //                       mainAxisAlignment:
                      //                           MainAxisAlignment.spaceBetween,
                      //                       children: [
                      //                         Text(
                      //                               "Family"),
                      //                         Icon(Icons.arrow_drop_down,
                      //                             color: Colors.grey)
                      //                       ],
                      //                     ),
                      //                   ),
                      //                 ),
                      //               ],
                      //             ),
                      //           ),
                      //           SizedBox(width: 10),
                      //           Expanded(
                      //             flex: 2,
                      //             child: Expanded(
                      //               flex: 2,
                      //               child: Padding(
                      //                 padding: const EdgeInsets.only(top: 10.0),
                      //                 child: TextButton(
                      //                   onPressed: () {
                      //                     showDialog(
                      //                         context: context,
                      //                         builder: (context) {
                      //                           return AlertDialog(
                      //                             title: Text("Add Bank Name"),
                      //                             content: Padding(
                      //                               padding:
                      //                                   const EdgeInsets.all(
                      //                                       5.0),
                      //                               child: TextFormField(
                      //                                   decoration:
                      //                                       InputDecoration(
                      //                                           hintText:
                      //                                               "eg. Equity",
                      //                                           border:
                      //                                               OutlineInputBorder(
                      //                                             borderRadius:
                      //                                                 BorderRadius
                      //                                                     .circular(
                      //                                                         10),
                      //                                           ))),
                      //                             ),
                      //                             actions: [
                      //                               TextButton(
                      //                                 onPressed: () {
                      //                                   Navigator.pop(context);
                      //                                 },
                      //                                 child: Text(
                      //                                   "Cancel".toUpperCase(),
                      //                                   style: TextStyle(
                      //                                       color: Colors.blue),
                      //                                 ),
                      //                               ),
                      //                               TextButton(
                      //                                 onPressed: () {
                      //                                   Navigator.pop(context);
                      //
                      //                                 },
                      //                                 child: Text(
                      //                                   "Save now"
                      //                                       .toUpperCase(),
                      //                                   style: TextStyle(
                      //                                       color: Colors.blue),
                      //                                 ),
                      //                               ),
                      //                             ],
                      //                           );
                      //                         });
                      //                   },
                      //                   child: Container(
                      //                       padding: EdgeInsets.all(8),
                      //                       decoration: BoxDecoration(
                      //                           color: Colors.grey
                      //                               .withOpacity(0.2),
                      //                           borderRadius: BorderRadius.only(
                      //                               topRight:
                      //                                   Radius.circular(10),
                      //                               bottomRight:
                      //                                   Radius.circular(10))),
                      //                       child: Text(
                      //                         "+ Add",
                      //                         style: TextStyle(
                      //                             color: Colors.green),
                      //                       )),
                      //                 ),
                      //               ),
                      //             ),
                      //           ),
                      //         ],
                      //       )
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                  Text("Name",
                                      style: TextStyle(color: Colors.grey)),
                                  SizedBox(height: 2),
                                  TextField(
                                    decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: Colors.grey),
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                  ),
                                  SizedBox(height: 5)
                                ]),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Amount",
                                  style: TextStyle(color: Colors.grey)),
                              TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Date",
                                  style: TextStyle(color: Colors.grey)),
                              TextField(
                                decoration: InputDecoration(
                                    hintText:
                                        "${DateFormat("dd-MMM-yyyy").format(DateTime.now())}",
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          child: Container(
        height: kToolbarHeight,
        width: double.infinity,
        child: Row(
          children: [
            Expanded(
                child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Container(
                  height: kToolbarHeight,
                  color: Colors.white,
                  child: Center(
                      child: Text(
                    "Close",
                    style: TextStyle(color: Colors.blue),
                  ))),
            )),
            Expanded(
                child: InkWell(
              onTap: () {},
              child: Container(
                  height: kToolbarHeight,
                  color: Colors.yellow,
                  child: Center(
                      child:
                          Text("Save", style: TextStyle(color: Colors.white)))),
            ))
          ],
        ),
      )),
    );
  }
}
