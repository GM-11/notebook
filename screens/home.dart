import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:notebook/screens/homework.dart';
import 'package:notebook/screens/quick_notes.dart';
import 'package:notebook/screens/dashboard.dart';
import 'package:notebook/screens/study_mode.dart';
import 'package:notebook/screens/time_table.dart';
import 'package:notebook/shared/dialogs/study_mode_dialog.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> screensList = [
      DateTimeTable(),
      Homework(),
      StudyMode(),
      Dashboard(),
      QuickNotes(),
    ];

    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
        Colors.cyan[900],
        Colors.cyan[600],
        Colors.cyan[300],
        Colors.cyan[50],
        Colors.white
      ], begin: Alignment.topCenter, end: Alignment.center)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBody: true,
        body: screensList.elementAt(_selectedIndex),
        floatingActionButton: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.cyan[800],
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) => SelectStudyMode(np: true));
            },
            elevation: 0.0,
            child: Icon(Icons.anchor),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: Container(
          height: MediaQuery.of(context).size.height / 11,
          child: BottomAppBar(
            elevation: 0.0,
            color: Colors.cyan[800],
            shape: CircularNotchedRectangle(),
            child: Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Transform.scale(
                    scale: 1.2,
                    child: GestureDetector(
                      onTap: _selectedIndex == 0
                          ? () {}
                          : () {
                              setState(() {
                                _selectedIndex = 0;
                              });
                            },
                      child: AnimatedContainer(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0)),
                        duration: Duration(milliseconds: 200),
                        height: 32.0,
                        width: 32.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _selectedIndex == 0
                                ? Icon(Icons.circle,
                                    size: 5.0, color: Colors.white)
                                : SizedBox(height: 5.0, width: 0.0),
                            FaIcon(
                              FontAwesomeIcons.table,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: 1.2,
                    child: GestureDetector(
                      onTap: _selectedIndex == 1
                          ? () {}
                          : () {
                              setState(() {
                                _selectedIndex = 1;
                              });
                            },
                      child: AnimatedContainer(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0)),
                        duration: Duration(milliseconds: 200),
                        height: 32.0,
                        width: 32.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _selectedIndex == 1
                                ? Icon(Icons.circle,
                                    size: 5.0, color: Colors.white)
                                : SizedBox(height: 5.0, width: 0.0),
                            FaIcon(
                              FontAwesomeIcons.book,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: 1.2,
                    child: GestureDetector(
                      onTap: _selectedIndex == 3
                          ? () {}
                          : () {
                              setState(() {
                                _selectedIndex = 3;
                              });
                            },
                      child: AnimatedContainer(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0)),
                        duration: Duration(milliseconds: 200),
                        height: 32.0,
                        width: 32.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _selectedIndex == 3
                                ? Icon(Icons.circle,
                                    size: 5.0, color: Colors.white)
                                : SizedBox(height: 5.0, width: 0.0),
                            FaIcon(
                              FontAwesomeIcons.chartBar,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Transform.scale(
                    scale: 1.2,
                    child: GestureDetector(
                      onTap: _selectedIndex == 4
                          ? () {}
                          : () {
                              setState(() {
                                _selectedIndex = 4;
                              });
                            },
                      child: AnimatedContainer(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0)),
                        duration: Duration(milliseconds: 200),
                        height: 32.0,
                        width: 32.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _selectedIndex == 4
                                ? Icon(Icons.circle,
                                    size: 5.0, color: Colors.white)
                                : SizedBox(height: 5.0, width: 0.0),
                            FaIcon(
                              FontAwesomeIcons.clipboard,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
