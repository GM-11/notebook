import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notebook/auth/auth_screens/details.dart';
import 'package:notebook/shared/shared_prefs.dart';

// DATES
// final dateProvider = Provider<String>((ref) {
//   return "$date $month, $year";
// });
final dateProvider = ChangeNotifierProvider<DateForTimeTable>((ref) {
  return DateForTimeTable();
});

List<String> months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "June",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December"
];
int date = DateTime.now().day;
String month = months[DateTime.now().month - 1];
int year = DateTime.now().year;

class DateForTimeTable extends ChangeNotifier {
  String p = "$date $month, $year";
}

// MOdes

final modesProvider = ChangeNotifierProvider<ModesNotifier>((ref) {
  return ModesNotifier();
});

class ModesNotifier extends ChangeNotifier {
  String mode;
  String label;
  int hours;
  int minutes;
  var imgSrc;

  void setMode(oMode, oLabel, oHours, oMinutes, oImgSrc) {
    mode = oMode;
    label = oLabel;
    hours = oHours;
    minutes = oMinutes;
    imgSrc = oImgSrc;

    notifyListeners();
  }
}

final subjectProvider = StateProvider<String>((ref) {
  return '';
});
// details

final aimProvider = StateProvider<String>((ref) {
  return "";
});
final boardProvider = StateProvider<String>((ref) {
  return "";
});
final standardProvider = StateProvider<String>((ref) {
  return "";
});
// records

final recordProvider = ChangeNotifierProvider<RecordsDetails>((ref) {
  return RecordsDetails();
});

class RecordsDetails extends ChangeNotifier {
  int numberOfStudySessions;
  int totalStudySessions;
  int totalTasksToday;
  int tasksDoneToday;

  void setSheduleDetails(ttt, tdt) {
    totalTasksToday = ttt;
    tasksDoneToday = tdt;
  }
}
