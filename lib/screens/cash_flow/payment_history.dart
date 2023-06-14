import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/sales_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/customers/customer_info_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Real/schema.dart';

class PaymentHistory extends StatelessWidget {
  final String id;
  final String? type;
  final CustomerModel? customerModel;

  PaymentHistory({Key? key, required this.id, this.customerModel, this.type})
      : super(key: key);
  SalesController salesController = Get.find<SalesController>();
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: const Text(
          "Payment History",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            onPressed: () {
              if (MediaQuery.of(context).size.width > 600) {
                Get.find<HomeController>().selectedWidget.value =
                    CustomerInfoPage(
                  customerModel: customerModel!,
                );
              } else {
                Get.back();
              }
            },
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
      ),
      body: ResponsiveWidget(
        largeScreen: Container(),
        smallScreen: Obx(() {
          return salesController.getPaymentHistoryLoad.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListView.builder(
                      itemCount: salesController.paymenHistory.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        PayHistory payHistory =
                            salesController.paymenHistory.elementAt(index);
                        return Container(
                          padding: const EdgeInsets.all(10),
                          margin: EdgeInsets.symmetric(horizontal: 3)
                              .copyWith(bottom: 5),
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey,
                                    offset: Offset(1, 1),
                                    blurRadius: 1)
                              ]),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Paid: ",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "${shopController.currentShop.value?.currency} ${payHistory.amountPaid!.toString()}",
                                        style: TextStyle(
                                          color: Colors.green,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      const Text(
                                        "Balance: ",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      Text(
                                        "-${shopController.currentShop.value?.currency} ${payHistory.balance!.toString()}",
                                        style: const TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "On: ${DateFormat("dd-MM-yyyy").format(payHistory.createdAt!)}",
                                      style: const TextStyle(
                                        color: Colors.black,
                                      )),
                                  if (payHistory.attendant?.username != null)
                                    Text(
                                        "by: ${payHistory.attendant!.username}",
                                        style: const TextStyle(
                                          color: Colors.black,
                                        )),
                                ],
                              )
                            ],
                          ),
                        );
                      }),
                );
        }),
      ),
    );
  }
}
