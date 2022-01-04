import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notebook/databases/study_modes_data.dart';

class AddModeSheet extends StatefulWidget {
  @override
  _AddModeSheetState createState() => _AddModeSheetState();
}

class _AddModeSheetState extends State<AddModeSheet> {
  bool loading = false;
  bool search = false;
  TextEditingController mn = TextEditingController();
  TextEditingController ln = TextEditingController();
  TextEditingController h = TextEditingController();
  TextEditingController m = TextEditingController();
  TextEditingController i = TextEditingController();
  File _image;
  double _val = 0.0;
  final picker = ImagePicker();
  Box box = Hive.box("Study_Modes");
  List k = Hive.box("Study_Modes").keys.toList();
  List v = Hive.box("Study_Modes").values.toList();
  int timeHour;
  int timeMinute;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20.0, bottom: 10.0, top: 10.0),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: mn,
              decoration: InputDecoration(hintText: "Mode Name"),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 10.0),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: ln,
              decoration: InputDecoration(hintText: "Mode Label"),
            ),
          ),
          Slider(
              activeColor: Colors.cyan[800],
              inactiveColor: Colors.cyan[100],
              min: 0.0,
              max: 10.0,
              value: _val,
              label: "${_val.toInt()}",
              divisions: 10,
              onChanged: (val) {
                setState(() {
                  _val = val;
                });
              }),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () async {
                try {
                  final pickedFile =
                      await picker.getImage(source: ImageSource.gallery);

                  setState(() {
                    if (pickedFile != null) {
                      _image = File(pickedFile.path);
                      //  print(pickedFile);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("No image selected")));
                    }
                  });
                } catch (e) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text("$e")));
                }
              },
              child: Container(
                color: Colors.blueGrey[300].withOpacity(.5),
                height: 130.0,
                child: _image == null
                    ? Center(
                        child: Text(
                          "Search for images in device",
                          style: TextStyle(color: Colors.cyan[800]),
                        ),
                      )
                    : Image.file(_image, fit: BoxFit.cover),
              ),
            ),
          ),
          Container(
            color: Colors.transparent,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
            height: MediaQuery.of(context).size.height / 8,
            child: CupertinoTimerPicker(
              mode: CupertinoTimerPickerMode.hm,
              onTimerDurationChanged: (x) {
                setState(() {
                  timeHour = x.inHours;
                  timeMinute = x.inMinutes % 60;
                });
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 15,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.cyan),
              child: Text("Save Study Mode"),
              onPressed: () async {
                for (var i in k) {
                  if (_val == i) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content:
                            Text("Mode with this intensity already exists")));
                  } else {
                    for (var i in v) {
                      if (mn.text == i['mode']) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Mode with this name already exists")));
                      }
                      if (ln.text == i['label']) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content:
                                Text("Mode with this label already exists")));
                      } else {
                        StudyModesDatabase().add(_val.toInt(), mn.text, ln.text,
                            _image.path.toString(), timeHour, timeMinute);
                      }
                    }
                  }
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
