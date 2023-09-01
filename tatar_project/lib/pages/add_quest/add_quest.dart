import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quest_peak/domain/fetchers/quest_fetcher.dart';
import 'package:quest_peak/domain/providers/style_provider.dart';
import 'package:quest_peak/domain/models/quest_model.dart';

class AddQuestPage extends ConsumerStatefulWidget {
  const AddQuestPage({super.key});

  @override
  ConsumerState<AddQuestPage> createState() => _AddQuestPage();
}

class _AddQuestPage extends ConsumerState<AddQuestPage> {
  String name = "";
  String description = "";
  String question = "";
  String answer = "";
  double latitude = 0.0;
  double longitude = 0.0;
  String image = "";
  String color1 = "";
  String color2 = "";
  final _formKey = GlobalKey<FormState>();

  void submitQuest() {
    Quest quest = Quest(
        name,
        description,
        question,
        answer,
        latitude,
        longitude,
        "assets/quest/$image.jpg",
        [toQuestColor(color1), toQuestColor(color2)]);
    QuestFetcher.addQuest(quest);
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.addQuest),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${AppLocalizations.of(context)!.name}: $name",
                              style: appTheme.subHeading()),
                          TextFormField(
                            onSaved: (value) => name = value!,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .stringIsEmpty;
                              }
                              return null;
                            },
                          ),
                          Text(
                              "${AppLocalizations.of(context)!.description}: $description",
                              style: appTheme.subHeading()),
                          TextFormField(
                            onSaved: (value) => description = value!,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .stringIsEmpty;
                              }
                              return null;
                            },
                          ),
                          Text(
                              "${AppLocalizations.of(context)!.question}: $question",
                              style: appTheme.subHeading()),
                          TextFormField(
                            onSaved: (value) => question = value!,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .stringIsEmpty;
                              }
                              return null;
                            },
                          ),
                          Text(
                              "${AppLocalizations.of(context)!.answer}: $answer",
                              style: appTheme.subHeading()),
                          TextFormField(
                            onSaved: (value) => answer = value!,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .stringIsEmpty;
                              }
                              return null;
                            },
                          ),
                          Text(
                              "${AppLocalizations.of(context)!.latitude}: $latitude",
                              style: appTheme.subHeading()),
                          TextFormField(
                            onSaved: (value) => latitude = double.parse(value!),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .stringIsEmpty;
                              }
                              if (double.tryParse(value) == null) {
                                return AppLocalizations.of(context)!
                                    .stringIsNotFloat;
                              }
                              return null;
                            },
                          ),
                          Text(
                              "${AppLocalizations.of(context)!.longitude}: $longitude",
                              style: appTheme.subHeading()),
                          TextFormField(
                            onSaved: (value) =>
                                longitude = double.parse(value!),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .stringIsEmpty;
                              }
                              if (double.tryParse(value) == null) {
                                return AppLocalizations.of(context)!
                                    .stringIsNotFloat;
                              }
                              return null;
                            },
                          ),
                          Text("${AppLocalizations.of(context)!.image}: $image",
                              style: appTheme.subHeading()),
                          TextFormField(
                            onSaved: (value) => image = value!,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .stringIsEmpty;
                              }
                              return null;
                            },
                          ),
                          Text(
                              "${AppLocalizations.of(context)!.color1}: $color1",
                              style: appTheme.subHeading()),
                          TextFormField(
                            onSaved: (value) => color1 = value!,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .stringIsEmpty;
                              }
                              return null;
                            },
                          ),
                          Text(
                              "${AppLocalizations.of(context)!.color2}: $color2",
                              style: appTheme.subHeading()),
                          TextFormField(
                            onSaved: (value) => color2 = value!,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .stringIsEmpty;
                              }
                              return null;
                            },
                          ),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                submitQuest();
                              }
                            },
                            child: Text(
                                AppLocalizations.of(context)!.submitQuest,
                                style: appTheme.subHeading()),
                          ),
                        ])))),
      ),
    );
  }
}
