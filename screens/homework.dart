import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notebook/databases/sa.dart';
import 'package:notebook/databases/subjects_data.dart';
import 'package:notebook/shared/dialogs/add_hw.dart';
import 'package:notebook/shared/providers.dart';
import 'package:notebook/shared/shared_prefs.dart';
import 'package:notebook/shared/side_bar/side_bar_drawer.dart';

// ignore: must_be_immutable
class Homework extends ConsumerWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String subjectName;

  Subjects s;
  List<Color> l = [];

  TextStyle _style =
      TextStyle(color: Colors.white, fontWeight: FontWeight.w600);

  @override
  Widget build(BuildContext context, see) {
    if (see(subjectProvider).state == "") {
      subjectName = UserPreferences.getSubject() ?? "";
    } else {
      subjectName = see(subjectProvider).state;
    }
    s = Hive.box<Subjects>("Subjects").get(subjectName);

    return Container(
      color: Colors.transparent,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            actions: [
              subjectName == ""
                  ? SizedBox(height: 0.0, width: 0.0)
                  : IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) =>
                                AddHomework(subjectName: subjectName));
                      },
                      icon: Icon(Icons.add))
            ],
            title: Text(
              "Homeworks",
              style: _style,
            ),
            elevation: 0.0,
          ),
          key: _scaffoldKey,
          drawer: Container(
            child: SideBar(),
            margin: EdgeInsets.only(right: 70.0),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 1,
                      child: TweenAnimationBuilder(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.decelerate,
                        tween: Tween<double>(begin: 0, end: 1),
                        builder: (context, _val, child) {
                          return Opacity(
                            opacity: _val,
                            child: Padding(
                                child: child,
                                padding: EdgeInsets.only(
                                  right: _val * 20,
                                  top: 15.0,
                                  bottom: 15.0,
                                )),
                          );
                        },
                        child: Text(
                          subjectName,
                          style: TextStyle(
                            color: subjectName == null
                                ? Colors.transparent
                                : Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 30.0,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 7,
                      child: ValueListenableBuilder(
                          valueListenable: Hive.box("Homeworks").listenable(),
                          builder: (context, Box box, _) {
                            List list = box.values
                                .where((element) =>
                                    element['subject'] == subjectName)
                                .toList();

                            if (box.isEmpty) {
                              return Center(
                                  child: Text(
                                "No homework available",
                                style: _style,
                              ));
                            } else {
                              return ListView.builder(
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    List<Color> colors = [];

                                    s != null
                                        ? s.colorsList.forEach((element) {
                                            colors.add(element);
                                          })
                                        : colors = [];
                                    return Slidable(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: 8.0, right: 8.0, left: 8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            gradient:
                                                LinearGradient(colors: colors),
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                          alignment: Alignment.centerLeft,
                                          height: 90.0,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  list[index]["hw"],
                                                  style: _style.copyWith(
                                                      fontSize: 25.0),
                                                ),
                                                Text(
                                                  "Due Date: ${list[index]['lastDate']}",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: colors[0]),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      actionPane: SlidableScrollActionPane(),
                                      secondaryActions: [
                                        IconSlideAction(
                                          caption: "Done",
                                          icon: Icons.done,
                                          onTap: () {
                                            SubjectsDatabase()
                                                .markHomeworkAsDone(
                                                    subjectName,
                                                    list[index]["hw"],
                                                    list[index]["lastDate"]);
                                          },
                                        )
                                      ],
                                      actions: [
                                        IconSlideAction(
                                          caption: "Delete",
                                          icon: Icons.delete,
                                          onTap: () {
                                            SubjectsDatabase().deleteHomework(
                                                subjectName, list[index]["hw"]);
                                          },
                                        )
                                      ],
                                    );
                                  });
                            }
                          }),
                    )
                  ],
                ),
              ],
            ),
          )),
    );
  }
}
