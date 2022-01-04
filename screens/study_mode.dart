import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:notebook/databases/records_data.dart';
import 'package:notebook/shared/dialogs/study_mode_dialog.dart';
import 'package:notebook/shared/dialogs/study_session_complete.dart';

import 'package:notebook/shared/providers.dart';
import 'package:notebook/shared/shared_prefs.dart';
import 'package:timer_count_down/timer_controller.dart';
import 'package:timer_count_down/timer_count_down.dart';

// ignore: must_be_immutable
class StudyMode extends StatefulWidget {
  @override
  _StudyModeState createState() => _StudyModeState();
}

class _StudyModeState extends State<StudyMode> {
  CountdownController _controller = CountdownController();

  FlutterLocalNotificationsPlugin localNotificationsPlugin;

  bool timerOn = false;
  bool timerDone = false;
  bool timerPause = false;

  var hours;
  var minutes;
  var label;
  var mode;
  var iPath;

  RecordsDatabase r = RecordsDatabase();

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (BuildContext context,
        T Function<T>(ProviderBase<Object, T>) see, Widget child) {
      hours = see(modesProvider).hours;
      minutes = see(modesProvider).minutes;
      label = see(modesProvider).label;
      mode = see(modesProvider).mode;
      iPath = see(modesProvider).imgSrc;

      quit() {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Do you really want to quit?"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          int x = UserPreferences.getStudyModeIndex() ?? 0;

                          print("index is $x");

                          Navigator.pop(context);

                          see(modesProvider).setMode('', '', 0, 0, '');

                          r.saveStudySession(
                              mode,
                              hours,
                              minutes,
                              0,
                              DateFormat("dd-MM-yy").format(DateTime.now()),
                              1,
                              x + 1);
                          UserPreferences.setStudyModeIndex(x + 1);
                        },
                        child: Text("Yes")),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                  ],
                ));
      }

      return WillPopScope(
        onWillPop: hours == 0 && minutes == 0
            ? null
            : () {
                return quit();
              },
        child: Stack(
          children: [
            AnimatedContainer(
              duration: Duration(milliseconds: 500),
              child: ShaderMask(
                blendMode: BlendMode.darken,
                shaderCallback: (bounds) => LinearGradient(
                        colors: timerPause
                            ? [
                                Colors.blue.withOpacity(.5),
                                Colors.cyan.withOpacity(.8),
                              ]
                            : [
                                Colors.black.withOpacity(.6),
                                Colors.black.withOpacity(.3),
                                Colors.black.withOpacity(.1)
                              ],
                        end: Alignment.topCenter,
                        begin: Alignment.bottomCenter)
                    .createShader(bounds),
                child: Container(
                  decoration: BoxDecoration(
                      image: iPath == ""
                          ? null
                          : DecorationImage(
                              image: iPath.contains("image_picker")
                                  ? FileImage(File(iPath))
                                  : AssetImage(iPath),
                              fit: BoxFit.cover)),
                ),
              ),
            ),
            Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0.0,
                ),
                backgroundColor:
                    iPath.isEmpty ? Colors.white : Colors.transparent,
                body: SafeArea(
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          timerOn
                              ? TweenAnimationBuilder(
                                  duration: Duration(milliseconds: 1000),
                                  tween: Tween<double>(begin: 0, end: 1),
                                  curve: Curves.decelerate,
                                  builder: (context, _val, child) {
                                    return Opacity(
                                      opacity: _val,
                                      child: Padding(
                                          child: child,
                                          padding:
                                              EdgeInsets.only(top: _val * 7)),
                                    );
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        timerPause = !timerPause;
                                      });

                                      timerPause
                                          ? _controller.pause()
                                          : _controller.resume();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          border: Border.all(
                                              color: Colors.white, width: 3.0)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          timerPause ? "Resume" : "Pause",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 0.0,
                                ),
                          timerOn
                              ? TweenAnimationBuilder(
                                  duration: Duration(milliseconds: 1000),
                                  tween: Tween<double>(begin: 0, end: 1),
                                  curve: Curves.decelerate,
                                  builder: (context, _val, child) {
                                    return Opacity(
                                      opacity: _val,
                                      child: Padding(
                                          child: child,
                                          padding:
                                              EdgeInsets.only(top: _val * 7)),
                                    );
                                  },
                                  child: GestureDetector(
                                    onTap: () {
                                      return quit();
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                          border: Border.all(
                                              color: Colors.white, width: 3.0)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          "Quit",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : SizedBox(
                                  height: 0.0,
                                ),
                          Text(
                            mode,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 55.0,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 50.0),
                          timerOn
                              ? Countdown(
                                  onFinished: () {
                                    setState(() {
                                      timerDone = false;
                                    });

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StudyModeDetails(
                                                    mode, hours, minutes, 1)));
                                  },
                                  controller: _controller,
                                  interval: Duration(seconds: 1),
                                  seconds: minutes * 60 + hours * 3600,
                                  build: (BuildContext context, double timer) {
                                    return Text(
                                        hours == 0
                                            ? '${timer.toInt() ~/ 60} : ${timer.toInt() % 60}'
                                            : "${timer.toInt() ~/ 3600} : ${timer.toInt() ~/ 60 - ((timer.toInt() ~/ 3600) * 60)} : ${timer.toInt() % 60}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 35.0,
                                            fontWeight: FontWeight.w600));
                                  })
                              : Text(
                                  hours == 0
                                      ? '${(minutes * 60 + hours * 3600).toInt() ~/ 60} : ${(minutes * 60 + hours * 3600).toInt() % 60}'
                                      : "$hours : $minutes : ${(minutes * 60 + hours * 3600).toInt() % 60}",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 35.0,
                                      fontWeight: FontWeight.w600),
                                ),
                          iPath.isEmpty
                              ? Container(
                                  height: 50.0,
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: Colors.cyan),
                                    child: Text('Select a study mode'),
                                    onPressed: () {
                                      showDialog(
                                          context: context,
                                          builder: (context) =>
                                              SelectStudyMode(np: false));
                                    },
                                  ),
                                )
                              : Container(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 5.0),
                                  height: 50.0,
                                  width: !timerOn ? double.infinity : 0,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          primary: Colors.cyan),
                                      child: Text("Start Studying"),
                                      onPressed: () {
                                        setState(() {
                                          timerOn = true;
                                        });
                                      })),
                        ]),
                  ),
                )),
          ],
        ),
      );
    });
  }
}
