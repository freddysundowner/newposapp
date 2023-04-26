import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/controllers/sales_controller.dart';
import 'package:flutterpos/models/customer_model.dart';
import 'package:flutterpos/models/payment_history.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/customers/customer_info_page.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PaymentHistory extends StatelessWidget {
  final String id;
  final String ?type;
  final CustomerModel? customerModel;

  PaymentHistory({Key? key, required this.id, this.customerModel,this.type})
      : super(key: key);
  SalesController salesController = Get.find<SalesController>();

  @override
  Widget build(BuildContext context) {
    salesController.getPaymentHistory(id: id,type:type);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        title: Text(
          "Payment History",
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
            onPressed: () {
              if (MediaQuery.of(context).size.width > 600) {
                Get.find<HomeController>().selectedWidget.value =
                    CustomerInfoPage(
                  customerModel: customerModel!,
                  user: "customer",
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
        smallScreen: Container(
          child: Obx(() {
            return salesController.getPaymentHistoryLoad.value
                ? Center(
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
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.symmetric(horizontal: 3)
                                .copyWith(bottom: 5),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.grey,
                                      offset: Offset(1, 1),
                                      blurRadius: 1)
                                ]),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Paid:",
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                    Text(
                                      payHistory.amountPaid!.toString(),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Balance:",
                                          style: TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          payHistory.balance!.toString(),
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text(
                                        "On: ${DateFormat("dd-MM-yyyy").format(payHistory.createdAt!)}",
                                        style: TextStyle(
                                          color: Colors.black,
                                        ))
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                  );
          }),
        ),
      ),
    );
  }
}
