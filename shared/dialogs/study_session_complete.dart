import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:notebook/databases/records_data.dart';
import 'package:notebook/shared/shared_prefs.dart';

// ignore: must_be_immutable
class StudyModeDetails extends StatefulWidget {
  String mode;
  int timeHour;
  int timeMinute;
  var input;
  StudyModeDetails(this.mode, this.timeHour, this.timeMinute, this.input);

  @override
  _StudyModeDetailsState createState() => _StudyModeDetailsState();
}

class _StudyModeDetailsState extends State<StudyModeDetails> {
  String selectedResponse;
  List responses = ["Yeah!!", "Kind of", "Naah"];

  @override
  Widget build(BuildContext context) {
    RecordsDatabase r = RecordsDatabase();
    PageController _controller = PageController();
    return PageView(
      controller: _controller,
      physics: selectedResponse == null
          ? NeverScrollableScrollPhysics()
          : BouncingScrollPhysics(),
      children: [
        Scaffold(
            backgroundColor: Colors.cyan[50],
            body: GestureDetector(
              onTap: () {
                _controller.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              },
              child: Padding(
                padding: EdgeInsets.only(top: 40.0, left: 8.0, right: 8.0),
                child: Center(
                    child: Text(
                  "Yeah I'm done",
                  style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 20.0,
                      fontWeight: FontWeight.w600),
                )),
              ),
            )),
        Scaffold(
          backgroundColor: Colors.cyan[50],
          body: GestureDetector(
            onTap: () {
              _controller.nextPage(
                  duration: Duration(milliseconds: 200), curve: Curves.ease);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0, left: 8.0, right: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Was your study session productive?",
                    style: TextStyle(
                        color: Colors.cyan[800],
                        fontWeight: FontWeight.w600,
                        fontSize: 30.0),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedResponse == responses[0]
                                      ? selectedResponse = null
                                      : selectedResponse = responses[0];
                                });

                                _controller.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.ease);
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: selectedResponse == responses[0]
                                        ? Colors.cyan[800]
                                        : Colors.transparent),
                                child: Text(
                                  responses[0],
                                  style: TextStyle(
                                      color: selectedResponse == responses[0]
                                          ? Colors.white
                                          : Colors.cyan[800],
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedResponse == responses[1]
                                      ? selectedResponse = null
                                      : selectedResponse = responses[1];
                                });
                                _controller.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.ease);
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: selectedResponse == responses[1]
                                        ? Colors.cyan[800]
                                        : Colors.transparent),
                                child: Text(
                                  responses[1],
                                  style: TextStyle(
                                      color: selectedResponse == responses[1]
                                          ? Colors.white
                                          : Colors.cyan[800],
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedResponse == responses[2]
                                      ? selectedResponse = ""
                                      : selectedResponse = responses[2];
                                });
                                _controller.nextPage(
                                    duration: Duration(milliseconds: 300),
                                    curve: Curves.ease);
                              },
                              child: AnimatedContainer(
                                duration: Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(15.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: selectedResponse == responses[2]
                                        ? Colors.cyan[800]
                                        : Colors.transparent),
                                child: Text(
                                  responses[2],
                                  style: TextStyle(
                                      color: selectedResponse == responses[2]
                                          ? Colors.white
                                          : Colors.cyan[800],
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Scaffold(
          backgroundColor: Colors.cyan[50],
          body: Padding(
            padding: const EdgeInsets.only(
                bottom: 8.0, left: 10.0, right: 10.0, top: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  selectedResponse == responses[0]
                      ? "Yo champ! I think if you continue, you'll soon become an expert🤔"
                      : selectedResponse == responses[1]
                          ? "Good, progress everyday will make you better everyday👍"
                          : "It's fine, what is important is that you stay consistent🙌",
                  style: TextStyle(
                      color: Colors.cyan[800],
                      fontSize: 25.0,
                      fontWeight: FontWeight.w600),
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.cyan[800]),
                    onPressed: () {
                      int output;

                      if (selectedResponse == responses[0]) {
                        output = 2;
                      } else if (selectedResponse == responses[1]) {
                        output = 1;
                      } else {
                        output = 0;
                      }

                      int x = UserPreferences.getStudyModeIndex() ?? 0;

                      print("index is $x");

                      r.saveStudySession(
                          widget.mode,
                          widget.timeHour,
                          widget.timeMinute,
                          output,
                          DateFormat("dd-MM-yy").format(DateTime.now()),
                          widget.input,
                          x + 1);

                      UserPreferences.setStudyModeIndex(x + 1);

                      Future.delayed(Duration(milliseconds: 1000));

                      Navigator.pop(context);
                    },
                    child: Text("Sure!"))
              ],
            ),
          ),
        )
      ],
    );
  }
}
