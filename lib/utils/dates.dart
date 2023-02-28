import 'package:intl/intl.dart';

var now = new DateTime.now();
var startYear = int.parse(DateFormat("yyyy").format(DateTime.now()));
var endYear = DateTime(now.year - 10, now.month, now.day);

var lastDayOfMonth = DateTime(now.year, now.month + 1, 0);
var firstDayOfMonth = DateTime(now.year, now.month + 0, 1);

convertTimeToMilliSeconds() {
  var now = new DateTime.now();
  var tomm = now.add(new Duration(days: 1));
  var today = new DateFormat('yyyy-MM-dd')
      .parse(new DateFormat('yyyy-MM-dd').format(now))
      .toIso8601String();
  var tomorrow = new DateFormat('yyyy-MM-dd')
      .parse(new DateFormat('yyyy-MM-dd').format(tomm))
      .toIso8601String();
  converTimeToMonth();
  return {"startDate": today, "endDate": tomorrow};
}

converTimeToMonth() {
  var now = new DateTime.now();
  var last = DateTime(now.year, now.month + 1, 0);
  var first = DateTime(now.year, now.month + 0, 1);


  var firstDay = new DateFormat().parse(new DateFormat().format(first)).toIso8601String();
  var lastDay = new DateFormat()
      .parse(new DateFormat().format(last))
      .toIso8601String();
  return {"startDate": lastDay, "endDate": firstDay};
}

converTimeToYear(selectedYear) {
  var now = new DateTime.now();
  var last = DateTime(int.parse("${selectedYear}"), DateTime.december + 1, 0);
  var first = DateTime(int.parse("${selectedYear}"), DateTime.january + 0, 1);

  var firstDay = new DateFormat('yyyy-MM-dd')
      .parse(new DateFormat('yyyy-MM-dd').format(first))
      .toIso8601String();
  var lastDay = new DateFormat('yyyy-MM-dd')
      .parse(new DateFormat('yyyy-MM-dd').format(last))
      .toIso8601String();

  return {"startDate": firstDay, "endDate": lastDay};
}

converTimeToMonthByDate(date) {
  var last = DateTime(date.year, date.month + 1, 0);
  var first = DateTime(date.year, date.month + 0, 1);
  ;
  var firstDay = new DateFormat('yyyy-MM-dd')
      .parse(new DateFormat('yyyy-MM-dd').format(first))
      .toIso8601String();
  var lastDay = new DateFormat('yyyy-MM-dd')
      .parse(new DateFormat('yyyy-MM-dd').format(last))
      .toIso8601String();


  return {"startDate": firstDay, "endDate": lastDay};
}
