import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/models/product_model.dart';
import 'package:flutterpos/screens/cash_flow/cash_flow_manager.dart';
import 'package:flutterpos/screens/finance/expense_page.dart';
import 'package:flutterpos/screens/product/create_product.dart';
import 'package:flutterpos/screens/sales/create_sale.dart';
import 'package:flutterpos/screens/shop/create_shop.dart';
import 'package:get/get.dart';

import '../screens/home/home.dart';

class Helper extends StatelessWidget {
  final AppBar? appBar;
  final Widget widget;
  final String? page;
  final BottomAppBar? bottomNavigationBar;
  List pages = [
    "Home",
    "Sell",
    "ReStock",
    "Expenses",
    "Cashflow",
    "Add Shop",
  ];
  List icons = [
    Icons.home_outlined,
    Icons.arrow_upward,
    Icons.arrow_downward_outlined,
    Icons.account_balance_wallet_outlined,
    Icons.money,
    Icons.add
  ];

  Helper(
      {Key? key,
      required this.widget,
      this.appBar,
      this.bottomNavigationBar,
      this.page})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar == null ? null : appBar,
      floatingActionButton:
          Get.find<AuthController>().currentUser.value == null ||
                  MediaQuery.of(context).size.width > 600
              ? null
              : FloatingActionButton(
                  onPressed: () {
                    showShortCutBottomSheet(context: context);
                  },
                  child: Center(
                    child: Icon(Icons.menu, color: Colors.white),
                  ),
                ),
      body: widget,
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  showShortCutBottomSheet({required BuildContext context}) {
    showModalBottomSheet(
        context: context,
        builder: (_) {
          return AnimatedContainer(
            height: MediaQuery.of(context).size.height * 0.3,
            padding: EdgeInsets.all(10),
            duration: Duration(milliseconds: 200),
            child: Column(
              children: [
                Center(
                  child: Text(
                    "ShortCuts",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: 1.5,
                              crossAxisCount: 3,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            InkWell(
                              onTap: () {
                                Get.back();
                                switch (index) {
                                  case 0:
                                    {
                                      if (page == null) {
                                        Get.off(() => Home());
                                      } else {
                                        Get.find<HomeController>()
                                            .selectedIndex
                                            .value = 0;
                                      }
                                    }
                                    break;
                                  case 1:
                                    {
                                      Get.to(() => CreateSale());
                                    }
                                    break;
                                  case 2:
                                    {
                                      Get.to(() => CreateProduct(
                                          page: "create",
                                          productModel: ProductModel()));
                                    }
                                    break;
                                  case 3:
                                    {
                                      Get.to(() => ExpensePage());
                                    }
                                    break;
                                  case 4:
                                    {
                                      Get.to(() => CashFlowManager());
                                    }
                                    break;
                                  case 5:
                                    {
                                      Get.to(() => CreateShop(page: "home"));
                                    }
                                    break;
                                }

                                if (index == 0) {
                                  if (page != null) {
                                    Get.off(() => Home());
                                  } else {
                                    Get.find<HomeController>()
                                        .selectedIndex
                                        .value = 0;
                                  }
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                    border: Border.all(
                                        width: 0.5, color: Colors.black)),
                                child: Center(
                                  child: Icon(icons.elementAt(index)),
                                ),
                                padding: EdgeInsets.all(10),
                              ),
                            ),
                            Text(pages.elementAt(index)),
                          ],
                        );
                      },
                      itemCount: pages.length),
                )
              ],
            ),
          );
        });
  }
}
