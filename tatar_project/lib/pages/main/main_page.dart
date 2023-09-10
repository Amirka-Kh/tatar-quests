import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quest_peak/config/app_locale_extension.dart';

import '../../domain/fetchers/quest_fetcher.dart';
import '../../domain/models/quest_model.dart';
import '../../domain/models/settings_model.dart';
import '../../domain/providers/settings_provider.dart';
import '../../domain/providers/style_provider.dart';
import '../../domain/trackers/quest_solved_tracker.dart';
import '../home/widgets/quest.dart';

class MainPage extends ConsumerStatefulWidget {
  const MainPage({super.key});

  @override
  ConsumerState<MainPage> createState() => _MainPage();
}

class _MainPage extends ConsumerState<MainPage> {
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
    // TODO -
    List<Widget> list2 = [];
    for (int i = 0; i < list.length; i++) {
      list2.add(
        QuestWidget(
          quest: list[i],
          pageController: _pageController,
          currentPage: i,
        ),
      );
    }
    return list2;
  }

  @override
  Widget build(BuildContext context) {
    final appTheme = ref.watch(themeProvider);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: FutureBuilder<List<Quest>>(
          future: getListQuests(),
          builder: (context, snapshot) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 32.0, top: 30.0),
                  child: RichText(
                    text: TextSpan(
                      style: appTheme.display1(),
                      children: [
                        TextSpan(
                          text: 'Tatar',
                          style: appTheme.display1().copyWith(
                                color: Colors.white,
                              ),
                        ),
                        const TextSpan(text: "\n"),
                        TextSpan(
                          text: 'Quest',
                          style: appTheme.display2().copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: (snapshot.hasData)
                      ? (PageView(
                          controller: _pageController,
                          physics: const ClampingScrollPhysics(),
                          children: buildList(snapshot.data!),
                        ))
                      : (snapshot.hasError)
                          ? Text(
                              '${context.locale.connectionError}\n${snapshot.error.toString()}',
                              style: appTheme.display2(),
                            )
                          : const Center(
                              child: SizedBox(
                                width: 32,
                                height: 32,
                                child: CircularProgressIndicator(),
                              ),
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
