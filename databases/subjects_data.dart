import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:notebook/databases/sa.dart';
import 'package:notebook/shared/shared_prefs.dart';

class SubjectsDatabase {
  Box subjectBox = Hive.box<Subjects>("Subjects");
  Box homeworks = Hive.box("Homeworks");
  CollectionReference ref = FirebaseFirestore.instance
      .collection("Users")
      .doc(FirebaseAuth.instance.currentUser.uid)
      .collection("Subjects");

  List y;
  List x;
  var i;

  void addSubject(String subject, var color) {
    if (color == Colors.lime || color == Colors.yellow) {
      y = [color[900], color[800], color[700]];
      x = [color[900].toString(), color[800].toString(), color[700].toString()];
    } else {
      y = [color[800], color, color[300]];
      x = [color[800].toString(), color.toString(), color[300].toString()];
    }

    subjectBox.put(subject, Subjects(subjectName: subject, colorsList: y));
    ref.doc(subject).set({'subjectName': subject, "colors": x});
  }

  void deleteSubject(String subject) {
    subjectBox.delete(subject);
    ref.doc(subject).delete();
    if (subject == UserPreferences.getSubject()) {
      UserPreferences.removeSubject();
    }
  }

// Homeworks
  void addHomeworkForSubject(String subject, String hw, lastDate) {
    homeworks.put("$subject-$hw", {
      "hw": hw,
      "subject": subject,
      "lastDate": lastDate,
      "done": false,
    });
  }

  void markHomeworkAsDone(String subject, String hw, lastDate) {
    homeworks.put("$subject-$hw", {
      "hw": hw,
      "subject": subject,
      "lastDate": lastDate,
      "done": true,
    });
  }

  void deleteHomework(String subject, String hw) {
    homeworks.delete("$subject-$hw");
  }
}
