import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_peak/domain/models/settings_model.dart';

final darkModeProvider =
    StateNotifierProvider<DarkModeClass, bool>((ref) => DarkModeClass(false));

class DarkModeClass extends StateNotifier<bool> {
  DarkModeClass(super.state);

  void set(bool s) {
    state = s;
  }
}

final filterProvider = StateNotifierProvider<FilterClass, FilterType>(
    (ref) => FilterClass(FilterType.all));

class FilterClass extends StateNotifier<FilterType> {
  FilterClass(super.state);

  void set(FilterType s) {
    state = s;
  }
}
