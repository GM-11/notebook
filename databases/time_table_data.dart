import 'dart:developer';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:notebook/shared/notifications/Notifications.dart';

class TimeTableDatabase {
  Box _box = Hive.box("Time_Table");

  void addWork(
      String todo, int timeHour, int timeMinute, int durHour, int durMin,
      [subject]) {
    _box.put(todo, {
      "work": todo,
      "timeHour": timeHour,
      "timeMinute": timeMinute,
      "done": false,
      "durHour": durHour,
      "durMin": durMin,
      "subject": subject
    });
  }

  void markWorkAsDone(
      String todo, int timeHour, int timeMinute, int durHour, int durMin,
      [subject]) {
    _box.delete(todo);
    _box.put(todo, {
      "work": todo,
      "timeHour": timeHour,
      "timeMinute": timeMinute,
      "done": true,
      "durHour": durHour,
      "durMin": durMin,
      "subject": subject
    });
  }

  void deleteWork(String todo) {
    _box.delete(todo);
  }
}

// function to automate schedule
