import 'package:flutter/material.dart';
import 'package:pointify/controllers/cashflow_controller.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:pointify/models/cashflow_category.dart';
import 'package:pointify/screens/cash_flow/cash_at_bank.dart';
import 'package:pointify/screens/cash_flow/cashflow_category_history.dart';
import 'package:pointify/utils/colors.dart';
import 'package:pointify/widgets/delete_dialog.dart';
import 'package:get/get.dart';

Widget categoryCard(context, {required CashFlowCategory cashflowCategory}) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: InkWell(
      onTap: () {
        if (cashflowCategory.name == "bank") {
          Get.to(() => CashAtBank());
        } else {
          actionsBottomSheet(
              context: context, cashflowCategory: cashflowCategory);
        }
      },
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 3),
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(width: 1, color: Colors.black),
            borderRadius: BorderRadius.circular(8)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.account_balance_wallet,
              color: Colors.grey,
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cashflowCategory.name!,
                  style: const TextStyle(color: Colors.black),
                ),
                Text(
                  "${Get.find<ShopController>().currentShop.value?.currency} ${cashflowCategory.amount!.toString()}",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

actionsBottomSheet(
    {required context, required CashFlowCategory cashflowCategory}) {
  CashflowController cashflowController = Get.find<CashflowController>();
  cashflowController.textEditingControllerCategory.text =
      cashflowCategory.name!;

  showModalBottomSheet(
      context: context,
      builder: (_) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          child: Column(
            children: [
              Container(
                color: AppColors.mainColor.withOpacity(0.1),
                width: double.infinity,
                child: const ListTile(
                  title: Text("Select Action"),
                ),
              ),
              ListTile(
                leading: Icon(Icons.list),
                onTap: () {
                  Get.back();
                  if (MediaQuery.of(context).size.width > 600) {
                    Get.find<HomeController>().selectedWidget.value =
                        CashCategoryHistory(
                            title: cashflowCategory.name,
                            subtitle: "All records",
                            page: "cashflowcategory",
                            id: cashflowCategory.id);
                  } else {
                    Get.to(() => CashCategoryHistory(
                        title: cashflowCategory.name,
                        subtitle: "All records",
                        page: "cashflowcategory",
                        id: cashflowCategory.id));
                  }
                },
                title: Text("View List"),
              ),
              ListTile(
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
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          borderSide: BorderSide(
                                              color: Colors.grey, width: 0.5)),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                          style: TextStyle(
                                              color: AppColors.mainColor),
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
                                            cashflowController.editCategory(
                                                cashflowCategory.id);
                                          }
                                        },
                                        child: Text(
                                          "Save".toUpperCase(),
                                          style: TextStyle(
                                              color: AppColors.mainColor),
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
              ListTile(
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
              )
            ],
          ),
        );
      });
}
