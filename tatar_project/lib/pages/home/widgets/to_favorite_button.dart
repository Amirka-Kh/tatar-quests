import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_peak/domain/trackers/quest_saved_tracker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/domain/models/quest_model.dart';

class SaveToFavouritesWidget extends ConsumerStatefulWidget {
  final Quest quest;
  const SaveToFavouritesWidget({super.key, required this.quest});

  @override
  ConsumerState<SaveToFavouritesWidget> createState() =>
      _SaveToFavouritesWidgetState();
}

class _SaveToFavouritesWidgetState
    extends ConsumerState<SaveToFavouritesWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: QuestSavedTracker.containQuest(widget.quest),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool isSaved = snapshot.data!;
            return GestureDetector(
                child: Container(
                    width: 50.0,
                    height: 50.0,
                    decoration: const BoxDecoration(
                      color: Color.fromARGB(180, 255, 255, 255),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isSaved ? Icons.favorite : Icons.favorite_border,
                      color: isSaved ? Colors.red : null,
                      semanticLabel: isSaved
                          ? AppLocalizations.of(context)!.removeFromSaved
                          : AppLocalizations.of(context)!.save,
                    )),
                onTap: () {
                  setState(() {
                    if (!isSaved) {
                      QuestSavedTracker.addQuest(widget.quest);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              AppLocalizations.of(context)!.questWasSaved)));
                    } else {
                      QuestSavedTracker.deleteQuest(widget.quest);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                              AppLocalizations.of(context)!.questWasRemoved)));
                    }
                  });
                });
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
