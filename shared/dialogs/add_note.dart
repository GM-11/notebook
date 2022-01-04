import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:notebook/databases/notes_data.dart';
import 'package:notebook/databases/sa.dart';
import 'package:notebook/shared/shared_prefs.dart';

class AddNoteDialog extends StatefulWidget {
  @override
  _AddNoteDialogState createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<AddNoteDialog> {
  String selectedSubject = '';
  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();
  String text = "Save Note";

  List subjectList = Hive.box<Subjects>("Subjects").keys.toList();

  @override
  Widget build(BuildContext context) {
    print(subjectList);
    NotesDatabase n = NotesDatabase();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 130.0, horizontal: 30.0),
      child: ClipRRect(
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
            AlertDialog(
              elevation: 0.0,
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              //clipBehavior: Clip.antiAliasWithSaveLayer,
              title: TextField(
                controller: title,
                style: TextStyle(fontSize: 25.0, color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Note Title",
                  hintStyle: TextStyle(color: Colors.white),
                  border: InputBorder.none,
                ),
              ),
              content: Container(
                width: MediaQuery.of(context).size.width - 80,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Divider(),
                    Container(
                      height: MediaQuery.of(context).size.height / 3,
                      child: Row(
                        children: [
                          Flexible(
                            flex: 7,
                            child: TextField(
                              style: TextStyle(color: Colors.white),
                              controller: content,
                              keyboardType: TextInputType.multiline,
                              minLines: 1,
                              maxLines: 10,
                              decoration: InputDecoration(
                                hintText: "Content",
                                hintStyle: TextStyle(color: Colors.white),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          Flexible(
                            child: Container(
                              child: ListView.builder(
                                itemCount: subjectList.length ?? 0,
                                itemBuilder: (context, index) {
                                  Subjects s = Hive.box<Subjects>("Subjects")
                                      .get(subjectList[index]);

                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 8.0, left: 4.5, right: 4.5),
                                    child: GestureDetector(
                                      onTap: () {
                                        if (selectedSubject ==
                                            subjectList[index]) {
                                          setState(() {
                                            selectedSubject = '';
                                          });
                                        } else {
                                          setState(() {
                                            selectedSubject =
                                                subjectList[index];
                                          });
                                        }
                                      },
                                      child: AnimatedContainer(
                                          duration: Duration(milliseconds: 200),
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              15,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 8.0),
                                          decoration: BoxDecoration(
                                              color: selectedSubject ==
                                                      subjectList[index]
                                                  ? Colors.blueGrey[900]
                                                  : Colors.blueGrey[400],
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0))),
                                          child: Align(
                                            alignment: Alignment.center,
                                            child: Text(
                                              s.subjectName,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 10.0),
                                            ),
                                          )),
                                    ),
                                  );
                                },
                              ),
                            ),
                            flex: 3,
                          ),
                        ],
                      ),
                    ),
                    Container(
                        width: double.infinity,
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          color: Colors.blueGrey[100],
                          child: Text(
                            text,
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: text != "Save Note"
                              ? null
                              : () async {
                                  if (content.text.isEmpty ||
                                      title.text.isEmpty) {
                                    setState(() {
                                      if (content.text.isEmpty) {
                                        text = "Please provide some content";
                                      }
                                      if (title.text.isEmpty) {
                                        text = "Please provide some title";
                                      }
                                      if (title.text.isEmpty &&
                                          content.text.isEmpty) {
                                        text =
                                            "Title and content can't be empty";
                                      }
                                    });
                                    Timer(Duration(seconds: 2), () {
                                      setState(() {
                                        text = "Save Note";
                                      });
                                    });
                                  } else {
                                    n.addNote(
                                        title.text,
                                        content.text,
                                        selectedSubject,
                                        DateFormat("dd-MM-yyyy")
                                            .format(DateTime.now()));
                                  }
                                  // Navigator.pop(context);
                                },
                        ))
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
