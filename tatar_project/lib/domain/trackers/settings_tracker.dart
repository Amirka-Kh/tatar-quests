import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:quest_peak/config/styles.dart';
import 'package:quest_peak/domain/models/settings_model.dart';
import 'package:quest_peak/domain/providers/settings_provider.dart';
import 'package:quest_peak/domain/providers/style_provider.dart';

class SettingsTracker {
  static const boxName = 'settingsData';
  static late Settings settings;

  static void fetch(WidgetRef ref) async {
    var box = await Hive.openBox<Settings>(boxName);
    settings =
        box.get('settings', defaultValue: Settings(false, FilterType.all))!;
    ref.watch(darkModeProvider.notifier).set(settings.darkMode);
    ref.watch(filterProvider.notifier).set(settings.filter);
    if (!settings.darkMode) {
      ref.watch(themeProvider.notifier).set(AppThemeDefault());
    } else {
      ref.watch(themeProvider.notifier).set(AppThemeDark());
    }
  }

  static void store(WidgetRef ref) async {
    bool darkMode = ref.watch(darkModeProvider);
    FilterType filter = ref.watch(filterProvider);
    settings = Settings(darkMode, filter);
    var box = await Hive.openBox<Settings>(boxName);
    box.put('settings', settings);
  }

  static void delete(WidgetRef ref) async {
    var box = await Hive.openBox<Settings>(boxName);
    box.clear();
    settings = Settings(false, FilterType.all);
  }
}
