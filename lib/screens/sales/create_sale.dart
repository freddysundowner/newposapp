import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:get/get.dart';

import '../../controllers/AuthController.dart';
import '../../controllers/CustomerController.dart';
import '../../controllers/sales_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/sales_card.dart';
import '../../widgets/smalltext.dart';
import '../customers/create_customers.dart';
import '../product/product_selection.dart';

class CreateSale extends StatelessWidget {
  CreateSale({Key? key}) : super(key: key);
  SalesController salesController = Get.find<SalesController>();
  ShopController createShopController = Get.find<ShopController>();
  CustomerController customersController = Get.find<CustomerController>();
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    customersController
        .getCustomerById(createShopController.currentShop.value?.id);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.3,
        titleSpacing: 0.0,
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        title:
            majorTitle(title: "Make New Sale", color: Colors.black, size: 18.0),
      ),
      body: Stack(
        children: [
          Obx(() {
            return salesController.selectedList.length == 0
                ? Center(
                    child: minorTitle(
                      title: "No products selected for sale",
                      color: Colors.black,
                    ),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: kToolbarHeight,
                        ),
                        ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: salesController.selectedList.length,
                            itemBuilder: (context, index) {
                              ProductModel productModel =
                                  salesController.selectedList.elementAt(index);
                              return SalesContainer(
                                  context: context,
                                  productModel: productModel,
                                  index: index);
                            }),
                      ],
                    ),
                  );
          }),
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Material(
                elevation: 1,
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  // height: kToolbarHeight*2,
                  padding: EdgeInsets.fromLTRB(5, 0, 5, 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),

                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.to(() => ProductSelection(
                                      type: "sales",
                                      shopId: createShopController
                                          .currentShop.value?.id,
                                    ));
                              },
                              child: Container(
                                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("Select products to sell"),
                                    Icon(Icons.arrow_drop_down,
                                        color: Colors.grey)
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      // SizedBox(height: 10),
                      // majorTitle(title: "Selling", color: Colors.black, size: 18.0),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ))
        ],
      ),
      bottomNavigationBar: Obx(() {
        return BottomAppBar(
          color: Colors.white,
          child: salesController.selectedList.length == 0
              ? Container(height: 0)
              : Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(10),
                  height: kToolbarHeight * 1.5,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey)),
                  child: salesController.saveSaleLoad.value
                      ? Center(child: CircularProgressIndicator())
                      : InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            if (salesController.selectedList.length == 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  new SnackBar(
                                      content: Text(
                                          "Please select products to sell")));
                            } else {
                              showDialog(
                                  context: context,
                                  builder: (_) {
                                    return AlertDialog(
                                      contentPadding:EdgeInsets.only(bottom: 0.0,left: 20,right: 20) ,
                                      title: Center(
                                          child: Text("Confirm Payment")),
                                      content: Obx(() {
                                        return SingleChildScrollView(
                                          child: Container(
                                            height: salesController
                                                        .selectedPaymentMethod
                                                        .value ==
                                                    "Credit"
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.65
                                                : MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.6,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        majorTitle(
                                                            title: "Items",
                                                            color: Colors.black,
                                                            size: 16.0),
                                                        SizedBox(height: 10),
                                                        minorTitle(
                                                            title:
                                                                "${salesController.selectedList.length}",
                                                            color: Colors.grey)
                                                      ],
                                                    ),
                                                    SizedBox(width: 10),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        majorTitle(
                                                            title: "Total",
                                                            color: Colors.black,
                                                            size: 16.0),
                                                        SizedBox(height: 10),
                                                        minorTitle(
                                                            title:
                                                                "${salesController.grandTotal.value}",
                                                            color: Colors.grey)
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                majorTitle(
                                                    title: "Paywith",
                                                    color: Colors.black,
                                                    size: 16.0),
                                                Obx(() {
                                                  return ListTile(
                                                    title: const Text('Cash'),
                                                    dense: true,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 0.0,
                                                            vertical: 0.0),
                                                    visualDensity:
                                                        VisualDensity(
                                                            horizontal: 0,
                                                            vertical: -4),
                                                    leading: Radio(
                                                      value: "Cash",
                                                      groupValue: salesController
                                                          .selectedPaymentMethod
                                                          .value,
                                                      onChanged: (value) {
                                                        salesController
                                                                .selectedPaymentMethod
                                                                .value =
                                                            value.toString();
                                                      },
                                                    ),
                                                  );
                                                }),
                                                Obx(() {
                                                  return ListTile(
                                                    title: const Text('Credit'),
                                                    dense: true,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 0.0,
                                                            vertical: 0.0),
                                                    visualDensity:
                                                        VisualDensity(
                                                            horizontal: 0,
                                                            vertical: -4),
                                                    leading: Radio(
                                                      value: "Credit",
                                                      groupValue: salesController
                                                          .selectedPaymentMethod
                                                          .value,
                                                      onChanged: (value) {
                                                        salesController
                                                                .selectedPaymentMethod
                                                                .value =
                                                            value.toString();
                                                        salesController
                                                            .textEditingCredit
                                                            .text = "0";
                                                        salesController
                                                                .balance.value =
                                                            salesController
                                                                .grandTotal
                                                                .value;
                                                      },
                                                    ),
                                                  );
                                                }),
                                                Obx(() {
                                                  return ListTile(
                                                    title: const Text('Wallet'),
                                                    dense: true,
                                                    contentPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 0.0,
                                                            vertical: 0.0),
                                                    visualDensity:
                                                        VisualDensity(
                                                            horizontal: 0,
                                                            vertical: -4),
                                                    leading: Radio(
                                                      value: "Wallet",
                                                      groupValue: salesController
                                                          .selectedPaymentMethod
                                                          .value,
                                                      onChanged: (value) {
                                                        salesController
                                                                .selectedPaymentMethod
                                                                .value =
                                                            value.toString();
                                                      },
                                                    ),
                                                  );
                                                }),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Obx(() {
                                                  return salesController
                                                              .selectedPaymentMethod
                                                              .value ==
                                                          "Credit"
                                                      ? Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Expanded(
                                                              flex: 3,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  minorTitle(
                                                                      title:
                                                                          "Amount ",
                                                                      color: Colors
                                                                          .black),
                                                                  TextFormField(
                                                                    keyboardType: TextInputType.number,
                                                                    controller:
                                                                        salesController
                                                                            .textEditingCredit,
                                                                    onChanged:
                                                                        (value) {
                                                                      if (int.parse(
                                                                              value) >
                                                                          salesController
                                                                              .grandTotal
                                                                              .value) {
                                                                        salesController.textEditingCredit.text = salesController
                                                                            .grandTotal
                                                                            .value
                                                                            .toString();
                                                                        salesController
                                                                            .balance
                                                                            .value = 0;
                                                                      } else if (salesController
                                                                              .textEditingCredit
                                                                              .text ==
                                                                          "") {
                                                                        salesController
                                                                            .balance
                                                                            .value = salesController.grandTotal.value;
                                                                      } else {
                                                                        salesController
                                                                            .balance
                                                                            .value = salesController
                                                                                .grandTotal.value -
                                                                            int.parse(value);
                                                                      }
                                                                    },
                                                                    decoration: InputDecoration(
                                                                        isDense:
                                                                            true,
                                                                        contentPadding: EdgeInsets.fromLTRB(
                                                                            10,
                                                                            10,
                                                                            10,
                                                                            0),
                                                                        border: OutlineInputBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(20))),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            Spacer(),
                                                            Expanded(
                                                              flex: 2,
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  majorTitle(
                                                                      title:
                                                                          "Balance",
                                                                      color: Colors
                                                                          .black,
                                                                      size:
                                                                          13.0),
                                                                  Obx(() {
                                                                    return minorTitle(
                                                                        title: salesController
                                                                            .balance
                                                                            .value,
                                                                        color: Colors
                                                                            .grey);
                                                                  })
                                                                ],
                                                              ),
                                                            )
                                                          ],
                                                        )
                                                      : Container();
                                                }),
                                                SizedBox(height: 10),
                                                majorTitle(
                                                    title: "Select Customer",
                                                    color: Colors.black,
                                                    size: 14.0),
                                                SizedBox(height: 10),
                                                Flexible(
                                                  child: InkWell(
                                                    onTap: () {
                                                      if (customersController
                                                              .customers
                                                              .length ==
                                                          0) {
                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                title: Text(
                                                                    "This Shop Doesn't have customer"),
                                                                content: Text(
                                                                    "Wuould you like to add Customer?"),
                                                                actions: [
                                                                  TextButton(
                                                                    child: Text(
                                                                        "Cancel"),
                                                                    onPressed:
                                                                        () {
                                                                      Get.back();
                                                                    },
                                                                  ),
                                                                  TextButton(
                                                                    child: Text(
                                                                        "OK"),
                                                                    onPressed:
                                                                        () {
                                                                      Get.back();
                                                                      Get.to(() =>
                                                                          CreateCustomer(
                                                                              type: "customers"));
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
                                                                children: List
                                                                    .generate(
                                                                        customersController
                                                                            .customers
                                                                            .length,
                                                                        (index) =>
                                                                            SimpleDialogOption(
                                                                              onPressed: () {
                                                                                salesController.selectedCustomer.value = customersController.customers.elementAt(index).fullName!;
                                                                                salesController.selectedCustomerId.value = customersController.customers.elementAt(index).id!;
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Text("${customersController.customers.elementAt(index).fullName}"),
                                                                            )),
                                                              );
                                                            });
                                                      }
                                                    },
                                                    child: Container(
                                                      padding:
                                                          EdgeInsets.all(10),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(20),
                                                          border: Border.all(
                                                              color:
                                                                  Colors.black,
                                                              width: 2)),
                                                      child: Row(
                                                        children: [
                                                          Obx(() {
                                                            return majorTitle(
                                                                title: salesController
                                                                    .selectedCustomer
                                                                    .value,
                                                                color: Colors
                                                                    .black,
                                                                size: 12.0);
                                                          }),
                                                          Spacer(),
                                                          Icon(Icons
                                                              .arrow_drop_down)
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: majorTitle(
                                                            title: "Cancel",
                                                            color: AppColors
                                                                .mainColor,
                                                            size: 16.0)),
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                          salesController.saveSale(
                                                              screen: "admin",
                                                              attendantsUID:
                                                                  authController
                                                                      .currentUser
                                                                      .value
                                                                      ?.attendantId,
                                                              shopUID:
                                                                  createShopController
                                                                      .currentShop
                                                                      .value
                                                                      ?.id,
                                                              customerId:
                                                                  salesController
                                                                      .selectedCustomerId
                                                                      .value,
                                                              context: context);
                                                        },
                                                        child: majorTitle(
                                                            title: "Pay",
                                                            color: AppColors
                                                                .mainColor,
                                                            size: 16.0))
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      }),
                                    );
                                  });
                            }
                          },
                          child: Container(
                            padding: EdgeInsets.all(10),
                            width: double.infinity,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 3, color: AppColors.mainColor),
                                borderRadius: BorderRadius.circular(40)),
                            child: Center(
                                child: majorTitle(
                                    title: "Proceed To Payment",
                                    color: AppColors.mainColor,
                                    size: 18.0)),
                          ),
                        ),
                ),
        );
      }),
    );
  }
}
