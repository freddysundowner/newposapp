import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../Real/schema.dart';
import '../../../functions/functions.dart';
import '../../../utils/colors.dart';
import '../../../widgets/showReceiptManageModal.dart';

Widget productHistoryTable(
    {required context, required items,  bool ?showAction=false,required Product product}) {
  return IntrinsicHeight(
    child: Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 5).copyWith(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.grey),
        child: DataTable(
          decoration: BoxDecoration(
              border: Border.all(
            width: 1,
            color: Colors.black,
          )),
          columnSpacing: 30.0,
          columns: [
            const DataColumn(
                label: Text('Product', textAlign: TextAlign.center)),
            const DataColumn(
                label: Text('Quantity', textAlign: TextAlign.center)),
            const DataColumn(label: Text('Total', textAlign: TextAlign.center)),
            const DataColumn(
                label: Text('Attendant', textAlign: TextAlign.center)),
            const DataColumn(label: Text('Date', textAlign: TextAlign.center)),
            if (showAction!)
              const DataColumn(
                  label: Text('Actions', textAlign: TextAlign.center)),
          ],
          rows: List.generate(items.length, (index) {
            ReceiptItem receiptItems = items.elementAt(index);

            final y = receiptItems.product!.name;
            final h = receiptItems.quantity;
            final x = receiptItems.quantity! * receiptItems.price!;
            final z = receiptItems.attendantId?.username;
            final w = receiptItems.createdAt;

            return DataRow(cells: [
              DataCell(Text(y!)),
              DataCell(Text(h.toString())),
              DataCell(Text(x.toString())),
              DataCell(Text(z.toString())),
              DataCell(Text(DateFormat("yyyy-dd-MMM ").format(w!))),
              if (showAction)
                DataCell(
                  InkWell(
                    onTap: () {
                      if (checkPermission(category: "sales", permission: "manage") && receiptItems.type != "return") {
                        showReceiptManageModal(Get.context!, receiptItems, product);
                      }
                    },
                    child: const Icon(
                      Icons.more_vert,
                      color: Colors.black,
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
