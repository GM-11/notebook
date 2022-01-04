import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:notebook/databases/sa.dart';
import 'package:notebook/databases/subjects_data.dart';
import 'package:notebook/shared/providers.dart';
import 'package:notebook/shared/shared_prefs.dart';
import 'package:riverpod/riverpod.dart';

class DeleteSubject extends ConsumerWidget {
  String subjectName;
  DeleteSubject({this.subjectName});
  @override
  Widget build(BuildContext context, see) {
    SubjectsDatabase subjectData = SubjectsDatabase();

    return AlertDialog(
        title: Text("Are you sure to delete this subject?"),
        content: Text("All your data regarding this subject will be lost"),
        actions: [
          TextButton(
              onPressed: () async {
                subjectData.deleteSubject(subjectName);

                if (see(subjectProvider).state == subjectName) {
                  List l = Hive.box<Subjects>("Subjects").keys.toList();
                  Random r = Random();
                  int x = r.nextInt(l.length);
                  see(subjectProvider).state = l[x];
                  await UserPreferences.setSubject(l[x]);
                }

                Navigator.pop(context);
              },
              child: Text("Yes")),
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel")),
        ]);
  }
}
