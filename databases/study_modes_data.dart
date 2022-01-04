import 'package:hive_flutter/hive_flutter.dart';

class StudyModesDatabase {
  Box box = Hive.box("Study_Modes");

  void addModes() {
    box.put(0, {
      "mode": "Beach Mode",
      "label": "A chill Topic",
      "intensity": 0,
      'imageSrc': "assets/beach.jpg",
      'duration': {"hours": 00, "minutes": 15}
    });

    box.put(1, {
      "mode": "Revision Mode",
      "label": "Strong Revision",
      "intensity": 1,
      'imageSrc': "assets/revision.jpg",
      'duration': {"hours": 00, "minutes": 30}
    });
    box.put(2, {
      "mode": "Workout Mode",
      "label": "Focus Hard",
      "intensity": 2,
      "imageSrc": "assets/workout.png",
      'duration': {"hours": 1, "minutes": 20}
    });
    box.put(3, {
      "mode": "Batman Mode",
      "label": "Deep Focus",
      "intensity": 3,
      "imageSrc": "assets/batman.jpg",
      'duration': {"hours": 3, "minutes": 00}
    });
    box.put(4, {
      "mode": "Super Sayian Mode",
      "label": "Deepest Focus",
      "intensity": 4,
      'imageSrc': "assets/super_sayain.jpg",
      'duration': {"hours": 4, "minutes": 00}
    });
  }

  void editMode(int index, mode, label, imageSrc, int hours, int minutes) {
    box.delete(index);
    box.put(index, {
      "mode": mode,
      "label": label,
      "intensity": index,
      'imageSrc': imageSrc,
      'duration': {"hours": hours, "minutes": minutes}
    });
  }

  void add(index, mode, label, imageSrc, int hours, int minutes) {
    box.put(index, {
      "mode": mode,
      "label": label,
      "intensity": index,
      'imageSrc': imageSrc,
      'duration': {"hours": hours, "minutes": minutes}
    });
  }

  void deleteMode(index) {
    box.delete(index);
  }
}
