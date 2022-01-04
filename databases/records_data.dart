import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notebook/databases/sa.dart';

class RecordsDatabase {
  User user = FirebaseAuth.instance.currentUser;

  void saveStudySession(
      mode, timeHour, timeMinute, output, var date, input, int index) {
    FirebaseFirestore.instance
        .collection("Users")
        .doc(user.uid)
        .collection("Study_Sessions")
        .doc("$date")
        .set({
      "$index": {
        "index": index,
        "input": input,
        "study_mode": mode,
        "date": date,
        "output": output,
        "durHour": timeHour,
        "durMin": timeMinute
      }
    }, SetOptions(merge: true));
  }

  List _list = Hive.box<Subjects>("Subjects").keys.toList();
}
