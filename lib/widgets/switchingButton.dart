import 'package:flutter/material.dart';
import 'package:switcher_button/switcher_button.dart';

import '../utils/colors.dart';

Widget switchingButtons({required title, required value, required function}) {
  return Padding(
    padding: const EdgeInsets.all(6.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title),
        SwitcherButton(
          onColor: AppColors.mainColor,
          offColor: Colors.grey,
          value: value,
          onChange: (value) {
            function(value);
          },
        )
      ],
    ),
  );
}
