import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pointify/controllers/attendant_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/models/product_model.dart';
import 'package:pointify/models/receipt_item.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/home/home_page.dart';
import 'package:pointify/screens/sales/all_sales_page.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:pointify/widgets/search_widget.dart';
import 'package:get/get.dart';

import '../../controllers/AuthController.dart';
import '../../controllers/CustomerController.dart';
import '../../controllers/sales_controller.dart';
import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/sales_container.dart';
import '../../widgets/smalltext.dart';
import '../customers/create_customers.dart';
import '../product/products_screen.dart';
import 'components/discount_dialog.dart';
import 'components/edit_price_dialog.dart';

class CreateSale extends StatelessWidget {
  final String? page;

  CreateSale({Key? key, this.page}) : super(key: key) {
    customersController.getCustomersInShop(
        shopController.currentShop.value?.id, "all");
  }

  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();
  CustomerController customersController = Get.find<CustomerController>();
  AuthController authController = Get.find<AuthController>();
  AttendantController attendantController = Get.find<AttendantController>();
  ProductController productController = Get.find<ProductController>();
  final FocusNode _focusNode = FocusNode();
  final GlobalKey _autocompleteKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        salesController.saleItem.clear();
        return true;
      },
      child: ResponsiveWidget(
        largeScreen: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.3,
            titleSpacing: 0.0,
            centerTitle: false,
            leading: IconButton(
                onPressed: () {
                  salesController.saleItem.clear();
                  if (page == "allSales") {
                    Get.find<HomeController>().selectedWidget.value =
                        AllSalesPage(page: "AttendantLanding");
                  } else {
                    Get.find<HomeController>().selectedWidget.value =
                        HomePage();
                  }
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
            title:
                majorTitle(title: "New Sale", color: Colors.black, size: 18.0),
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.only(left: 30, right: 80),
                  child: searchWidget(
                      autoCompletKey: _autocompleteKey,
                      focusNode: _focusNode,
                      shopId: shopController.currentShop.value?.id,
                      page: "createSale"),
                ),
                Obx(() {
                  return salesController.saleItem.isEmpty
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(right: 30.0, top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Totals:${salesController.grandTotal}"),
                              SizedBox(
                                width: 10,
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                onTap: () {
                                  if (salesController.saleItem.isEmpty) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                "Please select products to sell")));
                                  } else {
                                    salesController.selectedCustomer.value =
                                        null;
                                    salesController
                                        .selectedPaymentMethod.value = "Cash";
                                    customersController.getCustomersInShop(
                                        shopController.currentShop.value?.id,
                                        "all");
                                    confirmPayment(context, "large");
                                  }
                                },
                                child: majorTitle(
                                    title: "Proceed To Payment",
                                    color: AppColors.mainColor,
                                    size: 14.0),
                              )
                            ],
                          ),
                        );
                }),
                const SizedBox(height: 20),
                Obx(() {
                  return productController.getProductLoad.value
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.4),
                            Center(child: CircularProgressIndicator()),
                          ],
                        )
                      : salesController.saleItem.isEmpty
                          ? noItemsFound(context, true)
                          : Container(
                              width: double.infinity,
                              padding: EdgeInsets.symmetric(horizontal: 30),
                              child: Theme(
                                data: Theme.of(context)
                                    .copyWith(dividerColor: Colors.grey),
                                child: DataTable(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    width: 1,
                                    color: Colors.black,
                                  )),
                                  columnSpacing: 50.0,
                                  columns: [
                                    const DataColumn(
                                        label: Text('Product',
                                            textAlign: TextAlign.center)),
                                    DataColumn(
                                        label: Text('Qty',
                                            textAlign: TextAlign.center)),
                                    DataColumn(
                                        label: Text(
                                            'Price(${shopController.currentShop.value?.currency})',
                                            textAlign: TextAlign.center)),
                                    DataColumn(
                                        label: Text('Sale Total',
                                            textAlign: TextAlign.center)),
                                    DataColumn(
                                        label: Text('',
                                            textAlign: TextAlign.center)),
                                  ],
                                  rows: List.generate(
                                      salesController.saleItem.length, (index) {
                                    ReceiptItem receiptItem = salesController
                                        .saleItem
                                        .elementAt(index);
                                    final y = receiptItem.product!.name!;
                                    final x = receiptItem.quantity.toString();
                                    final z = receiptItem.price;
                                    final w = receiptItem.price! *
                                        receiptItem.quantity!;

                                    return DataRow(cells: [
                                      DataCell(
                                          Container(width: 75, child: Text(y))),
                                      DataCell(Container(
                                        child: Row(children: [
                                          IconButton(
                                              onPressed: () {
                                                salesController
                                                    .decrementItem(index);
                                              },
                                              icon: const Icon(Icons.remove,
                                                  color: Colors.black,
                                                  size: 16)),
                                          Container(
                                              padding: EdgeInsets.only(
                                                  top: 5,
                                                  bottom: 5,
                                                  right: 8,
                                                  left: 8),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                border: Border.all(
                                                    color: Colors.black,
                                                    width: 0.1),
                                                color: Colors.grey,
                                              ),
                                              child: majorTitle(
                                                  title:
                                                      "${receiptItem.quantity}",
                                                  color: Colors.black,
                                                  size: 12.0)),
                                          IconButton(
                                              onPressed: () {
                                                salesController
                                                    .incrementItem(index);
                                              },
                                              icon: Icon(Icons.add,
                                                  color: Colors.black,
                                                  size: 16)),
                                        ]),
                                      )),
                                      DataCell(
                                          Container(child: Text(z.toString()))),
                                      DataCell(
                                          Container(child: Text(w.toString()))),
                                      DataCell(
                                        Container(
                                          child: Align(
                                              alignment: Alignment.topRight,
                                              child: showPopUpdialog(
                                                  context: context,
                                                  index: index,
                                                  receiptItem: receiptItem)),
                                        ),
                                      )
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
        smallScreen: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.3,
            titleSpacing: 0.0,
            leading: IconButton(
                onPressed: () {
                  Get.back();
                  salesController.saleItem.clear();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
            title:
                majorTitle(title: "New Sale", color: Colors.black, size: 18.0),
          ),
          body: Stack(
            children: [
              Obx(() {
                return salesController.saleItem.isEmpty
                    ? Center(
                        child: InkWell(
                          onTap: () {
                            Get.to(() => ProductsScreen(
                                  type: "sales",
                                  shopId: shopController.currentShop.value?.id,
                                ));
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Add",
                                style: TextStyle(
                                    color: AppColors.mainColor, fontSize: 21),
                              ),
                              Icon(
                                Icons.add_circle_outline_outlined,
                                size: 60,
                                color: AppColors.mainColor,
                              ),
                            ],
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: kToolbarHeight,
                            ),
                            ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: salesController.saleItem.length,
                                itemBuilder: (context, index) {
                                  ReceiptItem receiptItem =
                                      salesController.saleItem.elementAt(index);
                                  return SalesContainer(
                                      receiptItem: receiptItem,
                                      index: index,
                                      type: "small");
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
                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    Get.to(() => ProductsScreen(
                                          type: "sales",
                                          shopId: shopController
                                              .currentShop.value?.id,
                                        ));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
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
              child: salesController.saleItem.isEmpty
                  ? Container(height: 0)
                  : Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(10),
                      height: kToolbarHeight * 1.5,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: salesController.saveSaleLoad.value
                          ? const Center(child: CircularProgressIndicator())
                          : InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                if (salesController.saleItem.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Please select products to sell")));
                                } else {
                                  salesController.selectedCustomer.value = null;
                                  salesController.selectedPaymentMethod.value =
                                      "Cash";
                                  customersController.getCustomersInShop(
                                      shopController.currentShop.value?.id,
                                      "all");
                                  // confirmPayment(context, "small");
                                  showModalBottomSheet(
                                      context: Get.context!,
                                      builder: (BuildContext c) {
                                        return Obx(() {
                                          return Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                SizedBox(
                                                  height: 20,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
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
                                                                "${salesController.saleItem.length}",
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
                                                            title: htmlPrice(
                                                                salesController
                                                                    .grandTotal
                                                                    .value),
                                                            color: Colors.grey)
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    majorTitle(
                                                        title: "Pay with",
                                                        color: Colors.black,
                                                        size: 16.0),
                                                    Container(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          horizontal: 20),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                              color:
                                                                  Colors.grey),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5)),
                                                      child: InkWell(
                                                        onTap: () {
                                                          showDialog(
                                                              context: context,
                                                              builder:
                                                                  (context) {
                                                                return SimpleDialog(
                                                                  children: List
                                                                      .generate(
                                                                          salesController
                                                                              .paymentMethods
                                                                              .length,
                                                                          (index) =>
                                                                              SimpleDialogOption(
                                                                                onPressed: () {
                                                                                  salesController.selectedPaymentMethod.value = salesController.paymentMethods[index];
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Container(
                                                                                  padding: const EdgeInsets.symmetric(vertical: 5),
                                                                                  child: Text(
                                                                                    "${salesController.paymentMethods[index]}",
                                                                                    style: const TextStyle(fontSize: 18),
                                                                                  ),
                                                                                ),
                                                                              )),
                                                                );
                                                              });
                                                        },
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Obx(
                                                              () => Text(
                                                                  salesController
                                                                      .selectedPaymentMethod
                                                                      .value),
                                                            ),
                                                            const Icon(Icons
                                                                .arrow_drop_down)
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                const SizedBox(height: 20),
                                                if (customersController
                                                    .customers.isEmpty)
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(() =>
                                                          CreateCustomer(
                                                              page:
                                                                  "createSale"));
                                                    },
                                                    child: Text(
                                                      "Add Customer",
                                                      style: TextStyle(
                                                          color: AppColors
                                                              .mainColor),
                                                    ),
                                                  ),
                                                majorTitle(
                                                    title: "Paid Amount",
                                                    color: Colors.black,
                                                    size: 14.0),
                                                SizedBox(height: 10),
                                                TextFormField(
                                                    controller:
                                                        customersController
                                                            .amountpaid,
                                                    onChanged: (value) {
                                                      salesController
                                                          .changeTotal
                                                          .value = int.parse(
                                                              customersController
                                                                  .amountpaid
                                                                  .text) -
                                                          salesController
                                                              .grandTotal.value;
                                                    },
                                                    keyboardType:
                                                        TextInputType.number,
                                                    autofocus: true,
                                                    decoration: InputDecoration(
                                                        contentPadding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10),
                                                        border:
                                                            OutlineInputBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(10),
                                                        ),
                                                        prefix: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  right: 10),
                                                          child: Text(
                                                              shopController
                                                                  .currentShop
                                                                  .value!
                                                                  .currency!),
                                                        ))),
                                                SizedBox(height: 10),
                                                majorTitle(
                                                    title:
                                                        "Balance: ${htmlPrice(salesController.changeTotal.value)}",
                                                    color: Colors.black,
                                                    size: 14.0),
                                                SizedBox(height: 10),
                                                if ((salesController
                                                                .selectedPaymentMethod
                                                                .value ==
                                                            "Wallet" ||
                                                        salesController
                                                                .selectedPaymentMethod
                                                                .value ==
                                                            "Credit") &&
                                                    customersController
                                                        .customers.isNotEmpty)
                                                  Expanded(
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        majorTitle(
                                                            title:
                                                                "Choose Customer",
                                                            color: Colors.black,
                                                            size: 14.0),
                                                        SizedBox(height: 10),
                                                        Flexible(
                                                          child: InkWell(
                                                            onTap: () {
                                                              if (customersController
                                                                  .customers
                                                                  .isEmpty) {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return AlertDialog(
                                                                        title: const Text(
                                                                            "This Shop Doesn't have customer"),
                                                                        content:
                                                                            const Text("Would you like to add Customer?"),
                                                                        actions: [
                                                                          TextButton(
                                                                            child:
                                                                                const Text("Cancel"),
                                                                            onPressed:
                                                                                () {
                                                                              Get.back();
                                                                            },
                                                                          ),
                                                                          TextButton(
                                                                            child:
                                                                                Text("OK"),
                                                                            onPressed:
                                                                                () {
                                                                              Get.back();
                                                                              Get.to(() => CreateCustomer(page: "createSale"));
                                                                            },
                                                                          )
                                                                        ],
                                                                      );
                                                                    });
                                                              } else {
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      return SimpleDialog(
                                                                        children: List.generate(
                                                                            customersController.customers.length,
                                                                            (index) => SimpleDialogOption(
                                                                                  onPressed: () {
                                                                                    salesController.selectedCustomer.value = customersController.customers.elementAt(index);
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
                                                                  EdgeInsets
                                                                      .all(10),
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              10),
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .grey)),
                                                              child: Row(
                                                                children: [
                                                                  Obx(() {
                                                                    return majorTitle(
                                                                        title: salesController.selectedCustomer.value ==
                                                                                null
                                                                            ? ""
                                                                            : salesController
                                                                                .selectedCustomer.value!.fullName!,
                                                                        color: Colors
                                                                            .black,
                                                                        size:
                                                                            12.0);
                                                                  }),
                                                                  Spacer(),
                                                                  const Icon(Icons
                                                                      .arrow_drop_down)
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                      ],
                                                    ),
                                                  ),
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
                                                          salesController.saveSale(
                                                              screen: page ??
                                                                  "admin",
                                                              attendantsUID: page ==
                                                                      "allSales"
                                                                  ? attendantController
                                                                      .attendant
                                                                      .value!
                                                                      .id
                                                                  : authController
                                                                      .currentUser
                                                                      .value
                                                                      ?.attendantId,
                                                              context: context);
                                                        },
                                                        child: majorTitle(
                                                            title: "Pay",
                                                            color: AppColors
                                                                .mainColor,
                                                            size: 16.0)),
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                              ],
                                            ),
                                          );
                                        });
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
        ),
      ),
    );
  }

  confirmPayment(context, type) {
    return showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            contentPadding:
                const EdgeInsets.only(bottom: 0.0, left: 20, right: 20),
            title: const Center(
                child: Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: Text("Confirm Payment"),
            )),
            content: Obx(() {
              return SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              majorTitle(
                                  title: "Items",
                                  color: Colors.black,
                                  size: 16.0),
                              SizedBox(height: 10),
                              minorTitle(
                                  title: "${salesController.saleItem.length}",
                                  color: Colors.grey)
                            ],
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              majorTitle(
                                  title: "Total",
                                  color: Colors.black,
                                  size: 16.0),
                              SizedBox(height: 10),
                              minorTitle(
                                  title:
                                      "${shopController.currentShop.value?.currency} ${salesController.grandTotal.value}",
                                  color: Colors.grey)
                            ],
                          )
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          majorTitle(
                              title: "Pay with",
                              color: Colors.black,
                              size: 16.0),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.grey),
                                borderRadius: BorderRadius.circular(5)),
                            child: InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return SimpleDialog(
                                        children: List.generate(
                                            salesController
                                                .paymentMethods.length,
                                            (index) => SimpleDialogOption(
                                                  onPressed: () {
                                                    salesController
                                                            .selectedPaymentMethod
                                                            .value =
                                                        salesController
                                                                .paymentMethods[
                                                            index];
                                                    Navigator.pop(context);
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 5),
                                                    child: Text(
                                                      "${salesController.paymentMethods[index]}",
                                                      style: const TextStyle(
                                                          fontSize: 18),
                                                    ),
                                                  ),
                                                )),
                                      );
                                    });
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Obx(
                                    () => Text(salesController
                                        .selectedPaymentMethod.value),
                                  ),
                                  const Icon(Icons.arrow_drop_down)
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      if (customersController.customers.isEmpty)
                        InkWell(
                          onTap: () {
                            Get.to(() => CreateCustomer(page: "createSale"));
                          },
                          child: Text(
                            "Add Customer",
                            style: TextStyle(color: AppColors.mainColor),
                          ),
                        ),
                      if ((salesController.selectedPaymentMethod.value ==
                                  "Wallet" ||
                              salesController.selectedPaymentMethod.value ==
                                  "Credit") &&
                          customersController.customers.isNotEmpty)
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                  controller: customersController.amountpaid,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      prefix: Padding(
                                        padding:
                                            const EdgeInsets.only(right: 10),
                                        child: Text(shopController
                                            .currentShop.value!.currency!),
                                      ))),
                              SizedBox(height: 10),
                              majorTitle(
                                  title: "Choose Customer",
                                  color: Colors.black,
                                  size: 14.0),
                              SizedBox(height: 10),
                              Flexible(
                                child: InkWell(
                                  onTap: () {
                                    if (customersController.customers.isEmpty) {
                                      showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text(
                                                  "This Shop Doesn't have customer"),
                                              content: const Text(
                                                  "Would you like to add Customer?"),
                                              actions: [
                                                TextButton(
                                                  child: const Text("Cancel"),
                                                  onPressed: () {
                                                    Get.back();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text("OK"),
                                                  onPressed: () {
                                                    Get.back();
                                                    Get.to(() => CreateCustomer(
                                                        page: "createSale"));
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
                                                  customersController
                                                      .customers.length,
                                                  (index) => SimpleDialogOption(
                                                        onPressed: () {
                                                          salesController
                                                                  .selectedCustomer
                                                                  .value =
                                                              customersController
                                                                  .customers
                                                                  .elementAt(
                                                                      index);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text(
                                                            "${customersController.customers.elementAt(index).fullName}"),
                                                      )),
                                            );
                                          });
                                    }
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey)),
                                    child: Row(
                                      children: [
                                        Obx(() {
                                          return majorTitle(
                                              title: salesController
                                                          .selectedCustomer
                                                          .value ==
                                                      null
                                                  ? ""
                                                  : salesController
                                                      .selectedCustomer
                                                      .value!
                                                      .fullName!,
                                              color: Colors.black,
                                              size: 12.0);
                                        }),
                                        Spacer(),
                                        const Icon(Icons.arrow_drop_down)
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: majorTitle(
                                  title: "Cancel",
                                  color: AppColors.mainColor,
                                  size: 16.0)),
                          TextButton(
                              onPressed: () {
                                salesController.saveSale(
                                    screen: page ?? "admin",
                                    attendantsUID: page == "allSales"
                                        ? attendantController
                                            .attendant.value!.id
                                        : authController
                                            .currentUser.value?.attendantId,
                                    context: context);
                              },
                              child: majorTitle(
                                  title: "Pay",
                                  color: AppColors.mainColor,
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

  Widget showPopUpdialog(
      {required context, required index, required ReceiptItem receiptItem}) {
    TextEditingController textEditingController = TextEditingController();
    return PopupMenuButton(
      itemBuilder: (ctx) => [
        if (authController.usertype.value == "admin" ||
            (authController.usertype.value == "attendant" &&
                attendantController.checkRole("edit_entries")))
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.edit),
              onTap: () {
                Get.back();
                showEditDialogPrice(
                    productModel: receiptItem.product!, index: index);
              },
              title: Text("Edit Selling price"),
            ),
          ),
        if (authController.usertype.value == "admin" ||
            (authController.usertype.value == "attendant" &&
                attendantController.checkRole("discounts")))
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.discount),
              onTap: () {
                Get.back();
                discountDialog(
                    controller: textEditingController,
                    receiptItem: receiptItem,
                    index: index);
              },
              title: Text("Give Discount"),
            ),
          ),
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.clear),
            onTap: () {
              Get.back();
              salesController.removeFromList(index);
            },
            title: Text("Delete"),
          ),
        ),
      ],
      icon: Icon(Icons.more_vert),
    );
  }
}
