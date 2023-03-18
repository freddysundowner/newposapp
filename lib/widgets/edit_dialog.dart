import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/CustomerController.dart';
import '../controllers/supplierController.dart';

showEditDialog({required user, required context}) {
  CustomerController customersController = Get.find<CustomerController>();
  SupplierController supplierController = Get.find<SupplierController>();
  showDialog(
      context: context,
      builder: (_) {
        return Dialog(
          child: Container(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width > 600
                ? MediaQuery.of(context).size.width * 0.35
                : MediaQuery.of(context).size.width * 0.6,
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 3),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Edit ${user}".capitalize!,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 4,
                ),
                TextFormField(
                  controller: user == "suppliers"
                      ? supplierController.nameController
                      : customersController.nameController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                SizedBox(
                  height: 7,
                ),
                TextFormField(
                  controller: user == "suppliers"
                      ? supplierController.phoneController
                      : customersController.phoneController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                SizedBox(
                  height: 7,
                ),
                TextFormField(
                  controller: user == "suppliers"
                      ? supplierController.emailController
                      : customersController.emailController,
                  decoration: InputDecoration(
                      hintText: "Email",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                SizedBox(
                  height: 7,
                ),
                TextFormField(
                  controller: user == "suppliers"
                      ? supplierController.genderController
                      : customersController.genderController,
                  decoration: InputDecoration(
                      hintText: "Gender",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                SizedBox(
                  height: 7,
                ),
                TextFormField(
                  controller: user == "suppliers"
                      ? supplierController.addressController
                      : customersController.addressController,
                  decoration: InputDecoration(
                      hintText: "Address",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5))),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Cancel".toUpperCase(),
                        style: TextStyle(
                            color: Colors.purple, fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          if (user == "suppliers") {
                            supplierController.updateSupplier(context,
                                customersController.customer.value?.id);
                          } else {
                            customersController.updateCustomer(context,
                                customersController.customer.value?.id);
                          }
                        },
                        child: Text("Save Changes".toUpperCase(),
                            style: TextStyle(
                                color: Colors.purple,
                                fontWeight: FontWeight.bold)))
                  ],
                )
              ],
            ),
          ),
        );
      });
}
