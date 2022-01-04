import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notebook/databases/sa.dart';
import 'package:notebook/databases/time_table_data.dart';

// ignore: must_be_immutable
class AddDialog extends StatefulWidget {
  String day;
  AddDialog({this.day});

  @override
  _AddDialogState createState() => _AddDialogState();
}

class _AddDialogState extends State<AddDialog> {
  TextEditingController work = TextEditingController();
  int timeHour;
  int timeMinute;
  String sss = "";

  double value = 15.0;
  TimeTableDatabase _timeTableDatabase = TimeTableDatabase();
  @override
  Widget build(BuildContext context) {
    final _style = TextStyle(
        color: Colors.blueGrey, fontWeight: FontWeight.w700, fontSize: 27.0);
    return Container(
      color: Colors.white,
      child: ListView(children: [
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          child: Text("Work", style: _style),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.cyan[50],
            ),
            alignment: Alignment.center,
            padding: EdgeInsets.all(15.0),
            child: TextField(
                style: TextStyle(
                    color: Colors.cyan[800],
                    fontSize: 21.0,
                    fontWeight: FontWeight.w500),
                controller: work,
                cursorColor: Colors.cyan[800]),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          child: Text("Starting Time", style: _style),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.cyan[50],
            ),
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            height: MediaQuery.of(context).size.height / 7,
            child: CupertinoDatePicker(
              initialDateTime: DateTime.now(),
              use24hFormat: false,
              mode: CupertinoDatePickerMode.time,
              onDateTimeChanged: (DateTime value) {
                setState(() {
                  timeHour = value.hour.toInt();
                  timeMinute = value.minute.toInt();
                });
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10.0),
          child: Text("Duration", style: _style),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Slider(
            value: value,
            min: 15.0,
            max: 180.0,
            inactiveColor: Colors.blueGrey[200],
            activeColor: Colors.blueGrey[400],
            divisions: 11,
            label: "${value ~/ 60}h ${(value % 60).toInt()}m",
            onChanged: (double val) {
              setState(() {
                value = val;
              });
            },
          ),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Flexible(
            flex: 1,
            child: TextButton(
                onPressed: () async {
                  try {
                    List x = Hive.box<Subjects>("Subjects").keys.toList();

                    for (var item in x) {
                      if (work.text
                          .toLowerCase()
                          .contains(item.toString().toLowerCase())) {
                        setState(() {
                          sss = item.toString();
                        });
                        break;
                      } else {
                        continue;
                      }
                    }

                    _timeTableDatabase.addWork(work.text, timeHour, timeMinute,
                        (value ~/ 60), (value % 60).toInt(), sss);
                  } catch (e) {
                    return e;
                  }
                  work.clear();
                },
                child: Text(
                  "Add work",
                  style: TextStyle(color: Colors.black),
                )),
          ),
          Flexible(
            flex: 1,
            child: TextButton(
                onPressed: () {
                  work.clear();

                  Navigator.pop(context);
                },
                child: Text(
                  "Cancel",
                  style: TextStyle(color: Colors.black),
                )),
          )
        ]),
      ]),
    );
  }
}
