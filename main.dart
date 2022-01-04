import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:notebook/databases/records_data.dart';
import 'package:notebook/databases/sa.dart';
import 'package:notebook/shared/notifications/Notifications.dart';
import 'package:notebook/shared/providers.dart';

import 'package:notebook/shared/shared_prefs.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notebook/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //Firebase
  await Firebase.initializeApp();

  //hive
  await Hive.initFlutter();
  await Hive.openBox("Homeworks");
  await Hive.openBox("Time_Table");
  await Hive.openBox("Today_Time_table");
  await Hive.openBox("Quick_Notes");
  await Hive.openBox("Study_Modes");
  await Hive.openBox("StudySessions");
  Hive.registerAdapter(SubjectsAdapter());
  Hive.registerAdapter(ColorAdapter());

  await Hive.openBox<Subjects>("Subjects");

  //sharedPrefs
  await UserPreferences.init();

  //initialize details

  runApp(ProviderScope(child: MyApp()));
  //alarm manager
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    Notifications().init();
    // put this in background
    if (FirebaseAuth.instance.currentUser != null) {
      int x = 0;
      int y = 0;
      FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .get()
          .then((value) {
        context.read(aimProvider).state = value.get("aim");
        context.read(boardProvider).state = value.get("board");
        context.read(standardProvider).state = value.get("standard");
      });

      FirebaseFirestore.instance
          .collection("Users")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("Study_Sessions")
          .doc("${DateFormat("dd-MM-yy").format(DateTime.now())}")
          .get()
          .then((value) {
        value.data().forEach((key, value) {
          x++;
        });
        UserPreferences.setStudyModeIndex(x);
      });

      List _list = Hive.box("Time_Table").values.toList();

      if (_list.length != null) {
        _list.forEach((element) {
          if (element['done']) {
            y++;
          }
        });
      } else {
        y = 0;
      }

      RecordsDetails().setSheduleDetails(_list.length, y);
    }

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    Hive.box<Subjects>("Subjects").close();
    Hive.box("Homeworks").close();
    Hive.box("Time_Table").close();
    Hive.box("Today_Time_table").close();
    Hive.box('Quick_Notes').close();
    Hive.box("Study_Modes").close();
    Hive.box("StudySessions").close();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // showPerformanceOverlay: true,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(border: InputBorder.none),
        canvasColor: Colors.transparent,
        disabledColor: Colors.blueGrey[800],
        appBarTheme:
            AppBarTheme(backgroundColor: Colors.transparent, elevation: 0.0),
        scrollbarTheme: ScrollbarThemeData(interactive: true),
      ),
      home: Wrapper(),
    );
  }
}
