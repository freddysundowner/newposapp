import 'dart:io';
import 'package:excel/excel.dart' as ex;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pointify/controllers/home_controller.dart';
import 'package:pointify/responsive/responsiveness.dart';
import 'package:pointify/screens/stock/stock_page.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as exo;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:url_launcher/url_launcher.dart';

import '../../utils/colors.dart';
import '../../widgets/bigtext.dart';

class ImportProducts extends StatelessWidget {
  const ImportProducts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Import Products",
          style: TextStyle(
              color: isSmallScreen(context) ? Colors.white : Colors.black),
        ),
        elevation: 0.2,
        backgroundColor:
            isSmallScreen(context) ? AppColors.mainColor : Colors.white,
        leading: isSmallScreen(context)
            ? null
            : IconButton(
                onPressed: () {
                  Get.find<HomeController>().selectedWidget.value = StockPage();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                )),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Select Source",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            splashColor: Colors.transparent,
            onTap: () {},
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                width: isSmallScreen(context) ? double.infinity : 200,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    border: Border.all(width: 3, color: AppColors.mainColor),
                    borderRadius: BorderRadius.circular(40)),
                child: Center(
                    child: majorTitle(
                        title: "From another shop",
                        color: AppColors.mainColor,
                        size: 18.0)),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            splashColor: Colors.transparent,
            onTap: () async {
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                File file = File(result.files.single.path!);

                var bytess = File(file.path).readAsBytesSync();
                var excel = ex.Excel.decodeBytes(bytess);

                for (var table in excel.tables.keys) {
                  for (var row in excel.tables[table]!.rows) {
                    print('${row.map((e) => e!.value).toList()}');
                  }
                }

                print(file.path);
              } else {
                // User canceled the picker
              }
            },
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(10),
                width: isSmallScreen(context) ? double.infinity : 200,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    border: Border.all(width: 3, color: AppColors.mainColor),
                    borderRadius: BorderRadius.circular(40),
                    color: AppColors.mainColor),
                child: Center(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.receipt_long,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      majorTitle(
                          title: "From Excel file",
                          color: Colors.white,
                          size: 18.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Center(
            child: Text(
              "Download sample excel sheet below and see how to arrange products to import",
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () async {
              // generateExcel();
              final Uri url = Uri.parse(
                  'https://eu.docs.wps.com/l/sIDzbpYWCAZvV26QG?sa=03&st=0t&v=v2');
              if (!await launchUrl(url)) {
                throw Exception('Could not launch $url');
              }
            },
            child: Text(
              "Download sample template",
              style: TextStyle(
                  color: AppColors.mainColor, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }

  Future<void> generateExcel() async {
    //Create a Excel document.
    //Creating a workbook.
    final exo.Workbook workbook = exo.Workbook();

    //Accessing via index
    final exo.Worksheet sheet = workbook.worksheets[0];

    sheet.getRangeByName('A1:I1').cellStyle.bold = true;
    // Set the text value.
    sheet.getRangeByName('A1').setText('name');
    sheet.getRangeByName('A2').setText('tv stand');
    sheet.getRangeByName('B1').setText('buyingPrice');
    sheet.getRangeByName('B2').setNumber(2000);
    sheet.getRangeByName('C1').setText('selling');
    sheet.getRangeByName('C2').setNumber(4500);
    sheet.getRangeByName('D1').setText('minPrice');
    sheet.getRangeByName('D2').setNumber(4000);
    sheet.getRangeByName('E1').setText('quantity');
    sheet.getRangeByName('E2').setNumber(10);
    sheet.getRangeByName('F1').setText('discount');
    sheet.getRangeByName('F2').setNumber(500);
    sheet.getRangeByName('G1').setText('stockLevel');
    sheet.getRangeByName('G2').setNumber(5);
    sheet.getRangeByName('H1').setText('unit');
    sheet.getRangeByName('H2').setText('pieces');
    sheet.getRangeByName('I1').setText('description');
    sheet
        .getRangeByName('I2')
        .setText('original tv stand that is flexible and is movable');

    //Save and launch the excel.
    final List<int> bytes = workbook.saveAsStream();
    //Dispose the document.
    workbook.dispose();
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }
    String? path;
    if (Platform.isAndroid ||
        Platform.isIOS ||
        Platform.isLinux ||
        Platform.isWindows) {
      Directory? directory = await getExternalStorageDirectory();

      path = directory!.path;
    }
    print(path);
    var fileName = 'samplexmlfile.xlsx';
    final File file =
        File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');

    // var bytess = File(file.path).readAsBytesSync();
    // var excel = ex.Excel.decodeBytes(bytess);
    //
    // for (var table in excel.tables.keys) {
    //   print(table); //sheet Name
    //   print(excel.tables[table]!.maxCols);
    //   print(excel.tables[table]!.maxRows);
    //
    //   for (var row in excel.tables[table]!.rows[1]) {
    //     print(row!.value);
    //     // print('${row.map((e) => e!.value).toList()}');
    //     // print('${excel.tables[table]!.cell}');
    //   }
    // }

    await file.writeAsBytes(bytes, flush: true);
    file.copy("/storage/emulated/0/Download/" + fileName);
    if (Platform.isAndroid || Platform.isIOS) {
      //Launch the file (used open_file package)
      await OpenFile.open('$path/$fileName');
    } else if (Platform.isWindows) {
      await Process.run('start', <String>['$path\\$fileName'],
          runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>['$path/$fileName'], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>['$path/$fileName'],
          runInShell: true);
    }

    //Get the storage folder location using path_provider package.
    // final Directory? directory = await getExternalStorageDirectory();
    // final String path = directory!.path;
    // final File file = File('$path/output.xlsx');
    // await file.writeAsBytes(bytes, flush: true);
    //
    // var bytess = File(file.path).readAsBytesSync();
    // var excel = ex.Excel.decodeBytes(bytess);
    //
    // for (var table in excel.tables.keys) {
    //   print(table); //sheet Name
    //   print(excel.tables[table]!.maxCols);
    //   print(excel.tables[table]!.maxRows);
    //   for (var row in excel.tables[table]!.rows) {
    //     print('${row[0]}');
    //     print('${excel.tables[table]!.cell}');
    //   }
    // }
    //
    // //Launch the file (used open_file package)
    // await OpenFile.open('$path/$fileName');
  }
}
