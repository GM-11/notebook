import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notebook/auth/auth_screens/register.dart';
import 'package:notebook/auth/welcome_screen.dart';

import 'package:notebook/paints/backgrounds.dart';
import 'package:notebook/shared/providers.dart';
import 'package:riverpod/riverpod.dart';

class DetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: DBG(),
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Container(
              padding: EdgeInsets.only(
                  top: 10.0, left: 20.0, right: 20.0, bottom: 10.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.white.withOpacity(.2)),
              height: MediaQuery.of(context).size.height * .6,
              alignment: Alignment.bottomCenter,
              child: Details(),
            ),
          ),
        ),
      ),
    );
  }
}

class Details extends StatefulWidget {
  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  List standards = [12, 11, 10, 9, 8, 7, 6, 5];
  List boards = [
    "CBSE",
    "ICSE",
    "NIOS",
    "UP Board",
    "J&K Board",
    "Bihar Board"
  ];
  List aims = [
    "JEE",
    "NEET",
    "UPSC",
    "NDA",
    "KVPY",
    "NEST",
    "AILET",
    "CAT",
    "Board Exams",
  ];
  String selectedAim;
  String selectedBoard;
  int selectedStandard;

  PageController _controller = PageController();
  @override
  Widget build(BuildContext context) {
    final _style = TextStyle(
        color: Colors.cyan[800], fontSize: 25.0, fontWeight: FontWeight.w600);
    return Consumer(builder: (BuildContext context,
        T Function<T>(ProviderBase<Object, T>) see, Widget child) {
      final aim = see(aimProvider).state;
      final standard = see(standardProvider).state;
      final board = see(boardProvider).state;

      return PageView(
        controller: _controller,
        children: [
          Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextButton(
                    onPressed: () {
                      _controller.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.easeInSine);
                    },
                    child: Text(
                      "I am new to notebook",
                      style: _style.copyWith(fontSize: 20.0),
                    )),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Register(signIn: true)));
                    },
                    child: Text(
                      "I already use notebook",
                      style: _style.copyWith(fontSize: 15.0),
                    )),
              ],
            ),
          ),
          ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Center(child: Text("Class", style: _style)),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                child: GridView.count(
                  physics: BouncingScrollPhysics(),
                  crossAxisCount: 2,
                  scrollDirection: Axis.vertical,
                  children: standards
                      .map<Widget>((e) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                if (standard == e.toString()) {
                                  see(standardProvider).state = null;
                                } else {
                                  see(standardProvider).state = e.toString();
                                  _controller.nextPage(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.easeInSine);
                                }
                              },
                              child: AnimatedContainer(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.cyan[800], width: 3.0),
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: standard == e.toString()
                                      ? Colors.cyan[800]
                                      : Colors.transparent,
                                ),
                                height: 50.0,
                                duration: Duration(milliseconds: 170),
                                child: Center(
                                  child: Text(
                                    e.toString() + "th",
                                    style: TextStyle(
                                        color: standard == e.toString()
                                            ? Colors.white
                                            : Colors.cyan[800],
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20.0),
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
          ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Center(child: Text("Board", style: _style)),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                child: GridView.count(
                  physics: BouncingScrollPhysics(),
                  crossAxisCount: 2,
                  scrollDirection: Axis.vertical,
                  children: boards
                      .map<Widget>((e) => GestureDetector(
                            onTap: () {
                              if (board == e) {
                                see(boardProvider).state = null;
                              } else {
                                see(boardProvider).state = e;
                                _controller.nextPage(
                                    duration: Duration(milliseconds: 500),
                                    curve: Curves.easeInSine);
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AnimatedContainer(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.cyan[800], width: 3.0),
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: board == e
                                      ? Colors.cyan[800]
                                      : Colors.transparent,
                                ),
                                height: 50.0,
                                duration: Duration(milliseconds: 170),
                                child: Center(
                                  child: Text(
                                    e.toString(),
                                    style: TextStyle(
                                        color: board == e
                                            ? Colors.white
                                            : Colors.cyan[800],
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20.0),
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
          ListView(
            physics: NeverScrollableScrollPhysics(),
            children: [
              Center(child: Text("Aim", style: _style)),
              Container(
                height: MediaQuery.of(context).size.height / 2,
                child: GridView.count(
                  physics: BouncingScrollPhysics(),
                  crossAxisCount: 2,
                  children: aims
                      .map<Widget>((e) => GestureDetector(
                            onTap: () {
                              if (aim == e) {
                                see(aimProvider).state = null;
                              } else {
                                see(aimProvider).state = e;
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AnimatedContainer(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.cyan[800], width: 3.0),
                                  borderRadius: BorderRadius.circular(30.0),
                                  color: aim == e
                                      ? Colors.cyan[800]
                                      : Colors.transparent,
                                ),
                                height: 50.0,
                                duration: Duration(milliseconds: 170),
                                child: Center(
                                  child: Text(
                                    e,
                                    style: TextStyle(
                                        color: aim == e
                                            ? Colors.white
                                            : Colors.cyan[800],
                                        fontWeight: FontWeight.w300,
                                        fontSize: 20.0),
                                  ),
                                ),
                              ),
                            ),
                          ))
                      .toList(),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
