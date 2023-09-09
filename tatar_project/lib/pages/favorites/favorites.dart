import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_peak/config/app_locale_extension.dart';
import 'package:quest_peak/domain/models/quest_model.dart';
import 'package:quest_peak/pages/home/widgets/quest_details.dart';

import '../../domain/fetchers/quest_fetcher.dart';
import '../../domain/models/settings_model.dart';
import '../../domain/providers/settings_provider.dart';
import '../../domain/providers/style_provider.dart';
import '../../domain/trackers/quest_saved_tracker.dart';
import '../../domain/trackers/quest_solved_tracker.dart';

class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  Future<List<Quest>> getListQuests(WidgetRef ref) async {
    late List<Quest> quests, solvedQuests;
    await QuestFetcher.quests.then((list) => quests = list);
    await QuestSolvedTracker.getQuests().then((list) => solvedQuests = list);
    switch (ref.watch(filterProvider)) {
      case FilterType.all:
        return quests;
      case FilterType.solved:
        return solvedQuests;
      case FilterType.notSolved:
        return quests.where((x) => !solvedQuests.contains(x)).toList();
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appTheme = ref.watch(themeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(context.locale.savedSuggestions),
      ),
      body: FutureBuilder<List<Quest>>(
        future: QuestSavedTracker.getQuests(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final tiles = snapshot.data!.map(
              (quest) {
                return ListTile(
                  title: Text(
                    quest.name,
                    style: appTheme.display2(),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (context, _, __) {
                          return QuestDetailsWidget(quest: quest);
                        },
                      ),
                    );
                  },
                );
              },
            );
            final divided = tiles.isNotEmpty
                ? ListTile.divideTiles(
                    context: context,
                    tiles: tiles,
                  ).toList()
                : <Widget>[];
            return ListView(children: divided);
          } else {
            return const Center(
              child: SizedBox(
                width: 32,
                height: 32,
                child: CircularProgressIndicator(),
              ),
            );
          }
        },
      ),
    );
  }
}
