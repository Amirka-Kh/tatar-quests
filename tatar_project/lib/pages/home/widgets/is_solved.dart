import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_peak/domain/providers/quest_provider.dart';
import 'package:quest_peak/domain/trackers/quest_solved_tracker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/domain/models/quest_model.dart';

class IsSolvedWidget extends ConsumerStatefulWidget {
  final Quest quest;
  const IsSolvedWidget({super.key, required this.quest});

  @override
  ConsumerState<IsSolvedWidget> createState() => _IsSolvedWidget();
}

class _IsSolvedWidget extends ConsumerState<IsSolvedWidget> {
  @override
  Widget build(BuildContext context) {
    ref.watch(questSolvedProvider);

    return FutureBuilder<bool>(
        future: QuestSolvedTracker.containQuest(widget.quest),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            bool isFinished = snapshot.data!;
            return GestureDetector(
              child: Container(
                  width: 50.0,
                  height: 50.0,
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(180, 255, 255, 255),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isFinished
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    size: 40,
                    color: isFinished ? Colors.green : null,
                    semanticLabel: isFinished
                        ? AppLocalizations.of(context)!.isSolved
                        : AppLocalizations.of(context)!.isNotSolved,
                  )),
            );
          } else {
            return const CircularProgressIndicator();
          }
        });
  }
}
