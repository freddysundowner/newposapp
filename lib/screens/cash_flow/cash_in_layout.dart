// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/cashflow_controller.dart';
import 'package:flutterpos/controllers/category_controller.dart';
import 'package:flutterpos/widgets/snackBars.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/shop_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';

class CashInLayout extends StatelessWidget {
  CashInLayout({Key? key}) : super(key: key);
  ShopController createShopController = Get.find<ShopController>();
  CashflowController cashflowController = Get.find<CashflowController>();
  CategoryController categoryController = Get.find<CategoryController>();

  @override
  Widget build(BuildContext context) {
    categoryController.getCategories(
        createShopController.currentShop.value!.id, "cash-in");
    return WillPopScope(
      onWillPop: () async {
        cashflowController.clearInputs();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.3,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          titleSpacing: 0.0,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black),
          title: Text("Add Cash In ", style: TextStyle(fontSize: 14)),
          leading: IconButton(
              onPressed: () {
                cashflowController.clearInputs();
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)),
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
                                InkWell(
                                  onTap: () {
                                    if (categoryController.categories.length ==
                                            0 &&
                                        !categoryController
                                            .loadingCategories.value) {
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
                                    } else {
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return SimpleDialog(
                                              children: List.generate(
                                                  categoryController
                                                      .categories.length,
                                                  (index) => SimpleDialogOption(
                                                        onPressed: () {
                                                          categoryController
                                                                  .selectedCategory
                                                                  .value =
                                                              categoryController
                                                                  .categories
                                                                  .elementAt(
                                                                      index);
                                                          cashflowController
                                                                  .textEditingControllerName
                                                                  .text =
                                                              categoryController
                                                                  .categories
                                                                  .elementAt(
                                                                      index)
                                                                  .name!;
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            "${categoryController.categories.elementAt(index).name}"),
                                                      )),
                                            );
                                          });
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Obx(() => Text(categoryController
                                                    .selectedCategory.value ==
                                                null
                                            ? "Select Category"
                                            : "${categoryController.selectedCategory.value!.name}")),
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
                                                    hintText:
                                                        "eg.Loan,Capital,Contribution etc",
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              10),
                                                    ))),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Cancel".toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text(
                                                "Save now".toUpperCase(),
                                                style: TextStyle(
                                                    color: Colors.blue),
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
                      Text("Name", style: TextStyle(color: Colors.grey)),
                      SizedBox(height: 2),
                      TextField(
                        controller:
                            cashflowController.textEditingControllerName,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
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
                                  controller: cashflowController
                                      .textEditingControllerAmount,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                  ),
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
                                  enabled: false,
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
          child: InkWell(
            onTap: () {
              if (cashflowController.textEditingControllerName.text.isEmpty ||
                  cashflowController.textEditingControllerAmount.text.isEmpty) {
                showSnackBar(
                    message: "Please fill all fields",
                    color: Colors.black,
                    context: context);
              } else {
                cashflowController.createTransaction(
                    shopId: createShopController.currentShop.value!.id,
                    context: context,
                    type: "cash-in");
              }
            },
            child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(10),
                height: kToolbarHeight * 1.5,
                decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Colors.grey)),
                child: Container(
                  padding: EdgeInsets.all(10),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      border: Border.all(width: 3, color: AppColors.mainColor),
                      borderRadius: BorderRadius.circular(40)),
                  child: Center(
                      child: majorTitle(
                          title: "Save",
                          color: AppColors.mainColor,
                          size: 18.0)),
                )),
          ),
        ),
      ),
    );
  }
}
