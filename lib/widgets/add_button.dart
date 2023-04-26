import 'package:flutter/material.dart';
import 'package:flutterpos/utils/colors.dart';
import 'package:flutterpos/widgets/bigtext.dart';

class AddButton extends StatelessWidget {
  String actionText;
  Function function;
  AddButton({Key? key, required this.actionText, required this.function})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.mainColor),
          borderRadius: BorderRadius.circular(20)),
      child: TextButton(
          onPressed: () => function(),
          child: majorTitle(
              title: actionText, color: AppColors.mainColor, size: 15.0)),
    );
  }
}
