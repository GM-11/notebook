import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class Notifications {
  FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  var android = AndroidInitializationSettings("ic_launcher");

  void init() {
    _notificationsPlugin.initialize(InitializationSettings(android: android));
  }

  // // create a function to remind the user of a task using notifications at a specific time
  // Future<void> setNotification(DateTime time, String title, String body) async {
  //   var android = AndroidNotificationDetails(
  //       'reminder', 'reminder', 'reminder',
  //       priority: Priority.High, importance: Importance.High);
  //   var iOS = IOSNotificationDetails();
  //   var platform = NotificationDetails(android, iOS);

  //   await _notificationsPlugin.schedule(
  //       0, title, body, time, platform);
  // }
}
