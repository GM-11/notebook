import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notebook/databases/subjects_data.dart';

// ignore: must_be_immutable
class AddHomework extends StatefulWidget {
  String subjectName;
  AddHomework({this.subjectName});

  @override
  _AddHomeworkState createState() => _AddHomeworkState();
}

class _AddHomeworkState extends State<AddHomework> {
  bool errorOn = false;
  var dueDate;
  final _style = TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
  SubjectsDatabase _subjectDatabase = SubjectsDatabase();
  TextEditingController t = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80.0),
      child: ClipRRect(
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                height: MediaQuery.of(context).size.height * .75,
                width: MediaQuery.of(context).size.width * .9,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.2),
                    border: Border.all(
                        color: Colors.white.withOpacity(.5), width: .1)),
              ),
            ),
            AlertDialog(
              elevation: 0,
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              title: Text(
                "New ${widget.subjectName} homework",
                style: _style.copyWith(fontSize: 25.0),
              ),
              content: Container(
                height: MediaQuery.of(context).size.height * .75,
                width: MediaQuery.of(context).size.width * .85,
                child: ListView(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white.withOpacity(.5),
                      ),
                      child: TextField(
                        style: _style.copyWith(color: Colors.cyan[800]),
                        cursorColor: Colors.cyan[800],
                        controller: t,
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 14)),
                          ).then((value) {
                            setState(() {
                              dueDate = DateFormat("dd-MM-yy").format(value);
                            });
                          });
                        },
                        child: Text(
                          dueDate ?? "Select due date",
                          style: _style,
                        )),
                    errorOn
                        ? Text(
                            "Please fill homework and due date both",
                            style: _style.copyWith(color: Colors.blueGrey[900]),
                          )
                        : SizedBox(height: 0.0, width: 0.0)
                  ],
                ),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      if (dueDate == null || t.text.isEmpty) {
                        setState(() {
                          errorOn = true;
                          Future.delayed(Duration(seconds: 2)).then((value) {
                            errorOn = false;
                          });
                        });
                      } else {
                        _subjectDatabase.addHomeworkForSubject(
                            widget.subjectName, t.text, dueDate);
                        t.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: Text("Save Homework",
                        style: _style.copyWith(fontSize: 15.0))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child:
                        Text("Cancel", style: _style.copyWith(fontSize: 15.0))),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
