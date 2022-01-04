import 'package:flutter/material.dart';
import 'package:notebook/shared/shared_prefs.dart';

class TimeTableSettings extends StatefulWidget {
  @override
  _TimeTableSettingsState createState() => _TimeTableSettingsState();
}

class _TimeTableSettingsState extends State<TimeTableSettings> {
  String s1;
  String changedS1;
  @override
  void initState() {
    s1 = UserPreferences.getMode();
    changedS1 = s1;
    super.initState();
  }

  @override
  void dispose() {
    UserPreferences.setMode(changedS1);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _style = TextStyle(
        color: Colors.cyan[800], fontWeight: FontWeight.w600, fontSize: 20.0);

    final _boxStyle = BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.blueGrey[200].withOpacity(.3));

    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: true,
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 5.0, right: 5.0),
        child: ListView(
          children: [
            // time table options

            // create an expansion tile to select multiple options of time table
            Container(
              decoration: _boxStyle,
              child: ExpansionTile(
                title: Text(
                  'Time Table Options',
                  style: _style,
                ),
                children: [
                  // create a list of radio buttons to select the time table mode
                  RadioListTile(
                    title: Text(
                      'Both',
                      style: _style,
                    ),
                    value: 'oth',
                    groupValue: s1,
                    activeColor: Colors.cyan[800],
                    onChanged: (value) {
                      setState(() {
                        changedS1 = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text(
                      'List',
                      style: _style,
                    ),
                    value: 'list',
                    groupValue: s1,
                    activeColor: Colors.cyan[800],
                    onChanged: (value) {
                      setState(() {
                        changedS1 = value;
                      });
                    },
                  ),
                  RadioListTile(
                    title: Text(
                      'Clock',
                      style: _style,
                    ),
                    value: 'clock',
                    groupValue: s1,
                    activeColor: Colors.cyan[800],
                    onChanged: (value) {
                      setState(() {
                        changedS1 = value;
                      });
                    },
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.0),

            // same time table for multiple days
            Container(
              decoration: _boxStyle,
              child: ExpansionTile(
                tilePadding: EdgeInsets.all(15.0),
                title: Text("Time Table for multiple days", style: _style),
                children: [
                  RadioListTile(
                      activeColor: Colors.cyan,
                      title: Text(
                        "Daily time table",
                        style: _style.copyWith(fontSize: 15.0),
                      ),
                      value: "daily",
                      groupValue: UserPreferences.getTT(),
                      onChanged: (val) {
                        UserPreferences.setTT(val);
                        setState(() {});
                      }),
                  RadioListTile(
                      activeColor: Colors.cyan,
                      title: Text(
                        "Weekly time table",
                        style: _style.copyWith(fontSize: 15.0),
                      ),
                      value: "weekly",
                      groupValue: UserPreferences.getTT(),
                      onChanged: (val) {
                        UserPreferences.setTT(val);
                        setState(() {});
                      }),
                  RadioListTile(
                      activeColor: Colors.cyan,
                      title: Text(
                        "Time table for weekdays and weekends",
                        style: _style.copyWith(fontSize: 15.0),
                      ),
                      value: "weekdays",
                      groupValue: UserPreferences.getTT(),
                      onChanged: (val) {
                        UserPreferences.setTT(val);
                        setState(() {});
                      }),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class TimeTableForMultipleDays extends StatefulWidget {
  @override
  _TimeTableForMultipleDaysState createState() =>
      _TimeTableForMultipleDaysState();
}

class _TimeTableForMultipleDaysState extends State<TimeTableForMultipleDays> {
  int y = 8;
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height / y;
    final _style = TextStyle(
        color: Colors.cyan[800], fontWeight: FontWeight.w600, fontSize: 20.0);

    final _boxStyle = BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.blueGrey[200].withOpacity(.3));
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              AnimatedContainer(
                curve: Curves.easeIn,
                duration: Duration(milliseconds: 400),
                child: ListTile(
                    onTap: () {
                      setState(() {
                        y == 8 ? y = 5 : y = 8;
                      });
                    },
                    title: Text("Daily same time table", style: _style)),
                height: h,
                width: MediaQuery.of(context).size.width / 8,
                decoration: _boxStyle,
              )
            ],
          ),
        ),
      ),
    );
  }
}
