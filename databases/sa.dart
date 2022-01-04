import 'package:hive/hive.dart';

part 'sa.g.dart';

@HiveType(typeId: 0)
class Subjects extends HiveObject {
  @HiveField(0)
  String subjectName;
  @HiveField(1)
  List colorsList;

  Subjects({this.subjectName, this.colorsList});
}
