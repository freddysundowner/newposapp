import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pointify/controllers/user_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/product_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/functions/functions.dart';
import 'package:pointify/main.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/customers/customers_page.dart';
import 'package:pointify/screens/home/home_page.dart';
import 'package:pointify/screens/sales/all_sales.dart';
import 'package:pointify/widgets/no_items_found.dart';
import 'package:pointify/widgets/search_widget.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';

import '../../Real/schema.dart';
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

  CreateSale({Key? key, this.page}) : super(key: key);

  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();
  CustomerController customersController = Get.find<CustomerController>();
  AuthController authController = Get.find<AuthController>();
  UserController usercontroller = Get.find<UserController>();
  ProductController productController = Get.find<ProductController>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          salesController.receipt.value = null;
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.white,
            elevation: 0.3,
            titleSpacing: 0.0,
            leading: IconButton(
                onPressed: () {
                  if (isSmallScreen(context)) {
                    Get.back();
                  } else {
                    Get.find<HomeController>().selectedWidget.value =
                        HomePage();
                  }

                  salesController.receipt.value = null;
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
                return salesController.receipt.value == null
                    ? Center(
                        child: InkWell(
                          onTap: () {
                            productController.getProductsBySort(
                              type: "all",
                            );
                            if (isSmallScreen(context)) {
                              Get.to(() => ProductsScreen(
                                  type: "sale",
                                  function: (Product product) {
                                    addToCart(product);
                                  }));
                            } else {
                              Get.find<HomeController>().selectedWidget.value =
                                  ProductsScreen(
                                      type: "sale",
                                      function: (Product product) {
                                        addToCart(product);
                                      });
                            }
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
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount:
                                    salesController.receipt.value!.items.length,
                                itemBuilder: (context, index) {
                                  ReceiptItem receiptItem = salesController
                                      .receipt.value!.items
                                      .elementAt(index);
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
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),

                          Row(
                            children: [
                              Expanded(
                                child: InkWell(
                                  onTap: () {
                                    productController.getProductsBySort(
                                      type: "all",
                                    );
                                    if (isSmallScreen(context)) {
                                      Get.to(() => ProductsScreen(
                                          type: "sale",
                                          function: (Product product) {
                                            addToCart(product);
                                          }));
                                    } else {
                                      Get.find<HomeController>().selectedWidget.value =
                                          ProductsScreen(
                                              type: "sale",
                                              function: (Product product) {
                                                addToCart(product);
                                              });
                                    }
                                  },
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(15, 5, 15, 5),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Colors.grey),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: const Row(
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
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ))
            ],
          ),
          bottomNavigationBar: Obx(() {
            return BottomAppBar(
              color: Colors.white,
              child: salesController.receipt.value == null
                  ? Container(height: 0)
                  : Container(
                      width: double.infinity,
                      height: kToolbarHeight * 1.5,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: salesController.saveSaleLoad.value
                          ? const Center(child: CircularProgressIndicator())
                          : InkWell(
                              splashColor: Colors.transparent,
                              onTap: () {
                                if (salesController.receipt.value == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Please select products to sell")));
                                } else {
                                  salesController.receipt.value?.customerId =
                                      null;
                                  customersController.getCustomersInShop("all");

                                  confirmPayment(
                                    context,
                                  );
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Text("Total : "),
                                                Text(
                                                  htmlPrice(salesController
                                                      .receipt
                                                      .value
                                                      ?.grandTotal),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              width: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                const Text("Items : "),
                                                Text(
                                                  salesController
                                                      .receipt.value!.items
                                                      .fold(
                                                          0,
                                                          (previousValue,
                                                                  element) =>
                                                              previousValue +
                                                              element.quantity!)
                                                      .toString(),
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            majorTitle(
                                                title: "Pay via",
                                                color: Colors.black,
                                                size: 16.0),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 20),
                                              decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: Colors.grey),
                                                  borderRadius:
                                                      BorderRadius.circular(5)),
                                              child: InkWell(
                                                onTap: () {
                                                  showDialog(
                                                      context: context,
                                                      builder: (context) {
                                                        return SimpleDialog(
                                                          children:
                                                              List.generate(
                                                                  salesController
                                                                      .paymentMethods
                                                                      .length,
                                                                  (index) =>
                                                                      SimpleDialogOption(
                                                                        onPressed:
                                                                            () {
                                                                          salesController
                                                                              .receipt
                                                                              .value!
                                                                              .paymentMethod = salesController.paymentMethods[index];
                                                                          salesController
                                                                              .receipt
                                                                              .refresh();
                                                                          Navigator.pop(
                                                                              context);

                                                                          confirmPayment(
                                                                            context,
                                                                          );
                                                                        },
                                                                        child:
                                                                            Container(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 5),
                                                                          child:
                                                                              Text(
                                                                            "${salesController.paymentMethods[index]}",
                                                                            style:
                                                                                const TextStyle(fontSize: 18),
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
                                                      () => Text(salesController
                                                              .receipt
                                                              .value!
                                                              .paymentMethod ??
                                                          "Cash"),
                                                    ),
                                                    const Icon(
                                                        Icons.arrow_drop_down)
                                                  ],
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    majorTitle(
                                        title: "Cash in",
                                        color: AppColors.mainColor,
                                        size: 18.0)
                                  ],
                                ),
                              ),
                            ),
                    ),
            );
          }),
        ));
  }

  confirmPayment(context) {
    if (salesController.receipt.value!.paymentMethod == "Wallet") {
      showDialog(
          context: context,
          builder: (_) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20)),
              child: Container(
                width: 300,
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: Obx(
                  () => Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: majorTitle(
                            title:
                                "Total Amount ${htmlPrice(salesController.receipt.value?.grandTotal)}",
                            color: Colors.black,
                            size: 14.0),
                      ),
                      const SizedBox(height: 10),
                      if (_needCustomer() &&
                          salesController.receipt.value?.customerId == null)
                        InkWell(
                          onTap: () {
                            chooseCustomer(context: context);
                          },
                          child: Center(
                            child: majorTitle(
                                title: "Choose Customer",
                                color: AppColors.mainColor,
                                size: 18.0),
                          ),
                        ),
                      if (_needCustomer() &&
                          salesController.receipt.value?.customerId != null)
                        InkWell(
                          onTap: () {
                            chooseCustomer(context: context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              majorTitle(
                                  title: salesController
                                      .receipt.value?.customerId?.fullName,
                                  color: AppColors.mainColor,
                                  size: 18.0),
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: (BorderRadius.circular(10)),
                                    border: Border.all(
                                        color: AppColors.mainColor, width: 1)),
                                child: Row(
                                  children: [
                                    majorTitle(
                                        title: "Change",
                                        color: Colors.red,
                                        size: 12.0),
                                    const Icon(
                                      Icons.edit,
                                      size: 15,
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: majorTitle(
                                    title: "Cancel",
                                    color: AppColors.mainColor,
                                    size: 16.0)),
                            TextButton(
                                onPressed: () {
                                  salesController.saveSale(
                                      screen: page ?? "admin");
                                },
                                child: majorTitle(
                                    title: "Confirm payment",
                                    color: AppColors.mainColor,
                                    size: 16.0)),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          });
    } else {
      showModalBottomSheet(
        context: context,
        backgroundColor:
            isSmallScreen(context) ? Colors.white : Colors.transparent,
        isScrollControlled: true,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              margin: EdgeInsets.only(
                  left: isSmallScreen(context)
                      ? 0
                      : MediaQuery.of(context).size.width * 0.2),
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Obx(
                () => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    majorTitle(
                        title:
                            "Total Amount ${htmlPrice(salesController.receipt.value?.grandTotal)}",
                        color: Colors.black,
                        size: 14.0),
                    const SizedBox(height: 10),
                    majorTitle(
                        title: "Amount paid", color: Colors.black, size: 14.0),
                    const SizedBox(height: 10),
                    TextFormField(
                        controller: salesController.amountPaid,
                        onChanged: (value) {
                          salesController.getTotalCredit();
                          salesController.receipt.refresh();
                        },
                        keyboardType: TextInputType.number,
                        autofocus: true,
                        decoration: InputDecoration(
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 5),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            prefix: Padding(
                              padding: const EdgeInsets.only(right: 5),
                              child: Text(
                                  shopController.currentShop.value!.currency!),
                            ))),
                    const SizedBox(height: 10),
                    Obx(
                      () => majorTitle(
                          title:
                              "${salesController.changeText.value} ${htmlPrice(salesController.change.value)}",
                          color: Colors.black,
                          size: 14.0),
                    ),
                    const SizedBox(height: 10),
                    if (_needCustomer() &&
                        salesController.receipt.value?.customerId == null)
                      InkWell(
                        onTap: () {
                          chooseCustomer(context: context);
                        },
                        child: majorTitle(
                            title: "Choose Customer",
                            color: AppColors.mainColor,
                            size: 18.0),
                      ),
                    if (_needCustomer() &&
                        salesController.receipt.value?.customerId != null)
                      InkWell(
                        onTap: () {
                          chooseCustomer(context: context);
                        },
                        child: Row(
                          children: [
                            majorTitle(
                                title: salesController
                                    .receipt.value?.customerId?.fullName,
                                color: AppColors.mainColor,
                                size: 18.0),
                            const SizedBox(
                              width: 20,
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: (BorderRadius.circular(10)),
                                  border: Border.all(
                                      color: AppColors.mainColor, width: 1)),
                              child: Row(
                                children: [
                                  majorTitle(
                                      title: "Change",
                                      color: Colors.red,
                                      size: 12.0),
                                  const Icon(
                                    Icons.edit,
                                    size: 15,
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: majorTitle(
                                title: "Cancel",
                                color: AppColors.mainColor,
                                size: 16.0)),
                        TextButton(
                            onPressed: () {
                              salesController.saveSale(screen: page ?? "admin");
                            },
                            child: majorTitle(
                                title: "Confirm payment",
                                color: AppColors.mainColor,
                                size: 16.0)),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  _needCustomer() {
    return salesController.receipt.value?.paymentMethod == "Credit" ||
        salesController.receipt.value?.paymentMethod == "Wallet";
  }

  Widget showPopUpdialog(
      {required context, required index, required ReceiptItem receiptItem}) {
    TextEditingController textEditingController = TextEditingController();
    return PopupMenuButton(
      itemBuilder: (ctx) => [
        if (checkPermission(category: "sales", permission: "edit_price"))
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.edit),
              onTap: () {
                Get.back();
                showEditDialogPrice(
                    productModel: receiptItem.product!, index: index);
              },
              title: const Text("Edit Selling price"),
            ),
          ),
        if (checkPermission(category: "sales", permission: "discount"))
          PopupMenuItem(
            child: ListTile(
              leading: const Icon(Icons.discount),
              onTap: () {
                Get.back();
                discountDialog(
                    controller: textEditingController,
                    receiptItem: receiptItem,
                    index: index);
              },
              title: const Text("Give Discount"),
            ),
          ),
        PopupMenuItem(
          child: ListTile(
            leading: const Icon(Icons.clear),
            onTap: () {
              Get.back();
              salesController.removeFromList(index);
            },
            title: const Text("Delete"),
          ),
        ),
      ],
      icon: const Icon(Icons.more_vert),
    );
  }

  void addToCart(Product product) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formatted = formatter.format(now);
    ReceiptItem re = ReceiptItem(ObjectId(),
        product: product,
        quantity: 1,
        total: product.selling,
        attendantId: usercontroller.user.value,
        discount: 0,
        date: formatted,
        soldOn: DateTime.now().millisecondsSinceEpoch,
        shop: Get.find<ShopController>().currentShop.value,
        createdAt: DateTime.now(),
        price: product.selling);
    if (isSmallScreen(Get.context!)) {
      Get.back();
    } else {
      Get.find<HomeController>().selectedWidget.value = CreateSale();
    }

    salesController.changeSaleItem(re);
  }

  chooseCustomer({required context}) {
    if (isSmallScreen(Get.context)) {
      Get.to(() => Scaffold(
            appBar: AppBar(
              actions: [
                IconButton(
                    onPressed: () {
                      Get.to(() => CreateCustomer(
                            page: "customersPage",
                          ));
                    },
                    icon: const Icon(Icons.add))
              ],
              title: const Text("Select customer"),
            ),
            body: Customers(type: "createSale"),
          ));
    } else {
      Get.back();
      Get.find<HomeController>().selectedWidget.value =
          Scaffold(
        appBar: AppBar(
          elevation: 0.2,
          backgroundColor: Colors.white,
          leading: IconButton(
              onPressed: () {
                Get.find<HomeController>().selectedWidget.value = CreateSale();
                confirmPayment(Get.context);
              },
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              )),
          actions: [
            IconButton(
                onPressed: () {
                  Get.find<HomeController>().selectedWidget.value =
                      CreateCustomer(
                    page: "createSale",
                    function: () {
                      chooseCustomer(context: Get.context);
                    },
                  );
                },
                icon: const Icon(
                  Icons.add,
                  color: Colors.black,
                ))
          ],
          title: const Text(
            "Select customer",
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: Customers(
          type: "sale",
          function: () {
            confirmPayment(Get.context);
          },
        ),
      );
    }
  }
}
