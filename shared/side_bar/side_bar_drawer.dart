import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notebook/databases/sa.dart';
import 'package:notebook/shared/dialogs/add_subject.dart';
import 'package:notebook/shared/dialogs/delete_subject.dart';
import 'package:notebook/shared/providers.dart';
import 'package:notebook/shared/shared_prefs.dart';

class SideBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, see) {
    List _subjectList = Hive.box<Subjects>("Subjects").values.toList();

    return ClipRRect(
      child: Container(
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.2),
                    border: Border.all(
                        color: Colors.white.withOpacity(.5), width: .1)),
              ),
            ),
            ListView(
              children: [
                Container(
                    margin: EdgeInsets.only(left: 6.0),
                    height: MediaQuery.of(context).size.height / 5.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Subjects",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25.0,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        TextButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AddSubject();
                                  });
                            },
                            child: Text(
                              "Add new Subject",
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    )),
                Divider(),
                Container(
                  height: MediaQuery.of(context).size.height - 240,
                  width: double.infinity,
                  child: ListView.builder(
                      itemCount: _subjectList.length,
                      itemBuilder: (context, index) {
                        Subjects s =
                            Hive.box<Subjects>("Subjects").getAt(index);

                        List<Color> colors = [];

                        s != null
                            ? s.colorsList.forEach((element) {
                                colors.add(element);
                              })
                            : colors = [];
                        return Dismissible(
                          direction: DismissDirection.endToStart,
                          key: ObjectKey(_subjectList[index]),
                          onDismissed: (direction) {
                            return showDialog(
                                context: context,
                                builder: (context) {
                                  return DeleteSubject(
                                    subjectName: s.subjectName,
                                  );
                                });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 4.0),
                            child: PhysicalModel(
                              color: Colors.transparent,
                              elevation: 5.0,
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 5.0),
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: colors),
                                    borderRadius: BorderRadius.circular(10.0)),
                                child: ListTile(
                                    title: Text(
                                      s.subjectName,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onTap: () async {
                                      see(subjectProvider).state =
                                          s.subjectName;

                                      await UserPreferences.setSubject(
                                          s.subjectName);

                                      //  Navigator.of(_key.currentContext).pop();
                                    }),
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
