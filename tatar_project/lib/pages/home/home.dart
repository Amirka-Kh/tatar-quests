import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:quest_peak/domain/providers/settings_provider.dart';
import 'package:quest_peak/domain/providers/style_provider.dart';
import 'package:quest_peak/domain/fetchers/quest_fetcher.dart';
import 'package:quest_peak/domain/models/quest_model.dart';
import 'package:quest_peak/domain/trackers/quest_saved_tracker.dart';
import 'package:quest_peak/domain/trackers/quest_solved_tracker.dart';
import 'package:quest_peak/domain/models/settings_model.dart';
import 'package:quest_peak/pages/add_quest/add_quest.dart';
import 'package:quest_peak/pages/home/widgets/quest.dart';
import 'package:quest_peak/pages/home/widgets/quest_details.dart';
import 'package:quest_peak/pages/settings/settings.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePage();
}

class _HomePage extends ConsumerState<HomePage> {
  late PageController _pageController;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 1.0,
      initialPage: currentPage,
      keepPage: false,
    );
  }

  Future<List<Quest>> getListQuests() async {
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

  List<Widget> buildList(List<Quest> list) {
    List<Widget> list2 = [];
    for (int i = 0; i < list.length; i++) {
      list2.add(QuestWidget(
        quest: list[i],
        pageController: _pageController,
        currentPage: i,
      ));
    }
    return list2;
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.applicationName),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _pushAddQuest,
            tooltip: AppLocalizations.of(context)!.addQuest,
          ),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: _pushSaved,
            tooltip: AppLocalizations.of(context)!.savedSuggestions,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _pushSettings,
            tooltip: AppLocalizations.of(context)!.settings,
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: FutureBuilder<List<Quest>>(
                future: getListQuests(),
                builder: (context, snapshot) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(left: 32.0, top: 8.0),
                          child: RichText(
                            text: TextSpan(children: [
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .innopolisSecrets1,
                                  style: appTheme.display1()),
                              const TextSpan(text: "\n"),
                              TextSpan(
                                  text: AppLocalizations.of(context)!
                                      .innopolisSecrets2,
                                  style: appTheme.display2()),
                            ]),
                          )),
                      Expanded(
                          child: (snapshot.hasData)
                              ? (PageView(
                                  physics: const ClampingScrollPhysics(),
                                  children: buildList(snapshot.data!),
                                ))
                              : (snapshot.hasError)
                                  ? Text(
                                      AppLocalizations.of(context)!
                                          .connectionError,
                                      style: appTheme.display2(),
                                    )
                                  : const Center(
                                      child: SizedBox(
                                      width: 32,
                                      height: 32,
                                      child: CircularProgressIndicator(),
                                    )))
                    ],
                  );
                })),
      ),
    );
  }

  void _pushAddQuest() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const AddQuestPage()));
  }

  void _pushSaved() {
    final appTheme = ref.watch(themeProvider);

    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) {
          return Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context)!.savedSuggestions),
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
                                  transitionDuration:
                                      const Duration(milliseconds: 400),
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
                      ));
                    }
                  }));
        },
      ),
    );
  }

  void _pushSettings() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => const SettingsPage()));
  }
}
