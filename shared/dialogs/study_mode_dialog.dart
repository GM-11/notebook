import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notebook/screens/settings/edit_study_mode.dart';
import 'package:notebook/screens/study_mode.dart';
import 'package:notebook/shared/providers.dart';

// ignore: must_be_immutable
class SelectStudyMode extends StatefulWidget {
  bool np;
  SelectStudyMode({this.np});
  @override
  _SelectStudyModeState createState() => _SelectStudyModeState();
}

class _SelectStudyModeState extends State<SelectStudyMode> {
  int index = 0;
  double _currentSliderValue = 0;
  List modes = [];
  List labels = [];
  List duration = [];
  List images = [];

  @override
  void initState() {
    setState(() {
      Hive.box("Study_Modes").values.forEach((element) {
        modes.add(element['mode']);
        labels.add(element['label']);
        images.add(element['imageSrc']);
        duration.add({
          "hours": element['duration']['hours'],
          "minutes": element['duration']['minutes']
        });
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20.0),
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
              elevation: 0,
              backgroundColor: Colors.transparent,
              insetPadding: EdgeInsets.zero,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Choose your Study Mode",
                    style: TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditStudyModeSettings()));
                      },
                      icon:
                          Icon(Icons.settings, size: 20.0, color: Colors.white))
                ],
              ),
              content: Container(
                width: MediaQuery.of(context).size.width - 80,
                height: screenHeight / 1.4,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        child: Center(
                            child: images[index]
                                    .toString()
                                    .contains("image_picker")
                                ? Image.file(File(images[index]))
                                : Image.asset(images[index])),
                        height: 200.0,
                        width: double.infinity,
                        color: Colors.transparent,
                      ),
                    ),
                    SizedBox(
                      height: 20.0,
                    ),
                    Text(modes[index], style: TextStyle(color: Colors.white)),
                    SizedBox(height: 5),
                    Text(labels[index],
                        style: TextStyle(fontSize: 8, color: Colors.white)),
                    SizedBox(height: 20.0),
                    Text(
                        "${duration[index]['hours']} hours ${duration[index]['minutes']} minutes",
                        style: TextStyle(fontSize: 20, color: Colors.white)),
                    SizedBox(height: 5.0),
                    Slider(
                      activeColor: Colors.blueGrey[200],
                      inactiveColor: Colors.blueGrey[400],
                      value: _currentSliderValue,
                      min: 0,
                      max: modes.toSet().toList().length.toDouble() - 1.00,
                      divisions: modes.toSet().toList().length - 1,
                      onChanged: (double value) {
                        setState(() {
                          _currentSliderValue = value;
                          index = value.toInt();
                        });
                      },
                    ),
                    Consumer(
                      builder: (BuildContext context,
                          T Function<T>(ProviderBase<Object, T>) see,
                          Widget child) {
                        return GestureDetector(
                          onTap: () async {
                            if (widget.np == false) {
                              see(modesProvider).setMode(
                                  modes[index],
                                  labels[index],
                                  duration[index]['hours'].toInt(),
                                  duration[index]['minutes'],
                                  images[index]);

                              Navigator.pop(context);
                            } else {
                              see(modesProvider).setMode(
                                  modes[index],
                                  labels[index],
                                  duration[index]['hours'].toInt(),
                                  duration[index]['minutes'],
                                  images[index]);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => StudyMode()));
                            }
                          },
                          child: Text(
                            "Start Studying",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Not Now",
                          style: TextStyle(fontSize: 15, color: Colors.white),
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
