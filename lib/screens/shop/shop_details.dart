import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/AuthController.dart';
import 'package:flutterpos/controllers/shop_controller.dart';
import 'package:flutterpos/models/shop_model.dart';
import 'package:flutterpos/utils/constants.dart';
import 'package:flutterpos/widgets/shop_delete_dialog.dart';
import 'package:get/get.dart';

import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';
import '../../widgets/shop_widget.dart';

class ShopDetails extends StatelessWidget {
  final ShopModel shopModel;

  ShopDetails({Key? key, required this.shopModel}) : super(key: key);
  ShopController shopController = Get.find<ShopController>();
  AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    shopController.initializeControllers(shopModel: shopModel);
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
        title: majorTitle(
            title: "${shopModel.name}", color: Colors.black, size: 16.0),
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
                          return Text("${shopController.currency.value}",
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
              Card(
                elevation: 1,
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          deleteShopDialog(context, () {
                            shopController.deleteShop(
                                id: shopModel.id,
                                adminId: authController.currentUser.value?.id,context: context);
                          });
                        },
                        child: Container(
                          width: double.infinity,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Delete This Shop",
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 18)),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text("Erase All shop Data.",
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                              Icon(Icons.arrow_forward_ios, color: Colors.grey)
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
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
          decoration: BoxDecoration(
            border: Border.all(width: 1, color: Colors.grey),
          ),
          child: Obx(() {
            return shopController.updateShopLoad.value ||
                    shopController.deleteShopLoad.value
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : InkWell(
                    splashColor: Colors.transparent,
                    onTap: () {
                      shopController.updateShop(
                          id: shopModel.id,
                          adminId: authController.currentUser.value?.id,context: context);
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
                              title: "Update Shop",
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
