import 'package:hive_flutter/hive_flutter.dart';

part 'settings_model.g.dart';

@HiveType(typeId: 2)
class Settings {
  @HiveField(0)
  final bool darkMode;
  @HiveField(1)
  final FilterType filter;

  Settings(this.darkMode, this.filter);
}

@HiveType(typeId: 3)
enum FilterType {
  @HiveField(0)
  all,
  @HiveField(1)
  solved,
  @HiveField(2)
  notSolved
}

int filterToInt(FilterType x) {
  switch (x) {
    case FilterType.all:
      return 0;
    case FilterType.solved:
      return 1;
    case FilterType.notSolved:
      return 2;
  }
}

FilterType intToFilter(int x) {
  switch (x) {
    case 0:
      return FilterType.all;
    case 1:
      return FilterType.solved;
    case 2:
      return FilterType.notSolved;
  }
  return FilterType.all;
}
