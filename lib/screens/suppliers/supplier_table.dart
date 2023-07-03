import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/screens/customers/customer_info_page.dart';
import 'package:get/get.dart';
import 'package:pointify/screens/suppliers/supplier_info_page.dart';

import '../../../utils/colors.dart';
import '../../Real/schema.dart';

Widget supplierTable({required customers, required context}) {
  return SingleChildScrollView(
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      width: double.infinity,
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.grey),
        child: DataTable(
          decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.black,
              )),
          columnSpacing: 30.0,
          columns: const [
            DataColumn(label: Text('Name', textAlign: TextAlign.center)),
            DataColumn(label: Text('Phone', textAlign: TextAlign.center)),
            DataColumn(label: Text('', textAlign: TextAlign.center)),
          ],
          rows: List.generate(customers.length, (index) {
            Supplier supplierModel = customers.elementAt(index);
            final y = supplierModel.fullName;
            final x = supplierModel.phoneNumber;

            return DataRow(cells: [
              DataCell(Text(y!)),
              DataCell(Text(x.toString())),
              DataCell(
                InkWell(
                  onTap: () {
                    Get.find<HomeController>().selectedWidget.value =
                        SupplierInfoPage(
                          supplierModel: supplierModel,
                        );
                  },
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(3)),
                        width: 75,
                        child: const Text(
                          "View",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ]);
          }),
        ),
      ),
    ),
  );
}
