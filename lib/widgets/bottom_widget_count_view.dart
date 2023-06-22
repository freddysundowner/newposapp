import 'package:flutter/cupertino.dart';

Widget bottomWidgetCountView(
    {required count, required qty, required onCrdit, required cash}) {
  return SizedBox(
    height: 40,
    child: Row(
      children: [
        SizedBox(
          width: 10,
        ),
        Column(
          children: [
            Text("Items"),
            Text(
              count,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            )
          ],
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          children: [
            Text("Qty"),
            Text(
              qty,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            )
          ],
        ),
        SizedBox(
          width: 20,
        ),
        Column(
          children: [
            Text("On credit"),
            Text(
              onCrdit.toString(),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            )
          ],
        ),
        Spacer(),
        Column(
          children: [
            const Text("Total Cash"),
            Text(
              cash.toString(),
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            )
          ],
        ),
        SizedBox(
          width: 10,
        ),
      ],
    ),
  );
}
