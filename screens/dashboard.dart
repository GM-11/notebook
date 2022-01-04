import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:hive/hive.dart';
import 'package:notebook/auth/auth_service/auth_service.dart';
import 'package:notebook/databases/sa.dart';
import 'package:notebook/shared/shared_prefs.dart';
import 'package:notebook/wrapper.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List _ttlist = Hive.box("Time_Table").values.toList();
  List _hwlist = Hive.box("Homeworks").values.toList();
  List _subjectList = Hive.box<Subjects>("Subjects").keys.toList();
  int dt = 0;
  int dh = 0;
  bool hExpand = false;

  List _list;

  @override
  void initState() {
    for (var i in _subjectList) {
      print(_hwlist.where((element) => element['subject'] == i).toList());
      // _list.add({
      //   "subject": i,
      //   'hw': _hwlist.where((element) => element['subject'] == i).toList()
      // });
    }
    if (_ttlist.length != null) {
      _ttlist.forEach((element) {
        if (element['done'] == true) {
          dt++;
        }
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int doneTasks = dt;
    int totalTasks = _ttlist.length;
    int doneHomeworks = dh;
    int totalHomeworks = _hwlist.length;
    int noss = UserPreferences.getStudyModeIndex() ?? 0;
    TextStyle _style = TextStyle(
        fontWeight: FontWeight.w600, color: Colors.white, fontSize: 15.0);
    List<Widget> list = [
      Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Number of study sessions today:", style: _style),
            Text("$noss", style: _style.copyWith(fontSize: 45.0))
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.blueGrey.withOpacity(.5)),
      ),
      Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text("Work completion today:", style: _style),
            Text(totalTasks == 0 ? "No work today" : "$doneTasks/$totalTasks",
                style: _style.copyWith(fontSize: totalTasks == 0 ? 27.0 : 45.0))
          ],
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.blueGrey.withOpacity(.5)),
      ),
      Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: Colors.blueGrey.withOpacity(.5)),
        child: ExpansionTile(
          maintainState: true,
          children: _subjectList.map((e) => Text(e)).toList(),
          onExpansionChanged: (_) {
            setState(() {
              hExpand = !hExpand;
            });
          },
          title: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text("Homeworks done:", style: _style),
              Text(
                  totalHomeworks == 0
                      ? "No homework for now"
                      : "$doneHomeworks/$totalHomeworks",
                  style: _style.copyWith(
                      fontSize: totalHomeworks == 0 ? 15.0 : 27.0))
            ],
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          return showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text("Are you sure you want to logout?"),
                    actions: [
                      TextButton(
                          onPressed: () {
                            UserPreferences.clearEverything();
                            Hive.deleteFromDisk();
                            Authentications().logout();
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Wrapper()));
                          },
                          child: Text("Yes")),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("No")),
                    ],
                  ));
        },
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Center(child: Text("Logout", style: _style)),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: Colors.blueGrey.withOpacity(.5)),
        ),
      ),
    ];
    return Scaffold(
        appBar: AppBar(
          title: Text("Dashboard"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StaggeredGridView.countBuilder(
              crossAxisSpacing: 5.0,
              mainAxisSpacing: 5.0,
              itemCount: list.length,
              crossAxisCount: 4,
              itemBuilder: (context, index) {
                return list[index];
              },
              staggeredTileBuilder: (int index) {
                int x;
                double y;

                switch (index) {
                  case 0:
                    x = 2;
                    y = 2;
                    break;

                  case 1:
                    x = 2;
                    y = 3;
                    break;

                  case 2:
                    x = 2;
                    y = hExpand ? 4 : 2;
                    break;
                  default:
                    x = 1;
                    y = 1;
                }

                return StaggeredTile.count(x, y);
              }),
        ));
  }
}
