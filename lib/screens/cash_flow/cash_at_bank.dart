import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/bank_controller.dart';
import '../../controllers/shop_controller.dart';
import '../../utils/colors.dart';
import 'bank_history.dart';

class CashAtBank extends StatelessWidget {
  CashAtBank({Key? key}) : super(key: key);
  BankController bankController = Get.find<BankController>();
  ShopController createShopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.96),
      appBar: AppBar(
        elevation: 0.3,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        titleSpacing: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
        titleTextStyle: TextStyle(color: Colors.black),
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
          ),
        ),
        title: Text("Cash At Bank",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            )),
      ),
      body: ListView.builder(
          itemCount: 10,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return bankCard(context);
          }),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(10),
        height: kToolbarHeight,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Totals",
              style: TextStyle(color: Colors.black),
            ),
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20)),
              child: Text("KES ${300}"),
            )
          ],
        ),
      ),
    );
  }

  Widget bankCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadiusDirectional.circular(8),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Faulu Bank",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text("KES"),
                    SizedBox(width: 2),
                    Text(
                      "${800}",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Icon(Icons.credit_card, color: Colors.grey)
              ],
            ),
            SizedBox(height: 4),
            Text(
              "**** **** **** ****",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(height: 10),
            Divider(
              thickness: 0.5,
              color: Colors.grey,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {
                    Get.to(() => CashHistory(
                        title: "Faulu", subtitle: "All records", id: "1230"));
                  },
                  child: Text(
                    "View History",
                    style: TextStyle(color: AppColors.mainColor),
                  ),
                ),
                IconButton(
                    onPressed: () {
                      showBottomSheet(context);
                    },
                    icon: Icon(Icons.more_vert, color: Colors.grey)),
              ],
            )
          ],
        ),
      ),
    );
  }

  showBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 200,
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
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
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.clear),
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                            child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.redAccent),
                        ))
                      ],
                    ),
                  ),
                ],
              )));
        });
  }
}
