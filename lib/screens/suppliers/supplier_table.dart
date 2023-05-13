import 'package:flutter/material.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/screens/customers/customer_info_page.dart';
import 'package:get/get.dart';

import '../../../models/customer_model.dart';
import '../../../utils/colors.dart';

Widget supplierTable({required customers, required context}) {
  return SingleChildScrollView(
    child: Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
            CustomerModel customerModel = customers.elementAt(index);
            final y = customerModel.fullName;
            final x = customerModel.phoneNumber;

            return DataRow(cells: [
              DataCell(Container(child: Text(y!))),
              DataCell(Container(child: Text(x.toString()))),
              DataCell(
                InkWell(
                  onTap: () {
                    Get.find<HomeController>().selectedWidget.value =
                        CustomerInfoPage(
                      customerModel: customerModel,
                    );
                  },
                  child: Align(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: AppColors.mainColor,
                            borderRadius: BorderRadius.circular(3)),
                        width: 75,
                        child: Text(
                          "View",
                          style: TextStyle(color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    alignment: Alignment.topRight,
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
