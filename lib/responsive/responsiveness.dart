import 'package:flutter/material.dart';

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
      if (_width <= smallScreenSize) {
        return smallScreen;
      } else {
        return largeScreen;
      }
    });
  }
}
