import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quest_peak/domain/providers/quest_provider.dart';
import 'package:quest_peak/config/string.dart';
import 'package:quest_peak/domain/providers/style_provider.dart';
import 'package:quest_peak/config/quest_geolocator.dart';
import 'package:quest_peak/domain/models/quest_model.dart';
import 'package:quest_peak/domain/trackers/quest_solved_tracker.dart';

class QuestDetailsWidget extends ConsumerStatefulWidget {
  final Quest quest;

  const QuestDetailsWidget({super.key, required this.quest});

  @override
  ConsumerState<QuestDetailsWidget> createState() => _QuestDetailsWidgetState();
}

class _QuestDetailsWidgetState extends ConsumerState<QuestDetailsWidget> {
  double latitude = 0.0, longitude = 0.0;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() async {
        QuestGeolocator.getPosition().then((position) {
          latitude = position.latitude;
          longitude = position.longitude;
        });
      });
    });
  }

  Future<bool> _onWillPop() async {
    timer.cancel();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(themeProvider);
    final screenHeight = MediaQuery.of(context).size.height;

    return WillPopScope(
        onWillPop: _onWillPop,
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand, // will use available space
            children: <Widget>[
              Hero(
                tag: 'background-${widget.quest.name}',
                child: DecoratedBox(
                    decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: toListColor(widget.quest.colors),
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                  ),
                )),
              ),
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 40),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 16, right: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            IconButton(
                              iconSize: 40,
                              icon: const Icon(Icons.close),
                              color: Colors.white.withOpacity(0.9),
                              onPressed: () {
                                timer.cancel();
                                Navigator.pop(context);
                              },
                            ),
                            Icon(Icons.lightbulb,
                                size: 40,
                                color: QuestGeolocator.distanceLess(
                                        longitude,
                                        latitude,
                                        widget.quest.longitude,
                                        widget.quest.latitude,
                                        QuestGeolocator.acceptanceDistance)
                                    ? Colors.yellow
                                    : null),
                            FutureBuilder<bool>(
                                future: QuestSolvedTracker.containQuest(
                                    widget.quest),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    bool isSolved = snapshot.data!;
                                    return Icon(
                                      isSolved
                                          ? Icons.check_box
                                          : Icons.check_box_outline_blank,
                                      size: 40,
                                      color: isSolved ? Colors.green : null,
                                      semanticLabel: isSolved
                                          ? AppLocalizations.of(context)!
                                              .isSolved
                                          : AppLocalizations.of(context)!
                                              .isNotSolved,
                                    );
                                  } else {
                                    return const CircularProgressIndicator();
                                  }
                                }),
                          ],
                        )),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8),
                      child: Hero(
                        tag: "image-${widget.quest.name}",
                        child: ClipOval(
                          child: Image.asset(
                            widget.quest.imagePath,
                            height: screenHeight * 0.4,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 8),
                      child: Material(
                          color: Colors.transparent,
                          child: Text(widget.quest.name,
                              style: appTheme.heading())),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 8, 30),
                      child: Text(widget.quest.description,
                          style: appTheme.subHeading()),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 0, 8, 20),
                      child: Text(widget.quest.question,
                          style: appTheme.subHeading()),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: TextField(
                        style: appTheme.subHeading(),
                        cursorColor: Colors.white,
                        onSubmitted: (text) {
                          if (checkAnswer(widget.quest.answer, text)) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 2),
                                content: Text(AppLocalizations.of(context)!
                                    .correctAnswer)));
                            QuestSolvedTracker.addQuest(widget.quest);
                            ref
                                .watch(questSolvedProvider.notifier)
                                .set(!ref.watch(questSolvedProvider));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                duration: const Duration(seconds: 2),
                                content: Text(AppLocalizations.of(context)!
                                    .incorrectAnswer)));
                          }
                        },
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.enterYourAnswer,
                          labelStyle: const TextStyle(color: Colors.white),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                            ),
                          ),
                          enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.white,
                              width: 2.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
