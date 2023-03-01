// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/utils/helper.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../utils/colors.dart';

class CashHistory extends StatelessWidget {
  final title;
  final subtitle;
  final id;
  ShopController createShopController = Get.find<ShopController>();


  CashHistory(
      {Key? key, required this.title, required this.subtitle, required this.id})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Helper(widget: ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return bankTransactionsCard();
        }),appBar: AppBar(
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
          )),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${title} Bank".capitalize!,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              )),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
            ),
          )
        ],
      ),
      actions: [
        IconButton(onPressed: () async {}, icon: Icon(Icons.download))
      ],
    ) ,bottomNavigationBar:BottomAppBar(
      child: Container(
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
              child: Text("KES ${400}"),
            )
          ],
        ),
      ),
    ) ,);
  
  }

  showBottomSheet(BuildContext context) {
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
                      children: [Container(child: Text('Download As'))],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.file_open_outlined),
                        SizedBox(
                          width: 10,
                        ),
                        Container(child: Text('PDF'.toUpperCase()))
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(Icons.book),
                        SizedBox(
                          width: 10,
                        ),
                        Container(child: Text('Excel'.toUpperCase()))
                      ],
                    ),
                  ),
                ],
              )));
        });
  }

  Widget bankTransactionsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Colors.white,
          width: double.infinity,
          padding: EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.mainColor,
                child: Icon(Icons.check),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Name",
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "${DateFormat("MMM dd yyyy hh:mm a").format(DateTime.now())}",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "@${400}",
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600),
                  ),
                ],
              )
            ],
          ),
        ),
        Divider(
          thickness: 0.2,
          color: Colors.grey,
        )
      ],
    );
  }
}
