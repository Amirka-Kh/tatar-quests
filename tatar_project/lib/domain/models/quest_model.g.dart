// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quest_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuestAdapter extends TypeAdapter<Quest> {
  @override
  final int typeId = 0;

  @override
  Quest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Quest(
      fields[0] as String,
      fields[1] as String,
      fields[2] as String,
      fields[3] as String,
      fields[4] as double,
      fields[5] as double,
      fields[6] as String,
      (fields[7] as List).cast<QuestColor>(),
    );
  }

  @override
  void write(BinaryWriter writer, Quest obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.description)
      ..writeByte(2)
      ..write(obj.question)
      ..writeByte(3)
      ..write(obj.answer)
      ..writeByte(4)
      ..write(obj.latitude)
      ..writeByte(5)
      ..write(obj.longitude)
      ..writeByte(6)
      ..write(obj.imagePath)
      ..writeByte(7)
      ..write(obj.colors);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class QuestColorAdapter extends TypeAdapter<QuestColor> {
  @override
  final int typeId = 1;

  @override
  QuestColor read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return QuestColor.lightGreen;
      case 1:
        return QuestColor.green;
      case 2:
        return QuestColor.darkRed;
      case 3:
        return QuestColor.red;
      default:
        return QuestColor.lightGreen;
    }
  }

  @override
  void write(BinaryWriter writer, QuestColor obj) {
    switch (obj) {
      case QuestColor.lightGreen:
        writer.writeByte(0);
        break;
      case QuestColor.green:
        writer.writeByte(1);
        break;
      case QuestColor.darkRed:
        writer.writeByte(2);
        break;
      case QuestColor.red:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is QuestColorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
