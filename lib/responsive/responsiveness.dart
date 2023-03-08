import 'package:flutter/material.dart';
import 'package:flutterpos/controllers/home_controller.dart';
import 'package:get/get.dart';

import '../widgets/snackBars.dart';


const int smallScreenSize = 600;
class ResponsiveWidget extends StatelessWidget {
  final Widget largeScreen;

  final Widget smallScreen;

  ResponsiveWidget({
    Key? key,
    required this.largeScreen,
    required this.smallScreen,
  }) : super(key: key);

  static bool isSmallScreen(BuildContext context) =>
      MediaQuery.of(context).size.width <= smallScreenSize;



  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      double _width = constrains.maxWidth;
      print(_width);
      if (_width > smallScreenSize) {
        return largeScreen;
      } else {
        return smallScreen;
      }
    });
  }



}
