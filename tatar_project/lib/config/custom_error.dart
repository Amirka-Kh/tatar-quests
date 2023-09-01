import 'package:firebase_crashlytics/firebase_crashlytics.dart'; // Seems, this day has come
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_peak/domain/providers/style_provider.dart';

class CustomError extends ConsumerWidget {
  final FlutterErrorDetails errorDetails;
  const CustomError({Key? key, required this.errorDetails}) : super(key: key);

  String errorLog() {
    String message;
    try {
      message = "ERROR\n\n${errorDetails.exception}\n\n";
      List<String> stackTrace = errorDetails.stack.toString().split("\n");
      int length = stackTrace.length > 5 ? 5 : stackTrace.length;
      for (int i = 0; i < length; i++) {
        message += "${stackTrace[i]}\n";
      }
    } catch (e) {
      message = "FATAL ERROR";
    }
    return message;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider);

    if (!kDebugMode) {
      FirebaseCrashlytics.instance.log(errorLog());
    }
    return Scaffold(
        body: Padding(
            padding: const EdgeInsets.all(16),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Image.asset('assets/icon/icon.png'),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    AppLocalizations.of(context)!.anErrorHasOccured,
                    style: appTheme.subHeading(),
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Text(
                      kDebugMode
                          ? errorLog()
                          : AppLocalizations.of(context)!.theDeveloperNotified,
                      style: appTheme.subHeading()),
                ),
              ],
            ))));
  }
}
