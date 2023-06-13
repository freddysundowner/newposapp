import 'package:flutter/material.dart';
import 'package:pointify/controllers/shop_controller.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../Real/Models/schema.dart';
import '../controllers/AuthController.dart';
import '../controllers/user_controller.dart';
import '../controllers/expense_controller.dart';
import 'delete_dialog.dart';

Widget expenseCard({required context, required ExpenseModel expense}) {
  ShopController shopController = Get.find<ShopController>();
  return GestureDetector(
    onTap: () {},
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        child: Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      color: Colors.purple.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.show_chart, color: Colors.white),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${expense.name}",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 3),
                      Text(
                        "@ ${expense.amount} ${shopController.currentShop.value?.currency}",
                        style: TextStyle(
                            color: Colors.grey, fontWeight: FontWeight.w600),
                      ),
                      SizedBox(height: 3),
                      Container(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.2, color: Colors.grey),
                            borderRadius: BorderRadius.circular(50)),
                        child: Text(
                          "${expense.category}",
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ),
                      SizedBox(height: 3),
                      Row(
                        children: [
                          if (expense.createdAt != null)
                            Expanded(
                              flex: 6,
                              child: Text(
                                DateFormat("yyyy-MM-dd hh:mm a")
                                    .format(expense.createdAt!),
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              expense.attendantId == null
                                  ? ""
                                  : "By-${expense.attendantId!.username}",
                              style: const TextStyle(
                                  color: Color.fromRGBO(158, 158, 158, 1)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ],
            )),
      ),
    ),
  );
}

showBottomSheet(BuildContext context, expense) {
  ExpenseController expensesController = Get.find<ExpenseController>();
  UserController attendantController = Get.find<UserController>();
  AuthController authController = Get.find<AuthController>();
  return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
            height: 150,
            child: Center(
                child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [Container(child: Text('Manage Bank'))],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Row(
                      children: [
                        Icon(Icons.edit),
                        SizedBox(
                          width: 10,
                        ),
                        Container(child: Text('Edit'))
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      deleteDialog(context: context, onPressed: () {});
                    },
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline_rounded),
                        SizedBox(
                          width: 10,
                        ),
                        Container(child: Text('Delete'))
                      ],
                    ),
                  ),
                ),
              ],
            )));
      });
}
