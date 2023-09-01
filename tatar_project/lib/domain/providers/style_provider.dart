import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_peak/config/styles.dart';

final themeProvider =
    StateNotifierProvider<ThemeNotifier, AppTheme>((ref) => ThemeNotifier());

class ThemeNotifier extends StateNotifier<AppTheme> {
  ThemeNotifier() : super(AppThemeDefault());
  void set(AppTheme theme) {
    state = theme;
  }
}
