import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/utils/constants.dart';
import 'package:get/get.dart';
import 'package:switcher_button/switcher_button.dart';

import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/shop_widget.dart';
import '../../widgets/smalltext.dart';

class CreateShop extends StatelessWidget {
  final page;

  CreateShop({Key? key, required this.page}) : super(key: key);
  ShopController shopController = Get.find<ShopController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        backgroundColor: Colors.white,
        elevation: 0.3,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
        ),
        title:
            majorTitle(title: "Create Shop", color: Colors.black, size: 16.0),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              shopWidget(
                  controller: shopController.nameController, name: "Shop Name"),
              SizedBox(height: 10),
              shopWidget(
                  controller: shopController.businessController,
                  name: "Business Type"),
              SizedBox(height: 10),
              shopWidget(
                  controller: shopController.reqionController,
                  name: "Location"),
              SizedBox(height: 10),
              majorTitle(title: "Currency", color: Colors.black, size: 16.0),
              SizedBox(height: 5),
              Card(
                elevation: 1,
                child: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return SimpleDialog(
                            children: List.generate(
                                Constants.currenciesData.length,
                                (index) => SimpleDialogOption(
                                      onPressed: () {
                                        shopController.currency.value =
                                            Constants.currenciesData
                                                .elementAt(index);

                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                          "${Constants.currenciesData.elementAt(index)}"),
                                    )),
                          );
                        });
                  },
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Obx(() {
                          return Text(
                              " ${shopController.currency.value == "" ? Constants.currenciesData[0] : shopController.currency}",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 12.0));
                        }),
                        Spacer(),
                        Icon(Icons.arrow_drop_down)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      majorTitle(
                          title: "Accept", color: Colors.black, size: 13.0),
                      SizedBox(width: 4),
                      minorTitle(
                          title: "terms and conditions",
                          color: AppColors.mainColor)
                    ],
                  ),
                  SwitcherButton(
                      onChange: (value) {
                        shopController.terms.value = value;
                      },
                      onColor: Colors.purple,
                      offColor: Colors.grey)
                ],
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(10),
          height: kToolbarHeight * 1.5,
          decoration:
              BoxDecoration(border: Border.all(width: 1, color: Colors.grey)),
          child: Obx(() {
            return shopController.createShopLoad.value
                ? Center(child: CircularProgressIndicator())
                : InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      shopController.createShop(page: page);
                    },
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border:
                              Border.all(width: 3, color: AppColors.mainColor),
                          borderRadius: BorderRadius.circular(40)),
                      child: Center(
                          child: majorTitle(
                              title: "Create ",
                              color: AppColors.mainColor,
                              size: 18.0)),
                    ),
                  );
          }),
        ),
      ),
    );
  }
}
