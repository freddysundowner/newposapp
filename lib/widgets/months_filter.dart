import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../functions/functions.dart';

List<Map<String, dynamic>> monhts = [
  {"month": "January"},
  {"month": "February"},
  {"month": "March"},
  {"month": "April"},
  {"month": "May"},
  {"month": "June"},
  {"month": "July"},
  {"month": "August"},
  {"month": "September"},
  {"month": "October"},
  {"month": "November"},
  {"month": "December"},
];
Widget monthsFilter(Function function, {Function? counts, Function? totals}) {
  return ListView.builder(
      itemCount: monhts.length,
      itemBuilder: (c, i) {
        var month = monhts[i];
        return InkWell(
          onTap: () {
            function(i);
          },
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          month["month"].toString().capitalize!,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(counts!(month["month"].toString())),
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Text(
                          totals!(month["month"].toString()),
                          style: const TextStyle(fontSize: 11),
                        ),
                        const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Colors.grey,
                          size: 15,
                        ),
                      ],
                    )
                  ],
                ),
              ),
              Divider()
            ],
          ),
        );
      });
}
