import 'package:flutter/material.dart';
import 'package:flutterpos/widgets/side_menu.dart';

class LargeScreen extends StatelessWidget {
  final Widget body;
  final Widget? sideBar;

  LargeScreen({Key? key, required this.body, this.sideBar}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child:body);
  }
}
