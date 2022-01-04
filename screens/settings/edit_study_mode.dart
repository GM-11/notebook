import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notebook/databases/study_modes_data.dart';
import 'package:notebook/screens/study_mode.dart';
import 'package:notebook/shared/dialogs/add_mode.dart';

class EditStudyModeSettings extends StatefulWidget {
  @override
  _EditStudyModeSettingsState createState() => _EditStudyModeSettingsState();
}

class _EditStudyModeSettingsState extends State<EditStudyModeSettings> {
  //List list = Hive.box("Study_Modes").values.toList();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.cyan[800],
          label: Text("Add a new mode"),
          onPressed: () {
            showModalBottomSheet(
                context: context, builder: (context) => AddModeSheet());
          },
        ),
        body: ValueListenableBuilder(
          valueListenable: Hive.box("Study_Modes").listenable(),
          builder: (context, Box box, _) {
            List list = box.values.toList();
            return ListView.builder(
                itemCount: box.values.length,
                itemBuilder: (context, index) {
                  final mode = list[index]['mode'];
                  final label = list[index]['label'];
                  final duration = list[index]['duration']; // map in itself
                  final image = list[index]['imageSrc'];

                  return GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) => ModeEditSheet(
                              mode: mode,
                              label: label,
                              imgPath: image,
                              index: index,
                              duration: duration));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 150.0,
                        child: Container(
                          padding: EdgeInsets.all(3.0),
                          decoration: BoxDecoration(
                              color: Colors.black.withOpacity(.5),
                              border: Border.all(
                                  width: 0.0,
                                  color: Colors.black.withOpacity(.5)),
                              borderRadius: BorderRadius.circular(10.0)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                mode,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                label,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.cyan, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: image.toString().contains("image_picker")
                                ? FileImage(File(image))
                                : AssetImage(image),
                            fit: BoxFit.cover,
                            colorFilter: ColorFilter.mode(
                                Colors.black.withOpacity(.1), BlendMode.darken),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          },
        ));
  }
}

class ModeEditSheet extends StatefulWidget {
  String mode;
  String label;
  String imgPath;
  int index;
  Map duration;
  ModeEditSheet(
      {this.mode, this.label, this.imgPath, this.index, this.duration});

  @override
  _ModeEditSheetState createState() => _ModeEditSheetState();
}

class _ModeEditSheetState extends State<ModeEditSheet> {
  bool editOn = false;
  TextEditingController a = TextEditingController();
  TextEditingController b = TextEditingController();
  TextEditingController c = TextEditingController();
  Box box = Hive.box("Study_Modes");
  File _image;
  ImagePicker picker = ImagePicker();
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height / 2.3,
      color: Colors.white,
      child: ListView(
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  editOn = !editOn;
                });
              },
              icon: Icon(Icons.edit)),
          editOn
              ? Container(
                  color: Colors.cyan[100],
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: a,
                    decoration: InputDecoration(hintText: "${widget.mode}"),
                  ),
                )
              : Text(
                  "${widget.mode}",
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w400),
                ),
          editOn
              ? Container(
                  color: Colors.cyan[100],
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: b,
                    decoration: InputDecoration(hintText: "${widget.label}"),
                  ),
                )
              : Text(
                  "${widget.label}",
                  style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w400),
                ),
          GestureDetector(
            onTap: editOn
                ? () async {
                    final pickedFile =
                        await picker.getImage(source: ImageSource.gallery);

                    setState(() {
                      if (pickedFile != null) {
                        _image = File(pickedFile.path);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("No image selected")));
                      }
                    });
                  }
                : null,
            child: widget.imgPath.toString().contains("image_picker")
                ? Image.file(File(widget.imgPath), height: 130.0)
                : Image.asset(widget.imgPath, height: 130.0),
          ),
          Container(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.cyan),
              child: Text("Save Changes"),
              onPressed: editOn
                  ? () {
                      StudyModesDatabase().editMode(
                          widget.index,
                          a.text.isEmpty ? widget.mode : a.text,
                          b.text.isEmpty ? widget.label : b.text,
                          _image == null
                              ? widget.imgPath
                              : _image.path.toString(),
                          widget.duration["hours"],
                          widget.duration['minutes']);

                      Navigator.pop(context);
                    }
                  : null,
            ),
          ),
          IconButton(
              onPressed: () {
                StudyModesDatabase().deleteMode(widget.index);
                Navigator.pop(context);
              },
              icon: Icon(Icons.delete))
        ],
      ),
    );
  }
}
