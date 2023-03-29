import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:flutterpos/models/customer_model.dart';
import 'package:flutterpos/responsive/responsiveness.dart';
import 'package:flutterpos/screens/customers/customer_info_page.dart';
import 'package:get/get.dart';

class PaymentHistory extends StatelessWidget {
final CustomerModel customerModel;
   PaymentHistory({Key? key,required this.customerModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                    CustomerInfoPage(customerModel: customerModel, user: "customer",);
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
        smallScreen: Container(),
      ),
    );
  }
}
