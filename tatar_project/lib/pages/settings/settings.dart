import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_peak/domain/providers/settings_provider.dart';
import 'package:quest_peak/domain/providers/style_provider.dart';
import 'package:quest_peak/domain/trackers/quest_saved_tracker.dart';
import 'package:quest_peak/domain/trackers/quest_solved_tracker.dart';
import 'package:quest_peak/domain/models/settings_model.dart';
import 'package:quest_peak/domain/trackers/settings_tracker.dart';
import 'package:toggle_switch/toggle_switch.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPage();
}

class _SettingsPage extends ConsumerState<SettingsPage> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(themeProvider);

    darkMode = ref.watch(darkModeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.all(32.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(AppLocalizations.of(context)!.darkMode,
                        style: appTheme.subHeading()),
                    Switch(
                        value: darkMode,
                        onChanged: (value) {
                          setState(() {
                            ref.watch(darkModeProvider.notifier).set(value);
                            darkMode = value;
                            SettingsTracker.store(ref);
                          });
                        }),
                  ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(AppLocalizations.of(context)!.filter,
                      style: appTheme.subHeading()),
                  ToggleSwitch(
                    initialLabelIndex: filterToInt(ref.watch(filterProvider)),
                    totalSwitches: 3,
                    isVertical: true,
                    minWidth: 150,
                    labels: [
                      AppLocalizations.of(context)!.all,
                      AppLocalizations.of(context)!.solved,
                      AppLocalizations.of(context)!.notSolved
                    ],
                    onToggle: (index) {
                      FilterType value = intToFilter(index!);
                      ref.watch(filterProvider.notifier).set(value);
                      SettingsTracker.store(ref);
                    },
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(AppLocalizations.of(context)!.resetText,
                      style: appTheme.subHeading()),
                  ElevatedButton(
                      child: Text(AppLocalizations.of(context)!.reset),
                      onPressed: () => showDialog<String>(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                                title:
                                    Text(AppLocalizations.of(context)!.reset),
                                content: Text(
                                    AppLocalizations.of(context)!.resetInfo),
                                actions: <Widget>[
                                  TextButton(
                                    child:
                                        Text(AppLocalizations.of(context)!.yes),
                                    onPressed: () {
                                      SettingsTracker.delete(ref);
                                      QuestSavedTracker.delete();
                                      QuestSolvedTracker.delete();
                                      Navigator.of(context).pop();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content: Text(
                                                  AppLocalizations.of(context)!
                                                      .resetDone)));
                                    },
                                  ),
                                  TextButton(
                                    child:
                                        Text(AppLocalizations.of(context)!.no),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ]);
                          }))
                ],
              )
            ])),
      ),
    );
  }
}
