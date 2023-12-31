import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:quest_peak/domain/providers/settings_provider.dart';
import 'package:quest_peak/domain/fetchers/quest_fetcher.dart';
import 'package:quest_peak/domain/trackers/quest_saved_tracker.dart';
import 'package:quest_peak/domain/trackers/quest_solved_tracker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quest_peak/domain/models/settings_model.dart';
import 'package:quest_peak/domain/trackers/settings_tracker.dart';
import 'package:quest_peak/pages/home/home2.dart';
import './domain/models/quest_model.dart';
import 'config/custom_error.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'config/firebase_options.dart';

void main() async {
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

    await Hive.initFlutter();
    Hive
      ..registerAdapter(QuestColorAdapter())
      ..registerAdapter(QuestAdapter())
      ..registerAdapter(FilterTypeAdapter())
      ..registerAdapter(SettingsAdapter());
    QuestSavedTracker.fetch();
    QuestSolvedTracker.fetch();
    QuestFetcher.fetch();
    runApp(const ProviderScope(child: MyApp()));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SettingsTracker.fetch(ref);

    return MaterialApp(
      title: 'Wnder',
      theme: ThemeData(
          brightness: Brightness.light,
          // backgroundColor: const Color(0xFF54795C),
          scaffoldBackgroundColor: const Color(0xFF54795C),
          colorScheme: const ColorScheme.light(background: Color(0xFF54795C),),
          appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white, foregroundColor: Colors.black)),
      darkTheme: ThemeData(brightness: Brightness.dark),
      themeMode: ref.watch(darkModeProvider) ? ThemeMode.dark : ThemeMode.light,
      builder: (BuildContext context, Widget? widget) {
        ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
          return CustomError(errorDetails: errorDetails);
        };
        return widget!;
      },
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      locale: const Locale('ru', 'KZ'),
      supportedLocales: const [
        Locale('en', ''),
        Locale('ru', ''),
        Locale('ru', 'KZ')
      ],
      home: const Home2Page(),
    );
  }
}
