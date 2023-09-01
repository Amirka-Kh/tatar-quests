import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

part 'quest_model.g.dart';

@HiveType(typeId: 0)
class Quest {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String description;
  @HiveField(2)
  final String question;
  @HiveField(3)
  final String answer;
  @HiveField(4)
  final double latitude;
  @HiveField(5)
  final double longitude;
  @HiveField(6)
  final String imagePath;
  @HiveField(7)
  final List<QuestColor> colors;
  // final List<Color> colors; // Does Hive have provider for Color?

  Quest(this.name, this.description, this.question, this.answer, this.latitude,
      this.longitude, this.imagePath, this.colors);
}

@HiveType(typeId: 1)
enum QuestColor {
  @HiveField(0)
  lightGreen,
  @HiveField(1)
  green,
  @HiveField(2)
  darkRed,
  @HiveField(3)
  red,
}

QuestColor toQuestColor(String string) {
  switch (string) {
    case 'lightGreen':
      return QuestColor.lightGreen;
    case 'green':
      return QuestColor.green;
    case 'darkRed':
      return QuestColor.darkRed;
    case 'red':
      return QuestColor.red;
    default:
      throw 'Color not defined';
  }
}

String fromQuestColor(QuestColor string) {
  switch (string) {
    case QuestColor.lightGreen:
      return 'lightGreen';
    case QuestColor.green:
      return 'green';
    case QuestColor.darkRed:
      return 'darkRed';
    case QuestColor.red:
      return 'red';
    default:
      throw 'Color not defined';
  }
}

List<QuestColor> toListQuestColor(List<String> list) {
  List<QuestColor> list2 = [];
  for (String string in list) {
    list2.add(toQuestColor(string));
  }
  return list2;
}

List<String> fromListQuestColor(List<QuestColor> list) {
  List<String> list2 = [];
  for (QuestColor color in list) {
    list2.add(fromQuestColor(color));
  }
  return list2;
}

Color getColor(QuestColor color) {
  switch (color) {
    case QuestColor.lightGreen:
      return Colors.lightGreen.shade200;
    case QuestColor.green:
      return Colors.green.shade800;
    case QuestColor.darkRed:
      return const Color.fromARGB(255, 131, 24, 24);
    case QuestColor.red:
      return const Color.fromARGB(255, 255, 6, 56);
  }
}

List<Color> toListColor(List<QuestColor> list) {
  List<Color> list2 = [];
  for (int i = 0; i < list.length; i++) {
    list2.add(getColor(list[i]));
  }
  return list2;
}
