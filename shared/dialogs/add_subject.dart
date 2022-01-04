import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:notebook/databases/subjects_data.dart';
import 'package:notebook/shared/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// ignore: must_be_immutable
class AddSubject extends StatefulWidget {
  @override
  _AddSubjectState createState() => _AddSubjectState();
}

class _AddSubjectState extends State<AddSubject> {
  SubjectsDatabase sb = SubjectsDatabase();
  List<Color> colors = [];
  Color x = Colors.white;
  TextEditingController t = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _style = TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 75, horizontal: 20.0),
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
                "Enter subject name",
                style: _style.copyWith(fontSize: 25.0),
              ),
              content: Container(
                height: MediaQuery.of(context).size.height * .75,
                width: MediaQuery.of(context).size.width * .85,
                child: ListView(
                  shrinkWrap: true,
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
                    SizedBox(height: 20.0),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width / 2,
                      child: BlockPicker(
                          availableColors: [
                            Colors.red,
                            Colors.yellow,
                            Colors.green,
                            Colors.teal,
                            Colors.blue,
                            Colors.purple,
                            Colors.pink,
                            Colors.deepOrange,
                            Colors.indigo,
                            Colors.blueGrey,
                            Colors.lime,
                            Colors.brown
                          ],
                          pickerColor: x,
                          onColorChanged: (c) {
                            setState(() {
                              x = c;
                            });
                          }),
                    )
                  ],
                ),
              ),
              actions: [
                Consumer(
                  builder: (context, see, child) {
                    return TextButton(
                      child: Text("OK", style: _style.copyWith(fontSize: 15.0)),
                      onPressed: () {
                        sb.addSubject(t.text, x);
                        t.clear();
                        see(subjectProvider).state = t.text;
                        Navigator.of(context).pop();
                      },
                    );
                  },
                ),
                TextButton(
                  child: Text("Cancel", style: _style.copyWith(fontSize: 15.0)),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
