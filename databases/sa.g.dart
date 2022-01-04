// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sa.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubjectsAdapter extends TypeAdapter<Subjects> {
  @override
  final int typeId = 0;

  @override
  Subjects read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subjects(
      subjectName: fields[0] as String,
      colorsList: (fields[1] as List)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, Subjects obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.subjectName)
      ..writeByte(1)
      ..write(obj.colorsList);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
