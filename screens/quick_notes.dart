import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:notebook/databases/notes_data.dart';
import 'package:notebook/databases/sa.dart';
import 'package:notebook/shared/dialogs/add_note.dart';

import 'package:hive_flutter/hive_flutter.dart';

class QuickNotes extends StatefulWidget {
  @override
  _QuickNotesState createState() => _QuickNotesState();
}

class _QuickNotesState extends State<QuickNotes> {
  String searched = "";
  bool searchOn = false;
  TextEditingController t = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                showDialog(
                    context: context, builder: (context) => AddNoteDialog());
              }),
          IconButton(
              onPressed: () {
                setState(() {
                  searchOn = !searchOn;
                });
              },
              icon: Icon(searchOn ? Icons.close : Icons.search))
        ],
        title: searchOn
            ? Container(
                padding: EdgeInsets.all(2.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.white.withOpacity(.2)),
                child: TextField(
                    onChanged: (x) {
                      setState(() {
                        searched = x;
                      });
                    },
                    decoration: InputDecoration(hintText: "Search Notes"),
                    controller: t,
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white),
              )
            : Text("Quick Notes"),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box("Quick_Notes").listenable(),
        builder: (BuildContext context, Box box, Widget child) {
          List list = box.values.toList();

          if (box.values.isEmpty) {
            return Center(
              child: Text("No notes available ",
                  style: TextStyle(
                      color: Colors.blueGrey, fontWeight: FontWeight.w600)),
            );
          }
          return GridView.count(
            crossAxisCount: 2,
            scrollDirection: Axis.vertical,
            childAspectRatio: 1,
            children: list.map<Widget>((d) {
              Subjects s = Hive.box<Subjects>("Subjects").get(d['subject']);

              List<Color> colors = [];

              s != null
                  ? s.colorsList.forEach((element) {
                      colors.add(element);
                    })
                  : colors = [];

              if (d['title']
                  .toString()
                  .toLowerCase()
                  .contains(searched.toLowerCase())) {
                return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 3.0),
                    child: TweenAnimationBuilder(
                      duration: Duration(milliseconds: 500),
                      tween: Tween<double>(begin: 0, end: 1),
                      curve: Curves.decelerate,
                      builder: (context, _val, child) {
                        return Opacity(opacity: _val, child: child);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(7.0),
                        child: PhysicalModel(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.transparent,
                          elevation: 3.0,
                          child: GestureDetector(
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (context) => Note(
                                        title: d['title'],
                                        content: d['content'],
                                        subject: d['subject'],
                                        colors: colors.isEmpty
                                            ? [Colors.purple[500], Colors.pink]
                                            : colors,
                                      ));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: s != null
                                          ? colors
                                          : [Colors.purple[500], Colors.pink]),
                                  borderRadius: BorderRadius.circular(20.0)),
                              padding: EdgeInsets.symmetric(horizontal: 5.0),
                              height: MediaQuery.of(context).size.height,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                //    mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, top: 15.0),
                                    child: Text(d['title'],
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                  Divider(),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      d['content']
                                                  .toString()
                                                  .characters
                                                  .toList()
                                                  .length >
                                              5
                                          ? d['content'].toString() + ".."
                                          : d['content'],
                                      maxLines: 2,
                                      style: TextStyle(color: Colors.grey[100]),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      d['subject'],
                                      maxLines: 2,
                                      style: TextStyle(color: Colors.grey[100]),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ));
              } else {
                return Container();
              }
            }).toList(),
          );
        },
      ),
    );
  }
}

class Note extends StatefulWidget {
  String title;
  String content;
  String subject;
  List<Color> colors;
  Note({this.content, this.title, this.subject, this.colors});

  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
  bool editOn = false;
  TextEditingController oTitle = TextEditingController();
  TextEditingController oContent = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 130.0, horizontal: 30.0),
      child: Card(
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: widget.colors),
              borderRadius: BorderRadius.circular(10.0)),
          child: Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 8.0, bottom: 8.0, left: 19.0),
                      child: Text(
                        widget.subject,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Wrap(
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit,
                              color: editOn ? Colors.white : Colors.grey[700]),
                          onPressed: () {
                            setState(() {
                              editOn = !editOn;
                            });
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.close, color: Colors.grey[700]),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        IconButton(
                            icon: Icon(Icons.delete, color: Colors.grey[700]),
                            onPressed: () async {
                              NotesDatabase()
                                  .deleteNote(widget.title, widget.subject);
                              Navigator.pop(context);
                            })
                      ],
                    ),
                  ],
                ),
                Divider(thickness: 1, indent: 20.0, endIndent: 20.0),
                ListTile(
                  title: editOn
                      ? TextFormField(
                          controller: oTitle,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: widget.title,
                          ),
                          showCursor: true,
                          cursorColor: Colors.white,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600),
                        )
                      : Text(
                          widget.title,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.w600),
                        ),
                ),
                Divider(thickness: 1, indent: 20.0, endIndent: 20.0),
                Expanded(
                  flex: 5,
                  child: Scrollable(
                    viewportBuilder: (context, offSet) => Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: editOn
                            ? TextFormField(
                                cursorColor: Colors.white,
                                style: TextStyle(color: Colors.white),
                                controller: oContent,
                                keyboardType: TextInputType.multiline,
                                minLines: 1,
                                maxLines: 20,
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: widget.content),
                              )
                            : Text(
                                widget.content,
                                style: TextStyle(color: Colors.white),
                              ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black.withOpacity(.4),
                    ),
                    child: TextButton(
                        onPressed: oTitle.text.isEmpty || oContent.text.isEmpty
                            ? () {
                                return NotesDatabase().updateNote(
                                    widget.title,
                                    widget.subject,
                                    widget.content,
                                    DateFormat("dd-MM-yyyy")
                                        .format(DateTime.now()),
                                    updatedTitle: oTitle.text,
                                    updatedContent: oContent.text);
                              }
                            : null,
                        child: Text(
                          "Save Changes",
                          style: TextStyle(color: Colors.white),
                        )),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
