import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/customers/customer_info_page.dart';

import '../../Real/schema.dart';
import '../../controllers/CustomerController.dart';

class EditCustomer extends StatelessWidget {
  final userType;
  final CustomerModel customerModel;

  EditCustomer({Key? key, this.userType, required this.customerModel});

  CustomerController customersController = Get.find<CustomerController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(
          "Edit $userType".capitalize!,
          style:
              const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        leading: IconButton(
            onPressed: () {
              if (isSmallScreen(context)) {
                Get.back();
              } else {
                Get.find<HomeController>().selectedWidget.value =
                    CustomerInfoPage(customerModel: customerModel);
              }
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            )),
        backgroundColor: Colors.transparent,
        actions: [
          if (!isSmallScreen(context))
            TextButton(
                onPressed: () {
                  Get.find<HomeController>().selectedWidget.value =
                      CustomerInfoPage(customerModel: customerModel);
                  customersController.updateCustomer(context, customerModel);
                },
                child: Text("Save Changes".toUpperCase(),
                    style: const TextStyle(
                        color: Colors.purple, fontWeight: FontWeight.bold)))
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(
            left: isSmallScreen(context) ? 10 : 25,
            right: isSmallScreen(context) ? 10 : 25,
            top: 10,
            bottom: 3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: customersController.nameController,
              decoration: InputDecoration(
                  hintText: "name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            SizedBox(
              height: isSmallScreen(context) ? 7 : 25,
            ),
            TextFormField(
              controller: customersController.phoneController,
              decoration: InputDecoration(
                  hintText: "phone number",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            SizedBox(
              height: isSmallScreen(context) ? 7 : 25,
            ),
            TextFormField(
              controller: customersController.emailController,
              decoration: InputDecoration(
                  hintText: "Email",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            SizedBox(
              height: isSmallScreen(context) ? 7 : 25,
            ),
            TextFormField(
              controller: customersController.addressController,
              decoration: InputDecoration(
                  hintText: "Address",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5))),
            ),
            const SizedBox(
              height: 10,
            ),
            if (isSmallScreen(context))
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: const TextStyle(
                          color: Colors.purple, fontWeight: FontWeight.bold),
                    ),
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        customersController.updateCustomer(
                            context, customerModel);
                      },
                      child: Text("Save Changes".toUpperCase(),
                          style: const TextStyle(
                              color: Colors.purple,
                              fontWeight: FontWeight.bold)))
                ],
              )
          ],
        ),
      ),
    );
  }
}
