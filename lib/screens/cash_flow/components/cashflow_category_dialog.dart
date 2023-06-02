import 'package:flutter/material.dart';
import 'package:pointify/controllers/cashflow_controller.dart';
import 'package:get/get.dart';
import 'package:pointify/screens/cash_flow/cashflow_category_history.dart';

import '../../../Real/Models/schema.dart';
import '../../../controllers/home_controller.dart';
import '../../../utils/colors.dart';
import '../../../widgets/delete_dialog.dart';

cashFlowCategoryDialog(context, {required CashFlowCategory cashflowCategory}) {
  CashflowController cashflowController = Get.find<CashflowController>();
  return PopupMenuButton(
    itemBuilder: (ctx) => [
      PopupMenuItem(
        child: ListTile(
          leading: Icon(Icons.list),
          onTap: () {
            Get.back();
            Get.find<HomeController>().selectedWidget.value =
                CashCategoryHistory(
              title: cashflowCategory.name,
              subtitle: "All records",
              id: cashflowCategory.id,
              page: "cashflowcategory",
            );
          },
          title: Text("View List"),
        ),
      ),
      PopupMenuItem(
        child: ListTile(
          leading: Icon(Icons.edit),
          onTap: () {
            Get.back();
            showDialog(
                context: context,
                builder: (_) {
                  return Dialog(
                    child: Container(
                      padding: EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 3),
                      height: MediaQuery.of(context).size.height * 0.2,
                      width: MediaQuery.of(context).size.width * 0.2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Edit Category"),
                          Spacer(),
                          TextFormField(
                            controller: cashflowController
                                .textEditingControllerCategory,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.all(10),
                                fillColor: Colors.white,
                                filled: true,
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.5)),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(
                                        color: Colors.grey, width: 0.5))),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    "Cancel".toUpperCase(),
                                    style:
                                        TextStyle(color: AppColors.mainColor),
                                  )),
                              SizedBox(
                                width: 10,
                              ),
                              TextButton(
                                  onPressed: () {
                                    Get.back();
                                    if (cashflowController
                                        .textEditingControllerCategory
                                        .text
                                        .isNotEmpty) {
                                      cashflowController
                                          .editCategory(cashflowCategory.id);
                                    }
                                  },
                                  child: Text(
                                    "Save".toUpperCase(),
                                    style:
                                        TextStyle(color: AppColors.mainColor),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
          title: Text("Edit"),
        ),
      ),
      PopupMenuItem(
        child: ListTile(
          leading: Icon(Icons.delete),
          onTap: () {
            Get.back();
            deleteDialog(
                context: context,
                onPressed: () {
                  cashflowController.deleteCategory(cashflowCategory.id);
                });
          },
          title: Text("Delete"),
        ),
      ),
    ],
    icon: Icon(Icons.more_vert),
  );
}
