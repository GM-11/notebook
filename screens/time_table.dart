import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notebook/databases/sa.dart';
import 'package:notebook/databases/time_table_data.dart';
import 'package:notebook/paints/clock.dart';

import 'package:notebook/shared/dialogs/add_work.dart';
import 'package:notebook/shared/providers.dart';
import 'package:notebook/shared/shared_prefs.dart';

final sample = StateProvider<DateTime>((ref) {
  return DateTime.now();
});

class DateTimeTable extends StatefulWidget {
  @override
  _DateTimeTableState createState() => _DateTimeTableState();
}

class _DateTimeTableState extends State<DateTimeTable> {
  @override
  Widget build(BuildContext context) {
    var md = UserPreferences.getMode();
    final _style = TextStyle(color: Colors.white, fontWeight: FontWeight.w600);
    return Scaffold(
      appBar: AppBar(
        title: Text("Study Time Table", style: _style.copyWith(fontSize: 20.0)),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 40.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 1,
                  child: TweenAnimationBuilder(
                    duration: Duration(milliseconds: 500),
                    tween: Tween<double>(begin: 0, end: 1),
                    curve: Curves.decelerate,
                    builder: (context, _val, child) {
                      return Opacity(
                        opacity: _val,
                        child: Padding(
                            child: child,
                            padding: EdgeInsets.only(left: _val * 7)),
                      );
                    },
                    child: Text("${context.read(dateProvider).p}",
                        style: _style.copyWith(fontSize: 25.0)),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: TweenAnimationBuilder(
                    duration: Duration(milliseconds: 500),
                    tween: Tween<double>(begin: 0, end: 1),
                    curve: Curves.decelerate,
                    builder: (context, _val, child) {
                      return Opacity(
                        opacity: _val,
                        child: Padding(
                            child: child, padding: EdgeInsets.only(left: _val)),
                      );
                    },
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: Colors.cyan[800]),
                      child: Text(
                        "Add work",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                            isScrollControlled: false,
                            context: context,
                            builder: (context) => Container(
                                  child: AddDialog(
                                      day: context.read(dateProvider).p),
                                  color: Colors.transparent,
                                ));
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
          Clock(),
          TimeTableList(),
        ],
      ),
    );
  }
}

class TimeTableList extends StatefulWidget {
  @override
  _TimeTableListState createState() => _TimeTableListState();
}

class _TimeTableListState extends State<TimeTableList> {
  @override
  Widget build(BuildContext context) {
    TimeTableDatabase _ttb = TimeTableDatabase();

    return ValueListenableBuilder(
        valueListenable: Hive.box("Time_Table").listenable(),
        builder: (context, Box box, _) {
          if (box.values.isEmpty) {
            return Center(
              child: Text("No work added",
                  style: TextStyle(color: Colors.blueGrey)),
            );
          }

          return ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: box.values.length,
              itemBuilder: (context, index) {
                Subjects s = Hive.box<Subjects>("Subjects")
                    .get(box.getAt(index)['subject']);

                List<Color> colors = [];

                s != null
                    ? s.colorsList.forEach((element) {
                        colors.add(element);
                      })
                    : colors = [];

                String diem = box.getAt(index)["timeHour"] > 12 ? "PM" : "AM";
                String minute = box.getAt(index)['timeMinute'] > 10
                    ? "${box.getAt(index)['timeMinute']}"
                    : "0${box.getAt(index)['timeMinute']}";

                int hour = box.getAt(index)['timeHour'] > 12
                    ? box.getAt(index)['timeHour'] - 12
                    : box.getAt(index)['timeHour'];
                minute = box.getAt(index)['timeMinute'] > 10
                    ? "${box.getAt(index)['timeMinute']}"
                    : "0${box.getAt(index)['timeMinute']}";

                int eHour = (hour + box.getAt(index)['durHour']) % 12;
                int eMinute = (box.getAt(index)['timeMinute'] +
                        box.getAt(index)['durMin']) %
                    60;

                String em = eMinute > 10 ? "$eMinute" : "0$eMinute";
                return Slidable(
                  actionPane: SlidableScrollActionPane(),
                  secondaryActions: [
                    IconSlideAction(
                        caption: "Done",
                        icon: Icons.done,
                        onTap: () {
                          _ttb.markWorkAsDone(
                              box.getAt(index)['work'],
                              box.getAt(index)['timeHour'],
                              box.getAt(index)["timeMinute"],
                              box.getAt(index)['durHour'],
                              box.getAt(index)["durMin"]);
                        })
                  ],
                  actions: [
                    IconSlideAction(
                        caption: "Delete",
                        icon: Icons.delete,
                        onTap: () {
                          _ttb.deleteWork(box.getAt(index)['work']);
                        })
                  ],
                  child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 8,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            gradient: LinearGradient(
                                colors: box.getAt(index)['done']
                                    ? [Colors.blueGrey, Colors.blueGrey[800]]
                                    : box
                                            .getAt(index)['subject']
                                            .toString()
                                            .isNotEmpty
                                        ? colors
                                        : [Colors.pink, Colors.purple])),
                        child: ListTile(
                            trailing: box.getAt(index)['done']
                                ? Text("Done",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w600))
                                : SizedBox(height: 0.0, width: 0.0),
                            title: Text(
                              box.getAt(index)['work'],
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 21.0),
                            ),
                            subtitle: Text(
                              "$hour:$minute $diem - $eHour:$em $diem",
                              style: TextStyle(color: Colors.white),
                            )),
                      )),
                );
              });
        });
  }
}
